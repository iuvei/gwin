//
//  HomeBuilder.swift
//  Gwin
//
//  Created by Hai Vu Van on 8/21/19.
//  Copyright © 2019 Hai Vu Van. All rights reserved.
//

import Foundation
public final class HomeBuilder {
  let router: HomeRouter

  public init() {
    self.router = HomeRouter()
  }

  public func build() -> HomeRouter {

    let interactor = HomeInteractor()
    let viewController = HomeViewController()

//    interactor.router = router
    interactor.view = viewController

    router.viewController = viewController
    router.interactor = interactor

    return router
  }
}
