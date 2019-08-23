//
//  BullPackage.swift
//  Gwin
//
//  Created by Hai Vu Van on 8/23/19.
//  Copyright © 2019 Hai Vu Van. All rights reserved.
//

import SwiftyJSON

class BullPackageModel {
  var userno : String                 // string,
  var username : String                // string,
  var packettype: Int               // int,1炸雷，福利包 3牛牛包
  var packetamount: Float                // int,
  var packetsize: Int              // int,
  var packettag : String                  // string, 玩法名称
  var remainamount: Float                 // number,
  var remainsize : Int              // int,
  var stake: Float               // Number, 投注额
  var winnings: Float                  // Number, 盈亏
  var wagertime : String
  var grabuser: [GrabUserModel]

  init(json: JSON) {
    userno = json["userno"].stringValue                 // string,
    username = json["username"].stringValue                // string,
    packettype = json["packettype"].intValue              // int,1炸雷，福利包 3牛牛包
    packetamount = json["packetamount"].floatValue               // int,
    packetsize = json["packetsize"].intValue              // int,
    packettag = json["packettag"].stringValue                 // string, 玩法名称
    remainamount = json["remainamount"].floatValue                 // number,
    remainsize = json["remainsize"].intValue             // int,
    stake = json["stake"].floatValue             // Number, 投注额
    winnings = json["winnings"].floatValue                 // Number, 盈亏
    wagertime = json["wagertime"].stringValue
    grabuser = []
    
    if let grabusersJson = json["grabuser"].array {
      for userjon in grabusersJson {
        let user = GrabUserModel(json: userjon)
        grabuser.append(user)
      }
    }
  }
}

