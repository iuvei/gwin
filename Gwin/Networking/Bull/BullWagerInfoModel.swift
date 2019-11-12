//
//  BullWagerInfoModel.swift
//  Gwin
//
//  Created by Hai Vu Van on 8/23/19.
//  Copyright © 2019 Hai Vu Van. All rights reserved.
//

import SwiftyJSON

class BullWagerInfoModel: Equatable {
  static func == (lhs: BullWagerInfoModel, rhs: BullWagerInfoModel) -> Bool {
    return lhs.idno == rhs.idno && lhs.userno == rhs.userno && lhs.stake == rhs.stake && lhs.winning == rhs.winning && lhs.packetamount == rhs.packetamount && lhs.packettag == rhs.packettag
  }

  var idno: Int            // Int,
  var userno: String                 // string,
  var username: String                  // string,
  var stake: Float                 // number, 注金
  var winning: Float                  // number, 盈亏
  var packetamount: Float                  // number,
  var packettag: String                // string,
  var wagertypename: String

  init(json: JSON) {
     idno = json["idno"].intValue           // Int,
     userno = json["userno"].stringValue                // string,
     username = json["username"].stringValue                  // string,
     stake = json["stake"].floatValue                // number, 注金
     winning = json["winnings"].floatValue                  // number, 盈亏
     packetamount = json["packetamount"].floatValue                  // number,
     packettag = json["packettag"].stringValue
    wagertypename = json["wagertypename"].stringValue
    print("BullWagerInfoModel \(json.stringValue)")
  }
}

