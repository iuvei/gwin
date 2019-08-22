//
//  RoomModel.swift
//  Gwin
//
//  Created by Hai Vu Van on 8/22/19.
//  Copyright © 2019 Hai Vu Van. All rights reserved.
//

import Foundation
import SwiftyJSON

public struct RoomModel {

  var roomId: Int
  var roomName: String
  var roomDesc: String
  var roomPwd: String
  var stake1: Int
  var stake2: Int
  var openTime1: String
  var openTime2: String
  var packageSize: Int
  var onlyWelFare: Bool
  var niuallowchangebanker: Bool
  init(json: JSON) {
    roomId = json["roomid"].intValue
    roomName = json["roomname"].stringValue
    roomDesc = json["roomdesc"].stringValue
    roomPwd = json["roompwd"].stringValue
    stake1 = json["stake1"].intValue
    stake2 = json["stake2"].intValue
    openTime1 = json["opentim12"].stringValue
    openTime2 = json["opentime2"].stringValue
    packageSize = json["packetsize"].intValue
    onlyWelFare = json["onlywelfare"].boolValue
    niuallowchangebanker = json["niuallowchangebanker"].boolValue
  }
}
