//
//  LoginMock.swift
//  GwinTests
//
//  Created by Hai Vu Van on 10/12/19.
//  Copyright © 2019 Hai Vu Van. All rights reserved.
//

import Foundation
@testable import Gwin

enum LoginMock {

  class Router: LoginRouterInput {
    func openActions(title: String, index: Int) {

    }
  }

  class View: LoginViewInput {
    var isRemember: Bool = false
    func updateRemeberButtonState(remember: Bool) {
      isRemember = remember
    }


    var isStartLoadingViewCalled: Bool = false
    func startLoadingView() {
      isStartLoadingViewCalled = true
    }

    var isEndLoadingViewCalled: Bool = false
    func endLoadingView() {
      isEndLoadingViewCalled = true
    }

    func loginFailedWithMessage(message: String) {

    }
  }

  class output: LoginViewOutput {

    var isRemember: Bool = false
    func rememberButtonPressed(is remember: Bool) {
      isRemember = remember
    }

    func viewDidLoad() {

    }

    func viewDidAppear() {

    }

    func viewDidDisAppear() {

    }

    func loginButtonPressed(accountNo: String, password: String) {

    }

  }
}
