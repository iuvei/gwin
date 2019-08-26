//
//  HomeViewComponent.swift
//  Gwin
//
//  Created by Hai Vu Van on 8/21/19.
//  Copyright © 2019 Hai Vu Van. All rights reserved.
//

import Foundation

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
  var userno: String?
  var rollMsg: String?
  
  init(user: User? = nil) {
    self.user = user
  }

  func clearData() {
    user = nil
    userno = nil
    rollMsg = nil
  }
}
