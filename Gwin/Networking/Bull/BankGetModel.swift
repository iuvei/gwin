//
//  BankGetModel.swift
//  Gwin
//
//  Created by Hai Vu Van on 8/29/19.
//  Copyright © 2019 Hai Vu Van. All rights reserved.
//

import Foundation
import SwiftyJSON

class BankGetModel {
  var roundid: Int64                 //Bigint,--期号
  var opentime: Date                  //Datetime, --开始时间
  var userno: String               //Datetime, --会员帐号
  var lockquota: String                   //string,--庄家金额
  var stake1: Int             //Int,--下注区间
  var state2: Int                   //Int,--下注区间

  init(json: JSON) {
     roundid = json["roundid"].int64Value               //Bigint,--期号
     opentime = json["opentime"].stringValue.toDate(withFormat: "HH:mm:ss") //Datetime, --开始时间
     userno = json["userno"].stringValue               //Datetime, --会员帐号
     lockquota = json["lockquota"].stringValue                  //string,--庄家金额
     stake1 = json["stake1"].intValue              //Int,--下注区间
    if let stake2 = json["stake2"].int {
      state2 = stake2               //Int,--下注区间
    }else {
      state2 = json["state2"].intValue                 //Int,--下注区间
    }
  }
}
