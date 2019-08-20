//
//  LoginInteractor.swift
//  Gwin
//
//  Created by Hai Vu Van on 8/20/19.
//  Copyright © 2019 Hai Vu Van. All rights reserved.
//

import Foundation

public protocol LoginListner: AnyObject {
  func completeCategoryListingFlow()
}

final class LoginInteractor: Interactor {

  weak var router: LoginRouterInput!
  var view: LoginViewInput!
  weak var listener: LoginListner?

  init(withListener listener: LoginListner?) {
    self.listener = listener
  }
}


extension LoginInteractor: LoginViewOutput {
  func backButtonPressed() {

  }

  func actionButtonTapped() {

  }
}
