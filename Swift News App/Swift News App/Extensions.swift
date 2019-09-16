//
//  Extensions.swift
//  Swift News App
//
//  Created by Paul on 5/13/19.
//  Copyright © 2019 Paul. All rights reserved.
//

import Foundation
import UIKit

extension String {
    subscript (bounds: CountableClosedRange<Int>) -> String {
        let start = index(startIndex, offsetBy: bounds.lowerBound)
        let end = index(startIndex, offsetBy: bounds.upperBound)
        return String(self[start...end])
    }
}

extension UIViewController {
    func showToast(message : String) {
        let toastLabel = UILabel(frame: .zero)
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        toastLabel.textColor = UIColor.white
        toastLabel.textAlignment = .center;
        toastLabel.font = UIFont(name: "Montserrat-Light", size: 12.0)
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds  =  true
        self.view.addSubview(toastLabel)
        toastLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: toastLabel, attribute: .centerX, relatedBy: .equal, toItem: self.view, attribute: .centerX, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: toastLabel, attribute: .bottom, relatedBy: .equal, toItem: self.view, attribute: .bottom, multiplier: 0.85, constant: 0).isActive = true
        NSLayoutConstraint(item: toastLabel, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1.0, constant: 250).isActive = true
        NSLayoutConstraint(item: toastLabel, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1.0, constant: 40).isActive = true

        UIView.animate(withDuration: 1.3, delay: 1.1, options: .curveEaseIn, animations: {
            toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }
}

extension UIViewController {
    func showLoading() {
        DispatchQueue.main.async {
            let loadingView = UIView()
            let loadingIndicator = UIActivityIndicatorView()
            
            loadingView.backgroundColor = .black
            loadingView.alpha = 0.8
            loadingView.frame = self.view.bounds
            loadingView.tag = 1338
            loadingIndicator.tag = 1339
            loadingIndicator.style = .whiteLarge
            self.view.addSubview(loadingView)
            self.view.addSubview(loadingIndicator)
            
            loadingIndicator.startAnimating()
            loadingIndicator.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint(item: loadingIndicator, attribute: .centerX, relatedBy: .equal, toItem: loadingView, attribute: .centerX, multiplier: 1.0, constant: 0).isActive = true
            NSLayoutConstraint(item: loadingIndicator, attribute: .centerY, relatedBy: .equal, toItem: loadingView, attribute: .centerY, multiplier: 1.0, constant: 0).isActive = true
        }
    }
    
    func removeLoading() {
        DispatchQueue.main.async {
            if let viewWithTag = self.view.viewWithTag(1338) {
                viewWithTag.removeFromSuperview()
            }
            if let viewWithTag2 = self.view.viewWithTag(1339) {
                viewWithTag2.removeFromSuperview()
            }
        }
    }
}

class BouncyButton: UIButton {
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
    override func sendAction(_ action: Selector, to target: Any?, for event: UIEvent?) {
        super.sendAction(action, to: target, for: event)
        self.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
        UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.3, initialSpringVelocity: 0.2, options: .curveLinear, animations: {
            self.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        })
    }
}
