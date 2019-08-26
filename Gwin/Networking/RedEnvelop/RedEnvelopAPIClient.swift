//
//  RedEnvelopAPIClient.swift
//  Gwin
//
//  Created by Hai Vu Van on 8/22/19.
//  Copyright © 2019 Hai Vu Van. All rights reserved.
//

import Alamofire
import SwiftyJSON

class RedEnvelopAPIClient {
  static func getRoomList(ticket: String, roomtype: Int, completion:@escaping ([RoomModel]?, String?)->Void) {
    Alamofire.request(RedEnvelopAPIRouter.roomList(ticket, roomtype)).responseJSON { (responseData) in
      var rooms:[RoomModel] = []
      if responseData.result.value != nil {
        let jsonResponse = JSON(responseData.result.value!)
        let code = jsonResponse["code"].intValue
        let msg = jsonResponse["msg"].string

        if code == 1 {
          let data = jsonResponse["data"].arrayValue

          for roomJson in data {
            let room = RoomModel(json: roomJson)
            rooms.append(room)
          }
          completion(rooms, msg)
          return
        }
      }

      completion(rooms, responseData.error?.localizedDescription)
    }
  }

  static func roomLogin(ticket: String, roomId: Int, roomPwd: String, completion:@escaping (Bool, String?)->Void) {
    Alamofire.request(RedEnvelopAPIRouter.loginin(ticket, roomId, roomPwd)).responseJSON { (responseData) in
      var isLogin: Bool = false
      var msg: String? = nil

      if responseData.result.value != nil {
        let jsonResponse = JSON(responseData.result.value!)
        let code = jsonResponse["code"].intValue
        msg = jsonResponse["msg"].string

        isLogin =  code == 1

      }

      completion(isLogin, msg ?? responseData.error?.localizedDescription)
    }
  }

  static func roomLogout(ticket: String, roomid: Int, completion:@escaping (Bool, String?)->Void) {
    Alamofire.request(RedEnvelopAPIRouter.loginout(ticket, roomid)).responseJSON { (responseData) in
      var success: Bool = false
      var msg: String? = nil

      if responseData.result.value != nil {
        let jsonResponse = JSON(responseData.result.value!)
        let code = jsonResponse["code"].intValue
        success = code == 1
        msg = jsonResponse["msg"].string
      }

      completion(success, msg ?? responseData.error?.localizedDescription)
    }
  }

  static func sendPackage(ticket: String, roomid: Int, packageamount: Int, packagesize: Int, packagetag: String, completion:@escaping (Bool, String?)->Void) {
    Alamofire.request(RedEnvelopAPIRouter.sendPackage(ticket, roomid, packageamount, packagesize, packagetag)).responseJSON { (responseData) in
      var success: Bool = false
      var msg: String? = nil

      if responseData.result.value != nil {
        let jsonResponse = JSON(responseData.result.value!)
        let code = jsonResponse["code"].intValue
        success = code == 1
        msg = jsonResponse["msg"].string
      }

      completion(success, msg ?? responseData.error?.localizedDescription)
    }
  }

  static func grabPackage(ticket: String, roomid: Int, packageid: Int64, completion:@escaping (PackageInfoModel?, String?)->Void) {
    Alamofire.request(RedEnvelopAPIRouter.grabPackage(ticket, roomid, packageid)).responseJSON { (responseData) in
      if responseData.result.value != nil {
        let jsonResponse = JSON(responseData.result.value!)
        let code = jsonResponse["code"].intValue
        let msg = jsonResponse["msg"].string
        var  package:PackageInfoModel? = nil

        if code == 1 {
          let data = jsonResponse["data"]
          package = PackageInfoModel(json: data)
        }

        completion(package, msg ?? responseData.error?.localizedDescription)
      } else {
        completion(nil,responseData.error?.localizedDescription)
      }
    }
  }

  static func infoPackage(ticket: String, roomid: Int, packageid: Int64, completion:@escaping (PackageInfoModel?, String?)->Void) {
    Alamofire.request(RedEnvelopAPIRouter.infoPackage(ticket, roomid, packageid)).responseJSON { (responseData) in
      if responseData.result.value != nil {
        let jsonResponse = JSON(responseData.result.value!)
        let code = jsonResponse["code"].intValue
        let msg = jsonResponse["msg"].string
        var  package:PackageInfoModel? = nil

        if code == 1 {
          let data = jsonResponse["data"]
          package = PackageInfoModel(json: data)
        }

        completion(package, msg ?? responseData.error?.localizedDescription)
      } else {
        completion(nil,responseData.error?.localizedDescription)
      }
    }
  }

  static func statusPackage(ticket: String, roomid: Int, packageid: Int64, completion:@escaping (PackageStatus?, String?)->Void) {
    Alamofire.request(RedEnvelopAPIRouter.statusPackage(ticket, roomid, packageid)).responseJSON { (responseData) in
      if responseData.result.value != nil {
        let jsonResponse = JSON(responseData.result.value!)
        let code = jsonResponse["code"].intValue
        let msg = jsonResponse["msg"].string
//        var  package:PackageInfoModel? = nil
        var packageStatus:PackageStatus? = nil
        if code == 1 {
          let data = jsonResponse["data"]
          let status = data["status"].intValue
          packageStatus = PackageStatus(rawValue: status)
        }

        completion(packageStatus, msg ?? responseData.error?.localizedDescription)
      } else {
        completion(nil,responseData.error?.localizedDescription)
      }
    }
  }

  static func historyPackage(ticket: String, roomid: Int, packageid: Int64, topnum: Int, completion:@escaping ([PackageHistoryModel], String?)->Void) {
    Alamofire.request(RedEnvelopAPIRouter.historyPackage(ticket, roomid, packageid, topnum)).responseJSON { (responseData) in
      if responseData.result.value != nil {
        var histories: [PackageHistoryModel] = []
        let jsonResponse = JSON(responseData.result.value!)
        let code = jsonResponse["code"].intValue
        let msg = jsonResponse["msg"].string

        if code == 1 {
          let data = jsonResponse["data"].arrayValue
          for historyJson in data {
            let history = PackageHistoryModel(json: historyJson)
            histories.append(history)
          }
        }

        completion(histories, msg ?? responseData.error?.localizedDescription)
      } else {
        completion([],responseData.error?.localizedDescription)
      }
    }
  }

//  static func historyPackage(ticket: String, roomid: Int, packageid: Int, completion:@escaping (Bool, Int, String?)->Void) {
//    Alamofire.request(RedEnvelopAPIRouter.statusPackage(ticket, roomid, packageid)).responseJSON { (responseData) in
//      if responseData.result.value != nil {
//        let jsonResponse = JSON(responseData.result.value!)
//        let code = jsonResponse["code"].intValue
//        let msg = jsonResponse["msg"].string
//        let data = jsonResponse["data"]
//        let status = data["status"].intValue
//        completion(code == 1, status, msg ?? responseData.error?.localizedDescription)
//      } else {
//        completion(false, 0, responseData.error?.localizedDescription)
//      }
//    }
//  }

  static func lottery(ticket: String, gameno: String, completion:@escaping (String?, String?)->Void) {
    Alamofire.request(RedEnvelopAPIRouter.lottery(ticket, gameno)).responseJSON { (responseData) in
      var msg: String? = nil
      var url: String? = nil

      if responseData.result.value != nil {
        let jsonResponse = JSON(responseData.result.value!)
        let code = jsonResponse["code"].intValue
        msg = jsonResponse["msg"].string

        if code == 1 {
          let data = jsonResponse["data"]
          url = data["url"].stringValue
        }
      }

      completion(url, msg ?? responseData.error?.localizedDescription)
    }
  }
}

