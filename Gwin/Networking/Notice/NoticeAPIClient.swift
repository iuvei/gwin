//
//  NoticeAPIClient.swift
//  Gwin
//
//  Created by Hai Vu Van on 8/21/19.
//  Copyright © 2019 Hai Vu Van. All rights reserved.
//

import Alamofire
import SwiftyJSON

class NoticeAPIClient {
  static func getPopularizeImage(ticket: String, completion:@escaping ([String], String?)->Void) {
    Alamofire.request(NoticeAPIRouter.popularizeImage(ticket)).responseJSON { (responseData) in
      if responseData.result.value != nil {
        let jsonResponse = JSON(responseData.result.value!)
        let data = jsonResponse["data"].arrayObject as? [String]
        let msg = jsonResponse["msg"].string
        completion(data ?? [], msg)
      } else {
        completion([],responseData.error?.localizedDescription)
      }
    }
  }

  static func getPopupMsg(ticket: String,  completion:@escaping ([String], String?)->Void) {
    Alamofire.request(NoticeAPIRouter.popupMsg(ticket)).responseJSON { (responseData) in
      if responseData.result.value != nil {
        let jsonResponse = JSON(responseData.result.value!)
        let data = jsonResponse["data"].arrayObject as? [String]
        let msg = jsonResponse["msg"].string
        completion(data ?? [], msg)
      } else {
        completion([],responseData.error?.localizedDescription)
      }
    }
  }

  static func getRollMsg(ticket: String, msgType: Int,  completion:@escaping (String?, String?)->Void) {
    Alamofire.request(NoticeAPIRouter.rollMsg(ticket, msgType)).responseJSON { (responseData) in
      if responseData.result.value != nil {
        let jsonResponse = JSON(responseData.result.value!)
        let data = jsonResponse["data"].stringValue
        let msg = jsonResponse["msg"].string
        completion(data, msg)
      } else {
        completion(nil, responseData.error?.localizedDescription)
      }
    }
  }
}
