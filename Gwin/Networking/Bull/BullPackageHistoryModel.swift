//
//  BullPackageHistoryModel.swift
//  Gwin
//
//  Created by Hai Vu Van on 8/23/19.
//  Copyright © 2019 Hai Vu Van. All rights reserved.
//

import SwiftyJSON

class BullPackageHistoryModel {
  var roundid: Int64                    // int64,
  var userno: String                   // string,
  var username: String                   // string,
  var packetamount: Int                   // Number,
  var packettag: String                  // string, 开奖结果
  var wagertime: String                  // string,

  init(json: JSON) {
    roundid = json["roundid"].int64Value                  // int64,
    userno = json["userno"].stringValue                 // string,
    username = json["username"].stringValue               // string,
    packetamount = json["packetamount"].intValue                   // Number,
    packettag = json["packettag"].stringValue                 // string, 开奖结果
    wagertime = json["wagertime"].stringValue
  }
}

