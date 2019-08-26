//
//  ImageManager.swift
//  Gwin
//
//  Created by Hai Vu Van on 8/24/19.
//  Copyright © 2019 Hai Vu Van. All rights reserved.
//

import Foundation

protocol ImageManagerDelegate: AnyObject {
  func didDownloadImage()
}

class ImageManager  {
  static let shared = ImageManager()

  var images: [String: String]

  init() {
    images = [:]
  }

  func saveImage(userno: String, image: String){
    images[userno] = image
  }

  func getImage(userno: String) -> String? {
    return images[userno]
  }

  func downloadImage(usernos:[String], completion: @escaping () -> Void) {
    guard let user = RedEnvelopComponent.shared.user else { return }

    UserAPIClient.getUserImages(ticket: user.ticket, usernos: usernos) {[weak self] (data, message) in
      guard let this = self else { return }
      guard let _data = data else { return }

      for json in _data {
        let userno = json["userno"].stringValue
        let image = json["img"].stringValue
        this.saveImage(userno: userno, image: image)
      }
      
      completion()
    }
  }
}
