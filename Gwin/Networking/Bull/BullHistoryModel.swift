//
//  BullHistoryModel.swift
//  Gwin
//
//  Created by Hai Vu Van on 8/23/19.
//  Copyright © 2019 Hai Vu Van. All rights reserved.
//

import SwiftyJSON

class BullHistoryModel {

  var roundid: Int64
  var packettag: String

  init(json: JSON) {
    roundid = json["roundid"].int64Value
    packettag = json["packettag"].stringValue
  }
}
