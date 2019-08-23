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
  static func getRoomList(ticket: String, roomtype: Int, completion:@escaping (RoomModel?, String?)->Void) {
    Alamofire.request(RedEnvelopAPIRouter.roomList(ticket, roomtype)).responseJSON { (responseData) in
      if responseData.result.value != nil {
        let jsonResponse = JSON(responseData.result.value!)
        let code = jsonResponse["code"].intValue
        let msg = jsonResponse["msg"].string
        if code == 1 {
          let data = jsonResponse["data"]
          let room = RoomModel(json: data)
          completion(room, msg)
          return
        }
      }
      completion(nil, responseData.error?.localizedDescription)
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
        if code == 1 {
          let data = jsonResponse["data"]
          let _roomId = data["roomid"].intValue
          let _roomPwd = data["roompwd"].stringValue
          if roomId == _roomId && roomPwd == _roomPwd{
            isLogin = true
          }
        }
      }
      completion(isLogin, msg ?? responseData.error?.localizedDescription)
    }
  }

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
