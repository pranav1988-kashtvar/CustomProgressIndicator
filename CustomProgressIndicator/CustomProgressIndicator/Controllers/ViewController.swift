//
//  ViewController.swift
//  CustomProgressIndicator
//
//  Created by Shi Pra on 15/10/22.
//

import UIKit

class ViewController: UIViewController {
    
    // MARK: Properties
    var navigationHeightConstraint: NSLayoutConstraint!
    var items: [TableViewModel] = []
    var slider: HorizontalItemList!
    var isMenuOpen: Bool = false
    var selectedImgShown: Bool = false
    
    // MARK: View Properties
    let navigationView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.groupTableViewBackground
        return view
    }()
    let titleLbl: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.text = "Packing List"
        lbl.font = UIFont.systemFont(ofSize: 24)
        lbl.textColor = .black
        return lbl
    }()
    lazy var rightBarBtnItem: UIButton = {
        let btn = UIButton()
        btn.setTitle("+", for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 27, weight: .bold)
        btn.setTitleColor(UIColor.systemBlue, for: .normal)
        btn.addTarget(self, action: #selector(plusBtnPressed), for: .touchUpInside)
        return btn
    }()
    let tableView: UITableView = {
        let table = UITableView()
        table.backgroundColor = UIColor.systemBlue
        table.separatorStyle = .none
        return table
    }()
    let selectedImage: UIImageView = {
        let img = UIImageView()
        img.contentMode = .scaleAspectFit
        img.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.6)
        img.layer.cornerRadius = 5.0
        img.layer.shadowRadius = 2.0
        img.layer.shadowColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 1).cgColor
        img.layer.shadowOpacity = 0.5
        img.layer.shadowOffset = CGSize(width: 2, height: 2)
        return img
    }()
    lazy var refreshView: RefreshView = {
        let rv = RefreshView(imgStr: "refresh-view-bg", scroll: self.tableView)
        return rv
    }()
    
    
    // MARK: Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.groupTableViewBackground
        fetchDataFromAPI()
        configureAndAddNavigationView()
        configureAndAddTableView()
        addRefreshView()
        addSelectedImage()
    }
    
    
    // MARK: Helper Methods
    func fetchDataFromAPI() {
        let data = TableModel.getTableData()
        items = TableViewModel.getViewModelData(modelData: data)
    }
    
    func configureAndAddNavigationView() {
        addNavigationChild()
        view.addSubview(navigationView)
        navigationHeightConstraint =  navigationView.heightAnchor.constraint(equalToConstant: isMenuOpen ? 140 : 44)
        navigationHeightConstraint.isActive = true
        navigationView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leadingAnchor, right: view.trailingAnchor)
    }
    
    func addNavigationChild() {
        navigationView.addSubview(titleLbl)
        navigationView.addSubview(rightBarBtnItem)
        let centerYConstraint = titleLbl.centerYAnchor.constraint(equalTo: navigationView.centerYAnchor)
        centerYConstraint.identifier = "TitleCenterY"
        centerYConstraint.isActive = true
        titleLbl.centerXAnchor.constraint(equalTo: navigationView.centerXAnchor).isActive = true
        rightBarBtnItem.centerY(inView: titleLbl, rightAnchor: navigationView.trailingAnchor, paddingRight: 8)
    }
    
    func configureAndAddTableView() {
        tableView.register(TableViewCell.self, forCellReuseIdentifier: TableViewCell.identifier)
        tableView.dataSource = self
        tableView.delegate = self
        
        view.addSubview(tableView)
        tableView.anchor(top: navigationView.bottomAnchor, left: view.leadingAnchor, bottom: view.bottomAnchor, right: view.trailingAnchor)
    }
    
    func addRefreshView() {
        view.addSubview(refreshView)
        refreshView.anchor(top: navigationView.bottomAnchor, left: view.leadingAnchor, right: view.trailingAnchor)
        refreshView.refreshHeightConstraint = refreshView.heightAnchor.constraint(equalToConstant: 0)
    }
    
    func addSelectedImage() {
        view.addSubview(selectedImage)
        selectedImage.centerX(inView: self.view)
        selectedImage.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.33, constant: -50).isActive = true
        selectedImage.heightAnchor.constraint(equalTo: selectedImage.widthAnchor).isActive = true
        selectedImage.anchor(bottom: view.bottomAnchor, paddingBottom: -100)
    }
    
    @objc func plusBtnPressed() {
        isMenuOpen = !isMenuOpen
        navigationHeightConstraint.constant = isMenuOpen ? 140 : 44
        titleLbl.text = isMenuOpen ? "Select Item" : "Packing List"
        titleLbl.superview?.constraints.forEach({ constraint in
            if constraint.firstItem === titleLbl && constraint.firstAttribute == .centerX {
                constraint.constant = isMenuOpen ? -100 : 0.0
                return
            }
            if constraint.identifier == "TitleCenterY" {
                constraint.isActive = false
                addNewConstraint()
                return
            }
        })
        UIView.animate(withDuration: 1.0, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 5.0) {
            let angle: CGFloat = self.isMenuOpen ? CGFloat.pi / 4.0 : 0.0
            self.rightBarBtnItem.transform = CGAffineTransform(rotationAngle: angle)
            self.view.layoutIfNeeded()
        }
        
        if isMenuOpen {
            slider = HorizontalItemList(inView: navigationView)
            slider.didSelectItem = {index in
                let model = TableViewModel(image: "summericons_100px_0\(index)", title: "Cell Title For \(self.items.count)")
                self.items.append(model)
                self.tableView.reloadData()
                self.plusBtnPressed()
            }
            self.navigationView.addSubview(slider)
        }else {
            slider.removeFromSuperview()
        }
    }
    
    func addNewConstraint() {
        let newConstraint = NSLayoutConstraint(
            item: titleLbl,
            attribute: .centerY,
            relatedBy: .equal,
            toItem: navigationView,
            attribute: .centerY,
            multiplier: isMenuOpen ? 0.40 : 1.0,
            constant: 0)
        newConstraint.identifier = "TitleCenterY"
        newConstraint.isActive = true
    }
    
}

// MARK: Implement table view datasource and delegate
extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCell.identifier, for: indexPath) as? TableViewCell else {
            return UITableViewCell()
        }
        
        cell.dataModel = items[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        showItem(index: indexPath.row)
    }
    
    
}

// MARK: IMPLEMENT SCROLLVIEW DELEAGTE
extension ViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        refreshView.scrollViewDidScroll()
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        refreshView.scrollViewDidEndDragging()
    }
}

// MARK: SHOW SELECT TABLE ROW ANIMATION
extension ViewController {
    func showItem(index: Int) {
        let model = items[index]
        if !selectedImgShown {
            selectedImage.image = UIImage(named: model.image)
            showSelectedImageAnimation()
            selectedImgShown = true
        }else {
            hideAndShowSelectedImageAnimation(nextImg: model.image)
        }
    }
    
    func hideAndShowSelectedImageAnimation(nextImg: String) {
        selectedImage.superview?.constraints.forEach({ constraint in
            if constraint.firstItem === selectedImage && constraint.firstAttribute == .bottom {
                constraint.constant = 100
            }
            if constraint.firstItem === selectedImage && constraint.firstAttribute == .width {
                constraint.constant = -50.0
            }
        })
        
        UIView.animate(withDuration: 0.6, delay: 0.0, usingSpringWithDamping: 0.4, initialSpringVelocity: 0.0) {
            self.view.layoutIfNeeded()
        } completion: { _ in
            self.selectedImage.image = UIImage(named: nextImg)
            self.showSelectedImageAnimation()
        }
    }
    
    func showSelectedImageAnimation() {
        selectedImage.superview?.constraints.forEach({ constraint in
            if constraint.firstItem === selectedImage && constraint.firstAttribute == .bottom {
                constraint.constant = -20
            }
            if constraint.firstItem === selectedImage && constraint.firstAttribute == .width {
                constraint.constant = 0.0
            }
        })
        
        UIView.animate(withDuration: 0.3, delay: 0.0, usingSpringWithDamping: 0.4, initialSpringVelocity: 0.0) {
            self.view.layoutIfNeeded()
        }
    }
}

