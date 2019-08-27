//
//  PackageInfoModel.swift
//  Gwin
//
//  Created by Hai Vu Van on 8/23/19.
//  Copyright © 2019 Hai Vu Van. All rights reserved.
//

import SwiftyJSON

class PackageInfoModel {
  var userno: String               // string,
  var username: String                 // string,
  var packettype: Int              // int,1炸雷，福利包 3牛牛包
  var packetamount: Int                 // int,
  var packetsize: Int                 // int,
  var packettag: String               // string, 雷数[0-9] ""为福利包
  var remainamount: Float                 // number,
  var remainsize: Int               // int,
  var wagertime: String                 // string,
  var grabuser: [GrabUserModel]

  init(json: JSON) {
    userno = json["userno"].stringValue            // string,
    username = json["username"].stringValue                 // string,
    packettype = json["packettype"].intValue             // int,1炸雷，福利包 3牛牛包
    packetamount = json["packetamount"].intValue                 // int,
    packetsize = json["packetsize"].intValue                 // int,
    packettag = json["packettag"].stringValue               // string, 雷数[0-9] ""为福利包
    remainamount = json["remainamount"].floatValue                 // number,
    remainsize = json["remainsize"].intValue               // int,
    wagertime = json["wagertime"].stringValue                 // string,
    let grabuserJson = json["grabuser"].arrayValue
    grabuser = []
    for userjson in grabuserJson {
      let user = GrabUserModel(json: userjson)
      grabuser.append(user)
    }
  }

  func getStatus(userno: String) -> Bool {
    let yoursgrabs = grabuser.filter{ return $0.userno == userno && $0.status?.contains("1") ?? false}
    if let _ = yoursgrabs.first {
      return true
    }

    return false
  }

  func isGrabBiggest(userno: String) -> Bool {

    let sorted = grabuser.sorted(by: {$0.packetamount > $1.packetamount})
    if let first = sorted.first {
      return first.userno == userno
    }

    return false
  }
}

