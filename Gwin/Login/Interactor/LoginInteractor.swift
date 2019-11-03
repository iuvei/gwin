//
//  LoginInteractor.swift
//  Gwin
//
//  Created by Hai Vu Van on 8/20/19.
//  Copyright © 2019 Hai Vu Van. All rights reserved.
//

import Foundation
import UIKit

public protocol LoginListner: AnyObject {
  func completeCategoryListingFlow()
}

class LoginInteractor: LoginViewOutput {

  weak var router: LoginRouterInput!
  var view: LoginViewInput!
  weak var listener: LoginListner?

  init(withListener listener: LoginListner? = nil) {
    self.listener = listener
  }

  func viewDidLoad() {
    print("Login : viewDidLoad")
  }

  func viewDidAppear() {
    print("Login : viewDidAppear")
  }

  func viewDidDisAppear() {
    print("Login : viewDidDisAppear")
  }

  func loginButtonPressed(accountNo: String, password: String) {
    print("Login : accountNo : \(accountNo), password :\(password)")


    UserDefaultManager.sharedInstance().saveLoginInfo(accountNo: accountNo, password: password)

    view.startLoadingView()
    UserAPIClient.login(accountNo: accountNo, password: password) {[weak self] (user, message) in
      guard let `this` = self else { return }
      this.view.endLoadingView()
      
      if let `user` = user {
        RedEnvelopComponent.shared.userno = accountNo
        RedEnvelopComponent.shared.user = user
        if let appDelegate: AppDelegate = UIApplication.shared.delegate as? AppDelegate {
          appDelegate.setHomeAsRootViewControlelr()
        }
      } else {
        if let error = message {
          this.view.loginFailedWithMessage(message: error)
        }
      }
    }
  }

  func rememberButtonPressed(is remember: Bool) {
    UserDefaultManager.sharedInstance().rememberLoginInfo(remember)
    view.updateRemeberButtonState(remember: remember)
  }

  func backButtonPressed() {

  }

  func actionButtonTapped() {

  }
}
