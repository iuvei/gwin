//
//  UIView+Utils.swift
//  Gwin
//
//  Created by Hai Vu Van on 8/19/19.
//  Copyright © 2019 Hai Vu Van. All rights reserved.
//

import Foundation
import UIKit

typealias GradientPoints = (startPoint: CGPoint, endPoint: CGPoint)

enum GradientOrientation {
  case topRightBottomLeft
  case topLeftBottomRight
  case horizontal
  case vertical

  var startPoint: CGPoint {
    return points.startPoint
  }

  var endPoint: CGPoint {
    return points.endPoint
  }

  var points: GradientPoints {
    switch self {
    case .topRightBottomLeft:
      return (CGPoint.init(x: 0.0, y: 1.0), CGPoint.init(x: 1.0, y: 0.0))
    case .topLeftBottomRight:
      return (CGPoint.init(x: 0.0, y: 0.0), CGPoint.init(x: 1, y: 1))
    case .horizontal:
      return (CGPoint.init(x: 0.0, y: 0.5), CGPoint.init(x: 1.0, y: 0.5))
    case .vertical:
      return (CGPoint.init(x: 0.0, y: 0.0), CGPoint.init(x: 0.0, y: 1.0))
    }
  }
}

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
  func rounded(radius: CGFloat = 8, borderColor: UIColor = .white, borderwidth: CGFloat = 0) {
    layer.cornerRadius = radius
    layer.borderColor = borderColor.cgColor
    layer.borderWidth = borderwidth
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

  func applyGradient(colours: [UIColor]) -> Void {
    self.applyGradient(colours: colours, locations: nil)
  }

  func applyGradient(colours: [UIColor], locations: [NSNumber]?) -> Void {
    let gradient: CAGradientLayer = CAGradientLayer()
    gradient.frame = self.bounds
    gradient.colors = colours.map { $0.cgColor }
    gradient.locations = locations
    self.layer.insertSublayer(gradient, at: 0)
  }

  func applyGradient(withColours colours: [UIColor], gradientOrientation orientation: GradientOrientation = .horizontal) {
    let gradient: CAGradientLayer = CAGradientLayer()
    gradient.frame = self.bounds
    gradient.colors = colours.map { $0.cgColor }
    gradient.startPoint = orientation.startPoint
    gradient.endPoint = orientation.endPoint
    self.layer.insertSublayer(gradient, at: 0)
  }

  @discardableResult
  public func forAutolayout() -> Self {
    translatesAutoresizingMaskIntoConstraints = false
    return self
  }

  func addTopBorderWithColor(color: UIColor, width: CGFloat) {
    let border = CALayer()
    border.backgroundColor = color.cgColor
    border.frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: width)
    self.layer.addSublayer(border)
  }

  func addRightBorderWithColor(color: UIColor, width: CGFloat) {
    let border = CALayer()
    border.backgroundColor = color.cgColor
    border.frame = CGRect(x: self.frame.size.width - width, y: 0, width: width, height: self.frame.size.height)
    self.layer.addSublayer(border)
  }

  func addBottomBorderWithColor(color: UIColor, width: CGFloat) {
    let border = CALayer()
    border.name = "bottomLine"
    border.backgroundColor = color.cgColor
    border.frame = CGRect(x: 0, y: self.frame.size.height - width, width: self.frame.size.width, height: width)
    let sublayers =  self.layer.sublayers?.filter{$0.name == "bottomLine"}

    if let first = sublayers?.first {
      first.removeFromSuperlayer()
    }

    self.layer.addSublayer(border)
  }

  func addLeftBorderWithColor(color: UIColor, width: CGFloat) {
    let border = CALayer()
    border.backgroundColor = color.cgColor
    border.frame = CGRect(x: 0, y: 0, width: width, height: self.frame.size.height)
    self.layer.addSublayer(border)
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

    //    self.navigationController?.setTitle(title: title)
    //    self.title = title
    navigationItem.title = title

  }

}

extension UITextField {
  func setLeftIcon(imageName: String, viewMode: UITextField.ViewMode = .always) {
    let icon = UIImageView(frame: CGRect(x: 5, y: 5, width: 30, height: 30))
    icon.image = UIImage(named: imageName)
    icon.contentMode = .scaleAspectFit
    leftView = icon
    leftViewMode = viewMode
  }

  func showCorrectIcon(){
    setRightIcon(imageName: "register_validate_correct")
  }

  func showErrorIcon(viewMode: UITextField.ViewMode = .always){
    setRightIcon(imageName: "register_validate_error", viewMode: viewMode)
  }

  func removeValidateIcon() {
    setRightIcon(imageName: nil)
  }

  func setRightIcon(imageName: String? = nil, viewMode: UITextField.ViewMode = .always) {
    let icon = UIButton(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
    var image: UIImage? = nil

    if imageName == nil {
      image = nil
    }else {
      image = UIImage(named: imageName!)
    }

    icon.setImage(image, for: .normal)
    icon.imageView?.contentMode = .scaleAspectFit
    icon.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    rightView = icon
    rightViewMode = viewMode
  }

  func addPaddingLeft() {
    let icon = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 30))
    leftView = icon
    leftViewMode = .always
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

  func centerVertically(padding: CGFloat = 0.0, topmargin: CGFloat = 18) {
    guard
      let imageViewSize = self.imageView?.frame.size,
      let titleLabelSize = self.titleLabel?.frame.size else {
        return
    }

    let totalHeight = imageViewSize.height + titleLabelSize.height + padding

    self.imageEdgeInsets = UIEdgeInsets(
      top: -(totalHeight - imageViewSize.height) + topmargin,
      left: 0.0,
      bottom: 0.0,
      right: -titleLabelSize.width
    )

    self.titleEdgeInsets = UIEdgeInsets(
      top: 0.0,
      left: -imageViewSize.width,
      bottom: -(totalHeight - titleLabelSize.height),
      right: 0.0
    )

    self.contentEdgeInsets = UIEdgeInsets(
      top: 0.0,
      left: 0.0,
      bottom: titleLabelSize.height,
      right: 0.0
    )
  }

  func centerImageAndButton(_ gap: CGFloat = 6.0, imageOnTop: Bool = true) {

    guard let imageView = self.currentImage,
      let titleLabel = self.titleLabel?.text else { return }

    let sign: CGFloat = imageOnTop ? 1 : -1
    self.titleEdgeInsets = UIEdgeInsets(top: (imageView.size.height + gap) * sign, left: -imageView.size.width, bottom: 0, right: 0);

    let titleSize = titleLabel.size(withAttributes:[NSAttributedString.Key.font: self.titleLabel!.font!])
    self.imageEdgeInsets = UIEdgeInsets(top: -(titleSize.height + gap) * sign, left: 0, bottom: 0, right: -titleSize.width)
  }
}


extension Int {
  var usefulDigits: Int {
    let number = self
    let string = String(number)
    let digits = string.compactMap{ $0.wholeNumberValue }
    return digits.count
  }

  func numberOfDigits() -> Int {
    if abs(self) < 10 {
      return 1
    } else {
      return 1 + (self/10).numberOfDigits()
    }
  }

  func getDigits() -> [Int] {
    let num = self.numberOfDigits()
    var tempNumber = self
    var digitList = [Int]()

    for i in (0..<num).reversed() {
      let divider = Int(pow(CGFloat(10), CGFloat(i)))
      let digit = tempNumber/divider
      digitList.append(digit)
      tempNumber -= digit*divider
    }
    return digitList
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

  func toString( dateFormat format  : String = "yyyy-MM-dd HH:mm:ss" ) -> String
  {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = format
    return dateFormatter.string(from: self)
  }
}

extension Array where Element: Hashable {
  func difference(from other: [Element]) -> [Element] {
    let thisSet = Set(self)
    let otherSet = Set(other)
    return Array(thisSet.symmetricDifference(otherSet))
  }
}

extension UITableView {

  func scrollToBottom(animated: Bool = false){

    DispatchQueue.main.async {
      let rowcount = self.numberOfRows(inSection: 0)
      if rowcount > 0 {
        let indexPath = IndexPath(row: self.numberOfRows(inSection: 0) - 1, section: 0)
        self.scrollToRow(at: indexPath, at: .bottom, animated: animated)
      }
    }
  }

  func scrollToTop() {

    DispatchQueue.main.async {
      let indexPath = IndexPath(row: 0, section: 0)
      self.scrollToRow(at: indexPath, at: .top, animated: false)
    }
  }
}


extension UIDevice {
  var iPhoneX: Bool {
    return UIScreen.main.nativeBounds.height == 2436
  }

  var iPhone: Bool {
    return UIDevice.current.userInterfaceIdiom == .phone
  }

  var iPad: Bool {
    return UIDevice.current.userInterfaceIdiom == .pad
  }

  enum ScreenType: String {
    case iPhones_4_4S = "iPhone 4 or iPhone 4S"
    case iPhones_5_5s_5c_SE = "iPhone 5, iPhone 5s, iPhone 5c or iPhone SE"
    case iPhones_6_6s_7_8 = "iPhone 6, iPhone 6S, iPhone 7 or iPhone 8"
    case iPhones_6Plus_6sPlus_7Plus_8Plus = "iPhone 6 Plus, iPhone 6S Plus, iPhone 7 Plus or iPhone 8 Plus"
    case iPhones_X_XS = "iPhone X or iPhone XS"
    case iPhone_XR = "iPhone XR"
    case iPhone_XSMax = "iPhone XS Max"
    case unknown
  }

  var screenType: ScreenType {
    switch UIScreen.main.nativeBounds.height {
    case 960:
      return .iPhones_4_4S
    case 1136:
      return .iPhones_5_5s_5c_SE
    case 1334:
      return .iPhones_6_6s_7_8
    case 1792:
      return .iPhone_XR
    case 1920, 2208:
      return .iPhones_6Plus_6sPlus_7Plus_8Plus
    case 2436:
      return .iPhones_X_XS
    case 2688:
      return .iPhone_XSMax
    default:
      return .unknown
    }
  }
}


/**/
protocol Copying {
  init(original: Self)
}

//Concrete class extension
extension Copying {
  func copy() -> Self {
    return Self.init(original: self)
  }
}

//Array extension for elements conforms the Copying protocol
extension Array where Element: Copying {
  func clone() -> Array {
    var copiedArray = Array<Element>()
    for element in self {
      copiedArray.append(element.copy())
    }
    return copiedArray
  }
}


extension Float {
  func countFloatPoint() -> Int {
    let intValue: Int64 = Int64(self * 10000)
    let xyz  = intValue % 100
    if xyz == 0 {
      return 2
    } else {
      if xyz % 10 == 0 {
        return 3
      }
      return 4
    }
  }

  func toFormatedString() -> String {
    var count = self.countFloatPoint();
    if let n = Decimal(string: "\(self)") {
      count = n.significantFractionalDecimalDigits
    }

    if count <= 2 {
      count = 2
    }else if count == 3 {
      count = 3
    } else {
      count = 4
    }

    if count == 2{
      return String(format: "%.2f", self)
    }

    let strNumber = "\(self)"
    if strNumber.contains("."){
      let numbers:[String] = strNumber.components(separatedBy: ".")
      let prefix = numbers[1].prefix(count)
      return String(format: "%@.%@", numbers[0], String(prefix))
    }else {
      return String(format: "%.\(count)f", self)
    }
  }
}


extension Int {

  func toFormatedString() -> String {
    let floatValue = Float(self)
    return floatValue.toFormatedString()
  }
}

extension Decimal {
  var significantFractionalDecimalDigits: Int {
    return max(-exponent, 0)
  }
}

extension CATransition {

  //New viewController will appear from bottom of screen.
  func segueFromBottom() -> CATransition {
    self.duration = 0.375 //set the duration to whatever you'd like.
    self.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
    self.type = CATransitionType.moveIn
    self.subtype = CATransitionSubtype.fromTop
    return self
  }
  //New viewController will appear from top of screen.
  func segueFromTop() -> CATransition {
    self.duration = 0.375 //set the duration to whatever you'd like.
    self.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
    self.type = CATransitionType.moveIn
    self.subtype = CATransitionSubtype.fromBottom
    return self
  }
  //New viewController will appear from left side of screen.
  func segueFromLeft() -> CATransition {
    self.duration = 0.1 //set the duration to whatever you'd like.
    self.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
    self.type = CATransitionType.moveIn
    self.subtype = CATransitionSubtype.fromLeft
    return self
  }
  //New viewController will pop from right side of screen.
  func popFromRight() -> CATransition {
    self.duration = 0.1 //set the duration to whatever you'd like.
    self.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
    self.type = CATransitionType.reveal
    self.subtype = CATransitionSubtype.fromRight
    return self
  }
}
