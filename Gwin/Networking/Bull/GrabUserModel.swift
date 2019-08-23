//
//  GrabUserModel.swift
//  Gwin
//
//  Created by Hai Vu Van on 8/23/19.
//  Copyright © 2019 Hai Vu Van. All rights reserved.
//

import SwiftyJSON

class GrabUserModel {
  var userno: String                  // string,
  var username: String                  // string,
  var packetamount: Float                  // Number,
  var packettag: String              // string, 玩法名称
  var winnings: Float                  // Number, 盈亏
  var wagertime: String

  init(json: JSON) {
     userno = json["userno"].stringValue                  // string,
     username = json["username"].stringValue                  // string,
     packetamount = json["packetamount"].floatValue                  // Number,
     packettag = json["packettag"].stringValue             // string, 玩法名称
     winnings = json["winnings"].floatValue                  // Number, 盈亏
     wagertime = json["wagertime"].stringValue
  }
}
