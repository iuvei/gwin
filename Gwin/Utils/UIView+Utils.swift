//
//  UIView+Utils.swift
//  Gwin
//
//  Created by Hai Vu Van on 8/19/19.
//  Copyright © 2019 Hai Vu Van. All rights reserved.
//

import Foundation
import UIKit

extension UIStackView {

  func removeAllArrangedSubviews() {

    let removedSubviews = arrangedSubviews.reduce([]) { (allSubviews, subview) -> [UIView] in
      self.removeArrangedSubview(subview)
      return allSubviews + [subview]
    }

    // Deactivate all constraints
    NSLayoutConstraint.deactivate(removedSubviews.flatMap({ $0.constraints }))

    // Remove the views from self
    removedSubviews.forEach({ $0.removeFromSuperview() })
  }
}

extension UIView {
  func rounded(radius: CGFloat = 8) {
    layer.cornerRadius = radius
    layer.masksToBounds = true
  }
}

extension UINavigationController {
  /**
   It removes all view controllers from navigation controller then set the new root view controller and it pops.

   - parameter vc: root view controller to set a new
   */
  func initRootViewController(vc: UIViewController, transitionType type: CATransitionType = .fade, duration: CFTimeInterval = 0.3) {
    self.addTransition(transitionType: type, duration: duration)
    self.viewControllers.removeAll()
    self.pushViewController(vc, animated: false)
    self.popToRootViewController(animated: false)
  }

  /**
   It adds the animation of navigation flow.

   - parameter type: kCATransitionType, it means style of animation
   - parameter duration: CFTimeInterval, duration of animation
   */
  private func addTransition(transitionType type: CATransitionType = .fade, duration: CFTimeInterval = 0.3) {
    let transition = CATransition()
    transition.duration = duration
    transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
    transition.type = type
    self.view.layer.add(transition, forKey: nil)
  }
}

extension UIViewController {
  func setNavigationBackgroundColor(color: UIColor = .white) {
    navigationController?.navigationBar.barTintColor = color

  }
}

extension UITextField {
  func setLeftIcon(imageName: String, viewMode: UITextField.ViewMode = .always) {
    let leftIcon = UIImageView(frame: CGRect(x: 5, y: 5, width: 30, height: 30))
    leftIcon.image = UIImage(named: imageName)
    leftIcon.contentMode = .scaleAspectFit
    leftView = leftIcon
    leftViewMode = viewMode
  }
}

