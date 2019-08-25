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

  func addShadow(color: UIColor = .black, opacity: Float = 0.5, offSet: CGSize = .zero , radius: CGFloat = 1, scale: Bool = true) {
    layer.masksToBounds = false
    layer.shadowColor = color.cgColor
    layer.shadowOpacity = opacity
    layer.shadowOffset = offSet
    layer.shadowRadius = radius

    layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
    layer.shouldRasterize = true
    layer.rasterizationScale = scale ? UIScreen.main.scale : 1
  }

  func boundInside(view: UIView) {
    forAutolayout()
    NSLayoutConstraint.activate([
      topAnchor.constraint(equalTo: view.topAnchor),
      leftAnchor.constraint(equalTo: view.leftAnchor),
      bottomAnchor.constraint(equalTo: view.bottomAnchor),
      rightAnchor.constraint(equalTo: view.rightAnchor),

      ])
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

extension UIButton {
   func adjustImageAndTitleOffsetsForButton(spacing: CGFloat = 6.0) {

    if let image = self.imageView?.image {
      let imageSize: CGSize = image.size
      self.titleEdgeInsets = UIEdgeInsets(top: spacing, left: -imageSize.width, bottom: -(imageSize.height), right: 0.0)
      let labelString = NSString(string: self.titleLabel!.text!)
      let titleSize = labelString.size(withAttributes: [NSAttributedString.Key.font: self.titleLabel!.font])
      self.imageEdgeInsets = UIEdgeInsets(top: -(titleSize.height + spacing), left: 0.0, bottom: 0.0, right: -titleSize.width)
    }
  }
}


extension Int {
  var usefulDigits: Int {
    let number = self
    let string = String(number)
    let digits = string.compactMap{ $0.wholeNumberValue }
    return digits.count
  }
}


extension String {
  func toDate(withFormat format: String = "yyyy-MM-dd HH:mm:ss") -> Date {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = format
    guard let date = dateFormatter.date(from: self) else {
      preconditionFailure("Take a look to your format")
    }
    return date
  }
}

extension Date {
  static func - (lhs: Date, rhs: Date) -> TimeInterval {
    return lhs.timeIntervalSinceReferenceDate - rhs.timeIntervalSinceReferenceDate
  }
}
