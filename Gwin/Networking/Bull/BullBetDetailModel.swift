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
    idno = json[""].intValue          // Int,
    wagertypename = json[""].stringValue                // string,
    wagerobject = json[""].stringValue                 // string,
    stake = json[""].floatValue              // number, 注金
    winnings = json[""].floatValue                  // number, 盈亏
  }
}

