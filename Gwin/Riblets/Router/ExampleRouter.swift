////
////  Router.swift
////  Gwin
////
////  Created by Hai Vu Van on 8/20/19.
////  Copyright © 2019 Hai Vu Van. All rights reserved.
////
//
import UIKit
//
protocol ExampleRouterInput: AnyObject {
  func openActions(title: String, index: Int)
}
//
final public class ExampleRouter: Router, ExampleRouterInput {


  var current: Router?

  public weak var viewController: (UIViewController & ExampleViewControllerInput)!
  var interactor: ExampleInteractor!
  // MARK: - CategoryListingHomeRouterInput

  func openActions(title: String, index: Int) {
    
  }

}
