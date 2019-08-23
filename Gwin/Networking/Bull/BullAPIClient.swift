//
//  BullAPIClient.swift
//  Gwin
//
//  Created by Hai Vu Van on 8/23/19.
//  Copyright © 2019 Hai Vu Van. All rights reserved.
//

import Foundation

class BullAPIClient {
  static func round(ticket: String, roomid: Int){}

  static func banksetting(ticket:String){}

  static func banker_get(ticket:String, roomid: Int , roundi: Int64, pagesize: Int){}

  static func setbanker(ticket:String,  roomid: Int, bankqty: Int, lockquota: Int, stake1: String, stake2: String){}

  static func betting(ticket:String,  roomid: Int, roundid: Int64, wagers: String){}

  static func grab(ticket:String, roomid: Int, roundid: Int){}

  static func info(ticket:String, roomid: Int, roundid: Int, onlyself: Int){}

  static func packethistory(ticket:String, roomid: Int, roundid: Int, topnum: Int){}

  static func history(ticket:String, roomid: Int, roundid: Int, pagesize: Int){}

  static func packetstatus(ticket:String, roomid: Int, roundid: Int){}

  static func wagerinfo(ticket:String, roomid: Int, roundid: Int, idno: Int){}
  
  static func betdetail(ticket:String, roomid: Int, roundid: Int, userno: String){}
}
