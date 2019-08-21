//
//  HomeViewComponent.swift
//  Gwin
//
//  Created by Hai Vu Van on 8/21/19.
//  Copyright © 2019 Hai Vu Van. All rights reserved.
//

import Foundation
public protocol RedEnvelopDependency {
  var user: User? { get }
}

class RedEnvelopComponent: RedEnvelopDependency  {
  static let shared = RedEnvelopComponent()

  var user: User?

  init(user: User? = nil) {
    self.user = user
  }
}
