//
//  RefreshView.swift
//  CustomProgressIndicator
//
//  Created by Shi Pra on 16/10/22.
//

import UIKit

func delay(seconds: Double, completion: @escaping ()-> Void) {
  DispatchQueue.main.asyncAfter(deadline: .now() + seconds, execute: completion)
}
class RefreshView: UIImageView {
    
    // MARK: Properties
    var ovalShapeLayer: CAShapeLayer!
    var imgStr: String!
    var isRefresing: Bool = false
    var refreshHeightConstraint: NSLayoutConstraint! {
        didSet {
            refreshHeightConstraint.isActive = true
        }
    }
    var scrollView: UIScrollView!
    
    // MARK: Initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentMode = .scaleAspectFill
        clipsToBounds = true
    }
    
    convenience init(imgStr: String, scroll: UIScrollView) {
        self.init(frame: .zero)
        self.imgStr = imgStr
        self.scrollView = scroll
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    // MARK: Helper Methods
    func setupView() {
        image = UIImage(named: imgStr)
    }
    
    func scrollViewDidScroll() {
        let yOffset = scrollView.contentOffset.y
        print(yOffset)
        if yOffset < 0 {
            refreshHeightConstraint.constant = abs(yOffset)
            UIView.animate(withDuration: 0.3, delay: 0) {
                self.superview?.layoutIfNeeded()
                self.layoutIfNeeded()
            }
        }
    }
    
    func scrollViewDidEndDragging() {
        let yOffset = scrollView.contentOffset.y
        
        if yOffset < 0  && abs(yOffset) >= 120 {
            scrollView.contentInset.top = min(abs(yOffset), 120)
            refreshHeightConstraint.constant = 120
            UIView.animate(withDuration: 0.3, delay: 0) {
                self.superview?.layoutIfNeeded()
                self.startRefreshing()
            }
            delay(seconds: 3) {
                self.removeAnimation(scrollView: self.scrollView)
            }
        }else if yOffset < 0 && abs(yOffset) < 120 {
            refreshHeightConstraint.constant = 0
            UIView.animate(withDuration: 0.3, delay: 0.0) {
                self.superview?.layoutIfNeeded()
            }
        }
    }
    
    func addOvalShape() {
        if ovalShapeLayer == nil {
            ovalShapeLayer = CAShapeLayer()
            ovalShapeLayer.strokeColor = UIColor.white.cgColor
            ovalShapeLayer.fillColor = UIColor.clear.cgColor
            ovalShapeLayer.lineWidth = 4
            ovalShapeLayer.lineDashPattern = [2, 3]
            let refreshRadius = frame.size.height/2 * 0.8
            ovalShapeLayer.path = UIBezierPath(ovalIn: CGRect(
              x: frame.size.width/2 - refreshRadius,
              y: frame.size.height/2 - refreshRadius,
              width: 2 * refreshRadius,
              height: 2 * refreshRadius)
            ).cgPath
            ovalShapeLayer.strokeStart = 1.0
            layer.addSublayer(ovalShapeLayer)
        }
    }
    
    func startRefreshing() {
        addOvalShape()
        startAnimationShape()
    }
    
    func endRefreshing() {
        ovalShapeLayer.strokeStart = 1.0
        ovalShapeLayer.removeAllAnimations()
    }
    
    func startAnimationShape() {
        let strokeStartAnimation = CABasicAnimation(keyPath: "strokeStart")
        strokeStartAnimation.fromValue = -0.5
        strokeStartAnimation.toValue = 1.0
        let strokeEndAnimation = CABasicAnimation(keyPath: "strokeEnd")
        strokeEndAnimation.fromValue = 0.0
        strokeEndAnimation.toValue = 1.0
        
        let strokeAnimationGroup = CAAnimationGroup()
        strokeAnimationGroup.duration = 1.5
        strokeAnimationGroup.repeatDuration = 5.0
        strokeAnimationGroup.animations =
          [strokeStartAnimation, strokeEndAnimation]
        ovalShapeLayer.add(strokeAnimationGroup, forKey: nil)
    }
    
    func removeAnimation(scrollView: UIScrollView) {
        endRefreshing()
        refreshHeightConstraint.constant = 0
        UIView.animate(withDuration: 0.1, delay: 0.0) {
            self.scrollView.contentInset.top = 0
            self.superview?.layoutIfNeeded()
        }
    }
}
