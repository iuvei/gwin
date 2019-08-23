//
//  BullWagerOddModel.swift
//  Gwin
//
//  Created by Hai Vu Van on 8/23/19.
//  Copyright © 2019 Hai Vu Van. All rights reserved.
//

import SwiftyJSON

class BullWagerOddModel {
  var wagertypeno: Int
  var objectid: Int
  var odds: Float

  init(json: JSON) {
    wagertypeno = json["wagertypeno"].intValue
    objectid = json["objectid"].intValue
    odds = json["odds"].floatValue
  }
}
