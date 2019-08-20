//
//  LoginBuilder.swift
//  Gwin
//
//  Created by Hai Vu Van on 8/20/19.
//  Copyright © 2019 Hai Vu Van. All rights reserved.
//

public final class LoginBuilder {
  let router: LoginRouter

  public init() {
    self.router = LoginRouter()
  }

  public func build(withListener listener: LoginListner? = nil) -> LoginRouter {

    let viewController = LoginViewController(nibName: "LoginViewController", bundle: nil)
    let interactor = LoginInteractor(withListener: listener)

    interactor.router = router
    interactor.view = viewController

    viewController.output = interactor

    router.viewController = viewController
    router.interactor = interactor

    return router
  }
}
