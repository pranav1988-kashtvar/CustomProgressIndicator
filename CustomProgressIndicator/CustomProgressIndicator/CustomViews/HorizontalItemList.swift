//
//  HorizontalItemList.swift
//  CustomProgressIndicator
//
//  Created by Shi Pra on 15/10/22.
//

import UIKit

class HorizontalItemList: UIScrollView {
    
    // MARK: Properties
    var didSelectItem: ((_ index: Int)->())?
    let buttonWidth: CGFloat = 60.0
    let padding: CGFloat = 10.0
    let numberOfItems: Int = 10
    
    // MARK: Initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        showsHorizontalScrollIndicator = false
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    convenience init(inView: UIView) {
        let rect = CGRect(x: inView.bounds.width, y: 54, width: inView.frame.size.width, height: 80)
        self.init(frame: rect)
        
        alpha = 0.0
        for i in 0..<numberOfItems {
            let image = UIImage(named: "summericons_100px_0\(i)")
            let imgView = UIImageView(image: image)
            let xPoint = CGFloat(i) * buttonWidth + padding * CGFloat(i + 1)
            let yPoint = padding
            imgView.frame = CGRect(x: xPoint, y: yPoint, width: buttonWidth, height: buttonWidth)
            imgView.tag = i
            imgView.isUserInteractionEnabled = true
            addSubview(imgView)
            
            let tap = UITapGestureRecognizer(target: self, action: #selector(HorizontalItemList.didTapImage(_:)))
            imgView.addGestureRecognizer(tap)
        }
        let contentWidth =  padding * CGFloat(numberOfItems + 1) + buttonWidth * CGFloat(numberOfItems)
        contentSize = CGSize(width: contentWidth, height:  buttonWidth + 2*padding)
        
        
    }
    
    // MARK: Lifecycle Methods
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
          
        guard superview != nil else {
            return
        }
          
        UIView.animate(withDuration: 1.0, delay: 0.01, usingSpringWithDamping: 0.7,initialSpringVelocity: 5.0, options: .curveEaseIn) {
            self.alpha = 1.0
            self.center.x -= self.frame.size.width
        }
    }
    
    // MARK: Helper Methods
    @objc func didTapImage(_ tap: UITapGestureRecognizer) {
        didSelectItem?(tap.view!.tag)
    }
}
