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
  var status: String?
  var expand: Bool = false
  var king: Bool = false
  
  init(json: JSON) {
    userno = json["userno"].stringValue                  // string,
    username = json["username"].stringValue                  // string,
    packetamount = json["packetamount"].floatValue                  // Number,
    packettag = json["packettag"].stringValue             // string, 玩法名称
    winnings = json["winnings"].floatValue                  // Number, 盈亏
    wagertime = json["wagertime"].stringValue
    status = json["status"].string
  }

  func isExpire()-> Bool {
    let wagerInteval = wagertime.toDate().timeIntervalSinceNow
    let current  = RedEnvelopComponent.shared.systemtime?.timeIntervalSinceNow ?? 0
    print("current \(current) --- \(wagerInteval)")
    return  current - wagerInteval > 5 * 60 //5 mins
  }
}

