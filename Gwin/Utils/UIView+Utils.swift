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

  func addBorder(color: UIColor = .white, width: CGFloat = 0) {
    layer.borderColor = color.cgColor
    layer.borderWidth = width
  }
  
  @discardableResult
  public func forAutolayout() -> Self {
    translatesAutoresizingMaskIntoConstraints = false
    return self
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

  func setTitle(title: String) {
    self.navigationController?.setTitle(title: title)
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

extension UIColor {
  convenience init(hexString: String) {
    let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
    var int = UInt32()
    Scanner(string: hex).scanHexInt32(&int)
    let a, r, g, b: UInt32
    switch hex.count {
    case 3: // RGB (12-bit)
      (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
    case 6: // RGB (24-bit)
      (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
    case 8: // ARGB (32-bit)
      (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
    default:
      (a, r, g, b) = (255, 0, 0, 0)
    }
    self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
  }
}
