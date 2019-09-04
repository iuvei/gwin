//
//  PackageHistoryModel.swift
//  Gwin
//
//  Created by Hai Vu Van on 8/23/19.
//  Copyright © 2019 Hai Vu Van. All rights reserved.
//

import SwiftyJSON

class PackageHistoryModel {
  var roomid: Int                     // int,
  var packetid: Int64                    // int64,
  var userno: String                  // string,
  var username: String                   // string,
  var packetamount: Int                   // Int,
  var packettag: String                 // string, 雷数[0-9] ""为福利包
  var wagertime: String                   // string,
  var status: String?
  var viewed: Bool = false

  init(json: JSON) {
     roomid = json["roomid"].intValue                   // int,
     packetid = json["packetid"].int64Value                   // int64,
     userno = json["userno"].stringValue                  // string,
     username = json["username"].stringValue                  // string,
     packetamount = json["packetamount"].intValue                 // Int,
     packettag = json["packettag"].stringValue                 // string, 雷数[0-9] ""为福利包
     wagertime = json["wagertime"].stringValue                   // string,
  }

  func isBoomStatus() -> Bool {
    if let `status` = status, let statusValue = Int(status) {
      let digits = statusValue.getDigits()
      return digits.filter{ return $0 == 1 }.count > 0
    }

    return false
  }

  func isExpire()-> Bool {
    let wagerInteval = wagertime.toDate().timeIntervalSinceNow
    let current  = RedEnvelopComponent.shared.systemtime?.timeIntervalSinceNow ?? 0
    print("current \(current) --- \(wagerInteval)")
    return current -  wagerInteval > 5 * 60 //5 mins
  }

}
