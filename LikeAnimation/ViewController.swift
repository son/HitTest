//
//  ViewController.swift
//  LikeAnimation
//
//  Created by Takeru Sato on 2018/12/31.
//  Copyright © 2018 son. All rights reserved.
//

import UIKit

final class ViewController: UIViewController {
    
    private var backgroundImageView: UIImageView!
    private var iconContainerView: UIView!
    private var stackView: UIStackView!
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupSubview()
    }
    
    private func setupSubview() {
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(viewLongPressed)))
        
        iconContainerView = UIView()
        iconContainerView.backgroundColor = .white
        iconContainerView.layer.shadowColor = UIColor(white: 0.4, alpha: 0.4).cgColor
        iconContainerView.layer.shadowRadius = 8
        iconContainerView.layer.shadowOpacity = 0.5
        iconContainerView.layer.shadowOffset = CGSize(width: 0, height: 4)
        
        let padding: CGFloat = 6
        let iconHeight: CGFloat = 38
        
        let images = [#imageLiteral(resourceName: "red_heart"), #imageLiteral(resourceName: "blue_like"), #imageLiteral(resourceName: "cry"), #imageLiteral(resourceName: "angry"), #imageLiteral(resourceName: "cry_laugh"), #imageLiteral(resourceName: "surprised")]
        let arrangedSubviews = images.map({ (image) -> UIView in
            let imageView = UIImageView(image: image)
            imageView.layer.cornerRadius = iconHeight / 2
            imageView.isUserInteractionEnabled = true
            return imageView
        })
        
        stackView = UIStackView(arrangedSubviews: arrangedSubviews)
        stackView.distribution = .fillEqually
        stackView.layoutMargins = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.spacing = padding
        stackView.axis = .horizontal
        iconContainerView.addSubview(stackView)
        
        let numIcons = CGFloat(arrangedSubviews.count)
        let width = numIcons * iconHeight + (numIcons + 1) * padding
        
        iconContainerView.frame = CGRect(x: 0, y: 0, width: width, height: iconHeight + 2 * padding)
        iconContainerView.layer.cornerRadius = iconContainerView.frame.height / 2
        stackView.frame = iconContainerView.frame
    }
    
    @objc private func viewLongPressed(gesture: UILongPressGestureRecognizer) {
        switch gesture.state {
        case .began:
            viewLongPressBegan(gesture: gesture)
        case .changed:
            viewLongPressChanged(gesture: gesture)
        case .ended:
            viewLongPressEnded()
        default:
            break
        }
    }
    
    private func viewLongPressBegan(gesture: UILongPressGestureRecognizer) {
        view.addSubview(iconContainerView)
        let pressedLocation = gesture.location(in: self.view)
        let centeredX = (view.frame.width - iconContainerView.frame.width) / 2
        iconContainerView.alpha = 0
        self.iconContainerView.transform = CGAffineTransform(translationX: centeredX, y: pressedLocation.y)
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.iconContainerView.alpha = 1
            self.iconContainerView.transform = CGAffineTransform(translationX: centeredX, y: pressedLocation.y - self.iconContainerView.frame.height)
        })
    }
    
    private func viewLongPressChanged(gesture: UILongPressGestureRecognizer) {
        let pressedLocation = gesture.location(in: self.iconContainerView)
        let fixedYLocation = CGPoint(x: pressedLocation.x, y: self.iconContainerView.frame.height / 2)
        let hitTestView = iconContainerView.hitTest(fixedYLocation, with: nil)
        if hitTestView is UIImageView {
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                let stackView = self.iconContainerView.subviews.first
                stackView?.subviews.forEach({ (imageView) in
                    imageView.transform = .identity
                })
                hitTestView?.transform = CGAffineTransform(translationX: 0, y: -50)
            })
        }
    }
    
    private func viewLongPressEnded() {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            let stackView = self.iconContainerView.subviews.first
            stackView?.subviews.forEach({ (imageView) in
                imageView.transform = .identity
            })
            self.iconContainerView.transform = self.iconContainerView.transform.translatedBy(x: 0, y: 50)
            self.iconContainerView.alpha = 0
        }, completion: { (_) in
            self.iconContainerView.removeFromSuperview()
        })
    }
}

