//
//  ExampleInteractor.swift
//  Gwin
//
//  Created by Hai Vu Van on 8/20/19.
//  Copyright © 2019 Hai Vu Van. All rights reserved.
//

import Foundation

public protocol ExampleListner: AnyObject {
  func completeCategoryListingFlow()
}

final class ExampleInteractor: Interactor {

  weak var router: ExampleRouterInput!
  var view: ExampleViewInput!
  weak var listener: ExampleListner?

  init(withListener listener: ExampleListner) {
    self.listener = listener
  }
}


extension ExampleInteractor: ExampleViewOutput {
  func backButtonPressed() {

  }

  func actionButtonTapped() {

  }
}
