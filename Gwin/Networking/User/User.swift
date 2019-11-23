//
//  User.swift
//  Gwin
//
//  Created by Hai Vu Van on 8/20/19.
//  Copyright © 2019 Hai Vu Van. All rights reserved.
//

import Foundation
import SwiftyJSON

public struct User {
  let ticket: String
  let guid: String

  public init(dictionary: JSON) {
    let data =  dictionary["data"]
    ticket = data["ticket"].string ?? ""
    guid = data["guid"].string ?? ""
  }
}

struct AppVerstion {
  let version: String
  let url: String
  init(json: JSON) {
    let data =  json["data"]
    version = data["ios"].string ?? ""
    url = data["ios_url"].string ?? ""
  }
}
