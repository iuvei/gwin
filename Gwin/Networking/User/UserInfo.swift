//
//  UserInfo.swift
//  Gwin
//
//  Created by Hai Vu Van on 8/20/19.
//  Copyright © 2019 Hai Vu Van. All rights reserved.
//

import Foundation
import SwiftyJSON

public struct UserInfo {
  let accountno: String
  let accountname: String
  let allowcreditquota: Float
  let usecreditquota: Float
  let refercode: String

  public init(dictionary: JSON) {
    let data =  dictionary["data"]
    accountno = data["accountno"].stringValue
    accountname = data["accountname"].stringValue
    allowcreditquota = data["allowcreditquota"].floatValue
    usecreditquota = data["usecreditquota"].floatValue
    refercode = data["refercode"].stringValue
  }
}
