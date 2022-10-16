//
//  TableViewCell.swift
//  CustomProgressIndicator
//
//  Created by Shi Pra on 15/10/22.
//

import UIKit

class TableViewCell: UITableViewCell {
    
    // MARK: Properties
    static let identifier = "TableCell"
    var dataModel: TableViewModel? {
        didSet {
            setupContent()
        }
    }
    
    // MARK: View Properties
    let image: UIImageView = {
        let img = UIImageView()
        img.contentMode = .scaleAspectFit
        return img
    }()
    
    let title: UILabel = {
        let title = UILabel()
        title.textColor = .black
        title.numberOfLines = 0
        return title
    }()
    
    let seperatorLine: UIView = {
        let seperator = UIView()
        seperator.backgroundColor = UIColor.systemBlue
        return seperator
    }()
    
    // MARK: Initializer
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    // MARK: Lifecycle Methods
    
    // MARK: Helper Methods
    func setupViews() {
        contentView.addSubview(image)
        contentView.addSubview(title)
        contentView.addSubview(seperatorLine)
        
        image.setDimensions(width: 44, height: 44)
        image.centerY(inView: contentView, leftAnchor: contentView.leadingAnchor, paddingLeft: 8)
        image.topAnchor.constraint(greaterThanOrEqualTo: contentView.topAnchor, constant: 8).isActive = true
        image.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: 8).isActive = true
        title.anchor(top:contentView.topAnchor, left: image.trailingAnchor, bottom: contentView.bottomAnchor, right: contentView.trailingAnchor, paddingTop: 8, paddingLeft: 15, paddingBottom: 8.6, paddingRight: 8)
        seperatorLine.anchor(left: title.leadingAnchor, bottom: contentView.bottomAnchor, right: contentView.trailingAnchor, height: 0.6)
    }
    func setupContent() {
        guard let model = dataModel else {
            return
        }
        image.image = UIImage(named: model.image)
        title.text = model.title
    }
}
