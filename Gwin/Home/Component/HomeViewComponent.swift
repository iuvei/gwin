//
//  HomeViewComponent.swift
//  Gwin
//
//  Created by Hai Vu Van on 8/21/19.
//  Copyright © 2019 Hai Vu Van. All rights reserved.
//

import Foundation
import UIKit

public enum AppColors{
    static let tabbarColor: UIColor = UIColor(hexString:"e75f48")
    static let titleColor: UIColor = UIColor(hexString: "FBEAAC")

}

public enum AppText{
  static let currency: String = "元"
}

public enum TabIndex: Int {
  case home = 0, boom, bull, lottery, profile
}

public protocol RedEnvelopDependency {
  var user: User? { get }
  var systemtime: Date? { get }
  var userno: String? { get }
  var rollMsg: String? { get }
}

class RedEnvelopComponent: RedEnvelopDependency  {
  static let limitTime: Int  = 6 
  static let shared = RedEnvelopComponent()

  var user: User?
  var systemtime: Date?
  var systemTimeInterval: TimeInterval

  var userno: String?
  var rollMsg: String?
  
  init(user: User? = nil) {
    self.user = user
    self.systemTimeInterval = Date().timeIntervalSinceNow
  }

  func clearData() {
    user = nil
    userno = nil
    rollMsg = nil
  }

  func doTick(){
    
    systemTimeInterval = systemtime?.timeIntervalSinceNow ?? Date().timeIntervalSinceNow
    Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(increaseSystemTime), userInfo: nil, repeats: true)
  }

  @objc func increaseSystemTime() {
    systemTimeInterval = systemTimeInterval + 1
    print("increaseSystemTime \(systemTimeInterval)")
  }
}
