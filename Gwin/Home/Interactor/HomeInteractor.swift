//
//  HomeInteractor.swift
//  Gwin
//
//  Created by Hai Vu Van on 8/21/19.
//  Copyright © 2019 Hai Vu Van. All rights reserved.
//

import Foundation

final class HomeInteractor: HomeViewOutput {

//  weak var router: HomeRouterInput!
  var view: HomeViewInput!

  init() {
  }
  
  func fetchPopularizeImage() {

    guard let user = RedEnvelopComponent.shared.user else { return }

    NoticeAPIClient.getPopularizeImage(ticket: user.ticket) { [weak self] (images, msg) in
      guard let this = self else { return  }
      this.view.updatePopularizeImage(images: images)
    }
  }

  func viewDidLoad() {
    fetchPopularizeImage()
  }

}
