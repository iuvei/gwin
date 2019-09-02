//
//  BullBetDetailModel.swift
//  Gwin
//
//  Created by Hai Vu Van on 8/23/19.
//  Copyright © 2019 Hai Vu Van. All rights reserved.
//

import SwiftyJSON

class BullBetDetailModel {
  var idno: Int            // Int,
  var wagertypename: String                 // string,
  var wagerobject: String                  // string,
  var stake: Float                 // number, 注金
  var winnings: Float                  // number, 盈亏
  init(json: JSON) {
    idno = json["idno"].intValue          // Int,
    wagertypename = json["wagertypename"].stringValue                // string,
    wagerobject = json["wagerobject"].stringValue                 // string,
    stake = json["stake"].floatValue              // number, 注金
    winnings = json["winnings"].floatValue                  // number, 盈亏
  }
}

