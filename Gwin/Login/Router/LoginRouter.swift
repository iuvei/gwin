//
//  LoginRouter.swift
//  Gwin
//
//  Created by Hai Vu Van on 8/20/19.
//  Copyright © 2019 Hai Vu Van. All rights reserved.
//

import Foundation
import UIKit

protocol LoginRouterInput: AnyObject {
  func openActions(title: String, index: Int)
}
//
final public class LoginRouter: Router, LoginRouterInput {


  var current: Router?

  public weak var viewController: (UIViewController & LoginViewControllerInput)!
  var interactor: LoginInteractor!
  // MARK: - CategoryListingHomeRouterInput

  func openActions(title: String, index: Int) {

  }

}
