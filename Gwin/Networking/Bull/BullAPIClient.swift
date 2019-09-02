//
//  BullAPIClient.swift
//  Gwin
//
//  Created by Hai Vu Van on 8/23/19.
//  Copyright © 2019 Hai Vu Van. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class BullAPIClient {
  static func round(firsttime: Bool = false, ticket: String, roomid: Int, completion:@escaping (BullRoundModel?, String?)->Void){

    Alamofire.request(BullAPIRouter.round(ticket, roomid)).responseJSON { (responseData) in
      var msg: String? = nil
      var round:BullRoundModel?

      if responseData.result.value != nil {
        let jsonResponse = JSON(responseData.result.value!)
        let code = jsonResponse["code"].intValue
        msg = jsonResponse["msg"].string

        if code == 1 {
          let data = jsonResponse["data"]
          round = BullRoundModel(json: data)
          if firsttime{
            round?.setJSOn(json: data)
          }
        }
      }

      completion(round,msg ?? responseData.error?.localizedDescription)
    }
  }

  static func banksetting(ticket:String, completion:@escaping ([BankSettingModel], String?)->Void){
    Alamofire.request(BullAPIRouter.banksetting(ticket)).responseJSON { (responseData) in
      var msg: String? = nil
      var bankSettings: [BankSettingModel] = []
      if responseData.result.value != nil {
        let jsonResponse = JSON(responseData.result.value!)
        let code = jsonResponse["code"].intValue
        msg = jsonResponse["msg"].stringValue

        if code == 1 {
          let data = jsonResponse["data"].arrayValue
          for json in data {
            let setting = BankSettingModel(json: json)
            bankSettings.append(setting)
          }
        }
      }
      completion(bankSettings,msg ?? responseData.error?.localizedDescription)
    }
  }

  static func banker_get(ticket:String, roomid: Int , roundi: Int64, pagesize: Int, completion:@escaping ([BankGetModel], String?)->Void) {

    Alamofire.request(BullAPIRouter.banker_get(ticket, roomid, roundi, pagesize)).responseJSON { (responseData) in
      var msg: String? = nil
      var bankers:[BankGetModel] = []

      if responseData.result.value != nil {
        let jsonResponse = JSON(responseData.result.value!)
        let code = jsonResponse["code"].intValue
        msg = jsonResponse["msg"].stringValue

        if code == 1 {
          let data = jsonResponse["data"].arrayValue

          for item in data {
            let banker = BankGetModel(json: item)
            bankers.append(banker)
          }
        }
      }

      completion(bankers, msg ?? responseData.error?.localizedDescription)

    }
  }

  static func setbanker(ticket:String,  roomid: Int, bankqty: Int, lockquota: Int64, stake1: Int, stake2: Int, completion:@escaping (Bool, String?)->Void){

    Alamofire.request(BullAPIRouter.setbanker(ticket, roomid, bankqty, lockquota, stake1, stake2)).responseJSON { (responseData) in
      var msg: String? = nil
      var success:Bool = false

      if responseData.result.value != nil {
        let jsonResponse = JSON(responseData.result.value!)
        let code = jsonResponse["code"].intValue
        msg = jsonResponse["msg"].string

        success =  code == 1
      }
      completion(success, msg ?? responseData.error?.localizedDescription)
    }
  }

  static func betting(ticket:String,  roomid: Int, roundid: Int64, wagers: String,completion:@escaping (Bool, String?)->Void){

    Alamofire.request(BullAPIRouter.betting(ticket, roomid, roundid, wagers)).responseJSON { (responseData) in
      var msg: String? = nil
      var success:Bool = false

      if responseData.result.value != nil {
        let jsonResponse = JSON(responseData.result.value!)
        let code = jsonResponse["code"].intValue
        msg = jsonResponse["msg"].string
        success = code == 1
      }
      completion(success, msg ?? responseData.error?.localizedDescription)
    }
  }

  static func grab(ticket:String, roomid: Int, roundid: Int64, completion:@escaping (BullPackageModel?, String?)->Void){
    Alamofire.request(BullAPIRouter.grab(ticket, roomid, roundid)).responseJSON{ (responseData) in
      var msg: String? = nil
      var bullInfo: BullPackageModel? = nil

      if responseData.result.value != nil {
        let jsonResponse = JSON(responseData.result.value!)
        let code = jsonResponse["code"].intValue
        msg = jsonResponse["msg"].string

        if code == 1 {
          let data = jsonResponse["data"]
          bullInfo = BullPackageModel(json: data)
        }
      }
      completion(bullInfo, msg ?? responseData.error?.localizedDescription)
    }
  }

  static func info(ticket:String, roomid: Int, roundid: Int64, onlyself: Int, completion:@escaping (BullPackageHistoryModel?,BullPackageModel?, String?)->Void){
    Alamofire.request(BullAPIRouter.info(ticket, roomid, roundid, onlyself)).responseJSON{ (responseData) in
      var msg: String? = nil
      var bullInfo: BullPackageModel? = nil
      var package: BullPackageHistoryModel?

      if responseData.result.value != nil {
        let jsonResponse = JSON(responseData.result.value!)
        let code = jsonResponse["code"].intValue
        msg = jsonResponse["msg"].string

        if code == 1 {
          let data = jsonResponse["data"]
          bullInfo = BullPackageModel(json: data)
          package = BullPackageHistoryModel(json: data)
        }
      }
      completion(package, bullInfo, msg ?? responseData.error?.localizedDescription)
    }
  }

  static func packethistory(ticket:String, roomid: Int, roundid: Int64, topnum: Int, completion:@escaping ([BullPackageHistoryModel], String?)->Void){
    Alamofire.request(BullAPIRouter.packethistory(ticket, roomid, roundid, topnum)).responseJSON { (responseData) in
      var msg: String? = nil
      var histories:[BullPackageHistoryModel] = []

      if responseData.result.value != nil {
        let jsonResponse = JSON(responseData.result.value!)
        let code = jsonResponse["code"].intValue
        msg = jsonResponse["msg"].string
        if code == 1 {
          let data = jsonResponse["data"].arrayValue
          for json in data {
            let history = BullPackageHistoryModel(json: json)
            histories.append(history)
          }
        }
      }
      completion(histories, msg ?? responseData.error?.localizedDescription)
    }
  }

  static func history(ticket:String, roomid: Int, roundid: Int64, pagesize: Int, completion:@escaping ([BullHistoryModel], String?)->Void){

    Alamofire.request(BullAPIRouter.history(ticket, roomid, roundid, pagesize)).responseJSON { (responseData) in
      var msg: String? = nil
      var model:[BullHistoryModel] = []

      if responseData.result.value != nil {
        let jsonResponse = JSON(responseData.result.value!)
        let code = jsonResponse["code"].intValue
        msg = jsonResponse["msg"].string

        if code == 1 {
          let data = jsonResponse["data"].arrayValue
          for history in data {
            model.append(BullHistoryModel(json: history))
          }
        }
      }

      completion(model,msg ?? responseData.error?.localizedDescription)
    }
  }

  static func packetstatus(ticket:String, roomid: Int, roundid: Int64, completion: @escaping(Int?,String?)->Void){

    Alamofire.request(BullAPIRouter.packetstatus(ticket, roomid, roundid)).responseJSON{ (responseData) in
      var msg: String? = nil
      var status: Int? = nil
      if responseData.result.value != nil {
        let jsonResponse = JSON(responseData.result.value!)
        let code = jsonResponse["code"].intValue
        msg = jsonResponse["msg"].string

        if code == 1 {
          let data = jsonResponse["data"]
          status = data["status"].int
        }
      }
      completion(status, msg ?? responseData.error?.localizedDescription)
    }

  }

  static func wagerinfo(ticket:String, roomid: Int, roundid: Int64, idno: Int, completion: @escaping([BullWagerInfoModel],String?)->Void){
    Alamofire.request(BullAPIRouter.wagerinfo(ticket, roomid, roundid, idno)).responseJSON{ (responseData) in
      var msg: String? = nil
      var wagerInfos: [BullWagerInfoModel] = []
      if responseData.result.value != nil {
        let jsonResponse = JSON(responseData.result.value!)
        let code = jsonResponse["code"].intValue
        msg = jsonResponse["msg"].string

        if idno == 0 {
          print("result 3 data code \(code)")
        }

        if code == 1 {
          let data = jsonResponse["data"].arrayValue
          if idno == 0 {
            print("result 3 data \(data)")
          }
          for json in data {
            let wagerInfo = BullWagerInfoModel(json: json)
            wagerInfos.append(wagerInfo)
          }

        }
      }else {
        print("result error \(roundid) - \(roundid) - \(idno)")
      }
      completion(wagerInfos, msg ?? responseData.error?.localizedDescription)
    }

  }

  static func betdetail(ticket:String, roomid: Int, roundid: Int64, userno: String, completion: @escaping([BullBetDetailModel],String?)->Void){
    Alamofire.request(BullAPIRouter.betdetail(ticket, roomid, roundid, userno)).responseJSON{ (responseData) in
      var msg: String? = nil
      var details: [BullBetDetailModel] = []
      if responseData.result.value != nil {
        let jsonResponse = JSON(responseData.result.value!)
        let code = jsonResponse["code"].intValue
        msg = jsonResponse["msg"].string

        if code == 1 {
          let data = jsonResponse["data"].arrayValue
          for json in data {
            let detail = BullBetDetailModel(json: json)
            details.append(detail)
          }

        }
      }
      completion(details, msg ?? responseData.error?.localizedDescription)
    }
  }

  static func getbullRollMessage(ticket: String, completion: @escaping(String?)->Void){

    Alamofire.request(NoticeAPIRouter.rollMsg(ticket, 2)).responseJSON{ (responseData) in
      var msg: String? = nil
      var rollMsg: String? = nil
      if responseData.result.value != nil {
        let jsonResponse = JSON(responseData.result.value!)
        let code = jsonResponse["code"].intValue
        msg = jsonResponse["msg"].string

        if code == 1 {
          rollMsg = jsonResponse["data"].stringValue
        }
      }
      completion(rollMsg)

    }
  }

  static func wagerodds(ticket: String, roomtype: Int, completion: @escaping([BullWagerOddModel], String?)->Void) {
    Alamofire.request(BullAPIRouter.wagerodds(ticket,roomtype)).responseJSON { (responseData) in
      var msg: String? = nil
      var wagerOdds: [BullWagerOddModel] = []
      if responseData.result.value != nil {
        let jsonResponse = JSON(responseData.result.value!)
        let code = jsonResponse["code"].intValue
        msg = jsonResponse["msg"].string

        if code == 1 {
          let data = jsonResponse["data"].arrayValue
          for json in data {
            let odd = BullWagerOddModel(json: json)
            wagerOdds.append(odd)
          }
        }
      }
      completion(wagerOdds, msg ?? responseData.error?.localizedDescription)
    }
    
  }
}



