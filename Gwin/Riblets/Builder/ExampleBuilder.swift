//
//  ExampleBuilder.swift
//  Gwin
//
//  Created by Hai Vu Van on 8/20/19.
//  Copyright © 2019 Hai Vu Van. All rights reserved.
//

import Foundation

public final class ExampleBuilder {
  let router: ExampleRouter

  public init() {
    self.router = ExampleRouter()
  }

  public func build(withListener listener: ExampleListner, categoryName: String) -> ExampleRouter {

    let viewController = ExampleViewController()
    let interactor = ExampleInteractor(withListener: listener)

    interactor.router = router
    interactor.view = viewController

    viewController.output = interactor

    router.viewController = viewController
    router.interactor = interactor

    return router
  }
}
