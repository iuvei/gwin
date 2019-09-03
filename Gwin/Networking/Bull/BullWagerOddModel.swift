//
//  BullWagerOddModel.swift
//  Gwin
//
//  Created by Hai Vu Van on 8/23/19.
//  Copyright © 2019 Hai Vu Van. All rights reserved.
//

import SwiftyJSON

class BullWagerOddModel: Copying {

  var wagertypeno: Int
  var objectid: Int
  var odds: Float
  var name: String?
  var money: Float = 0.0
  var selected: Bool = false
  var objectName: String?
  var testId: Int?
  
  init(json: JSON) {
    wagertypeno = json["wagertypeno"].intValue
    objectid = json["objectid"].intValue
    odds = json["odds"].floatValue
  }

  required init(original: BullWagerOddModel) {
    wagertypeno = original.wagertypeno
    objectid = original.objectid
    odds = original.odds
    name = original.name
    money = original.money
    selected = original.selected
    objectName = original.objectName
    testId = original.testId
  }

}
