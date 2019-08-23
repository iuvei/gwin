//
//  BullRoundModel.swift
//  Gwin
//
//  Created by Hai Vu Van on 8/23/19.
//  Copyright © 2019 Hai Vu Van. All rights reserved.
//

import SwiftyJSON

class BunnRoundModel {
  var currtime : String //string, 系统时间
  var transdate: String                    // string, 交易日
  var remainround: Int                   //Int,--剩余期数
  var bankround: Int                //Int,--已抢期数
  var roundid: Int64                 //Bigint,--当前期号
  var opentime: String                   //Datetime, --开始时间
  var endtime: String                  //Datetime, --封盘时间
  var winningtime: String                   //Datetime, --结算时间
  var status: Int                 //Tinyint,--0.作废 1.正常  2.已发包   3.已结
  var banker: String                   //string,--当前庄家
  var lockquota: String                   //string,--当前庄家金额
  var stake1: Int                   //Int,--当前下注区间
  var state2: Int                  //Int,--当前下注区间
  var bankqty: Int                   //Int,--连庄期数
  var nextroundid: Int64                  //Bigint,--下局期号
  var nextopentime: String                   //Datetime,--下局开始时间
  var nextbanker: String                   //string, --下任庄家
  var nextlockquota: String                  //string, --下任庄家金额
  var nextstake1: Int?                  //Int,--下任下注区间
  var nextstake2: Int?                         //Int,--下任下注区间
  
  init(json: JSON) {
    currtime = json["currtime"].stringValue
    transdate = json["transdate"].stringValue                   // string, 交易日
    remainround = json["remainround"].intValue                   //Int,--剩余期数
    bankround = json["bankround"].intValue              //Int,--已抢期数
    roundid = json["roundid"].int64Value                 //Bigint,--当前期号
    opentime = json["opentime"].stringValue                  //Datetime, --开始时间
    endtime = json["endtime"].stringValue                  //Datetime, --封盘时间
    winningtime = json["winningtime"].stringValue                  //Datetime, --结算时间
    status = json["status"].intValue              //Tinyint,--0.作废 1.正常  2.已发包   3.已结
    banker = json["banker"].stringValue                  //string,--当前庄家
    lockquota = json["lockquota"].stringValue                  //string,--当前庄家金额
    stake1 = json["stake1"].intValue                  //Int,--当前下注区间
    state2 = json["stake2"].intValue                  //Int,--当前下注区间
    bankqty = json["bankqty"].intValue                   //Int,--连庄期数
    nextroundid = json["nextroundid"].int64Value               //Bigint,--下局期号
    nextopentime = json["nextopentime"].stringValue                  //Datetime,--下局开始时间
    nextbanker = json["nextbanker"].stringValue                   //string, --下任庄家
    nextlockquota = json["nextlockquota"].stringValue                 //string, --下任庄家金额
    nextstake1 = json["nextstake1"].int                  //Int,--下任下注区间
    nextstake2 = json["nextstake2"].int
  }
}

