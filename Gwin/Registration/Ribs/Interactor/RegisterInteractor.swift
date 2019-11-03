//
//  RegisterInteractor.swift
//  Gwin
//
//  Created by Hai Vu Van on 10/12/19.
//  Copyright © 2019 Hai Vu Van. All rights reserved.
//

import Foundation
import UIKit

final class RegisterInteractor {
  var view: RegisterViewInput!

  public init(){

  }
}

extension RegisterInteractor: RegisterViewOutput {
  func validateCellphoneNo(phoneNo: String) {
    
    UserAPIClient.checkCellphoneNo(cellphone: phoneNo) { [weak self] (checkCode, errorMessage) in
      if let code = checkCode {
        print("code \(code)")
        self?.view?.didValidatePhoneNo(code: code)
      }
    }
  }

  func register(accountNo: String, password: String, code: String, cellphone: String, prefix: String) {
    view.startCallAPI()
    UserAPIClient.register(accountNo: "\(prefix)\(accountNo)", password: password, code: code, cellphone: cellphone) { [weak self] (user, message) in
      guard let this = self else { return }
      this.view.endCallAPI()

      if let `user` = user, let appDelegate: AppDelegate = UIApplication.shared.delegate as? AppDelegate {
        UserDefaultManager.sharedInstance().removeLoginInfo()
        RedEnvelopComponent.shared.user = user
        RedEnvelopComponent.shared.userno = "\(prefix)\(accountNo)"
        appDelegate.setHomeAsRootViewControlelr()
      } else {
        if let msg = message {
          this.view.apiError(message: msg)
        }
      }
    }
  }
}
