//
//  BankSettingModel.swift
//  Gwin
//
//  Created by Hai Vu Van on 8/23/19.
//  Copyright © 2019 Hai Vu Van. All rights reserved.
//

import SwiftyJSON

class BankSettingModel {
  var id: Int
  var lockquota: Int64
  var stake1: Int
  var stake2: Int
  var opentime: String?                   //Datetime, --开始时间
  var userno: String?

  init(json: JSON) {
    id = json["id"].intValue
    lockquota = json["lockquota"].int64Value
    stake1 = json["stake1"].intValue
    stake2 = json["stake2"].intValue
    opentime = json["opentime"].string
    userno = json["userno"].string
  }
}
