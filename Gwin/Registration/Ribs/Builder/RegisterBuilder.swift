//
//  RegisterBuilder.swift
//  Gwin
//
//  Created by Hai Vu Van on 10/12/19.
//  Copyright © 2019 Hai Vu Van. All rights reserved.
//

import Foundation
import UIKit

final class RegisterBuilder {
  let router: RegisterRouter!

  public init(){
    router = RegisterRouter()
  }

  func build() -> RegisterRouter {

    let viewcontroller = RegisterViewController(nibName: "RegisterViewController", bundle: nil)
    let interactor = RegisterInteractor()

    interactor.view = viewcontroller
    viewcontroller.output = interactor

    router.interactor = interactor
    router.viewController = viewcontroller
    return router
  }
}
