//
//  HomeRouter.swift
//  Gwin
//
//  Created by Hai Vu Van on 8/21/19.
//  Copyright © 2019 Hai Vu Van. All rights reserved.
//

import UIKit

protocol HomeRouterInput: AnyObject {
  func homeRouterXXX()
}

final public class HomeRouter: Router, HomeRouterInput {


  var current: Router?

  public weak var viewController: (UIViewController & HomeViewControllerInput)!
  var interactor: HomeInteractor!

  func homeRouterXXX() {

  }

}
