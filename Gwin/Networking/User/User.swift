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
