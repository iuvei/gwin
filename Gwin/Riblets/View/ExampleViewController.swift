//
//  ExampleViewController.swift
//  Gwin
//
//  Created by Hai Vu Van on 8/20/19.
//  Copyright © 2019 Hai Vu Van. All rights reserved.
//

import Foundation
import UIKit

protocol ExampleViewInput: AnyObject {
  func setNavigationTitle(_ title: String)
  func didRefresh()
}

protocol ExampleViewOutput: AnyObject {
  func backButtonPressed()
  func actionButtonTapped()
}

public protocol ExampleViewControllerInput: AnyObject {
  // Define interface that enable router to interact with view controller.
  func displayGrablet(controller: UIViewController)
  func removeGrablet(controller: UIViewController)
  func displayServices(controller: UIViewController)
  func openActions(title: String, index:Int) -> UIViewController?
}

final class ExampleViewController: UIViewController {
  weak var output: ExampleViewOutput?
  
  // MARK: - Life cycle
  required init() {
    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()
  }
}

// MARK: - ExampleViewInput
extension ExampleViewController: ExampleViewInput {
  func setNavigationTitle(_ title: String) {

  }

  func didRefresh() {

  }
}

extension ExampleViewController: ExampleViewControllerInput {
  func displayGrablet(controller: UIViewController) {

  }

  func removeGrablet(controller: UIViewController) {

  }

  func displayServices(controller: UIViewController) {

  }

  func openActions(title: String, index: Int) -> UIViewController? {
    return nil
  }


}
