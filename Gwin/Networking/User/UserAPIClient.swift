//
//  UserAPIClient.swift
//  Gwin
//
//  Created by Hai Vu Van on 8/20/19.
//  Copyright © 2019 Hai Vu Van. All rights reserved.
//

import Alamofire
import SwiftyJSON

enum OnlineStatus: Int {
  case normal = 0
  case logout, loginOtherPlace, kickout
}

enum Optype {
  static let personal_center: String = "personal_center"
  static let recommended_app: String = "recommended_app" // 推荐APP
  static let deposits_withdrawals: String = "deposits_withdrawals" // 存取款 delete
  static let deposits: String = "deposits" // 存款 add
  static let withdrawals: String = "withdrawals" // 取款 add
  static let report_query: String = "report_query" // 报表查询
  static let opening_result: String = "opening_result" // 开奖结果
  static let lottery_network: String = "lottery_network"// 百果园开奖网
  static let common_problem: String = "common_problem"// 常见问题//
  static let customer_service: String = "customer_service"// 客服 add
}
class UserAPIClient {
  static func login(accountNo: String, password: String, completion:@escaping (User?,String?)->Void) {
    Alamofire.request(UserAPIRouter.login(accountNo, password)).responseJSON { (responseData) in
      if((responseData.result.value) != nil) {
        let jsonResponse = JSON(responseData.result.value!)
        let user = User(dictionary: jsonResponse)
        completion(user,nil)
      } else {
        completion(nil,responseData.error?.localizedDescription)
      }
    }
  }

  static func checkCellphoneNo(cellphone: String, completion: @escaping (JSON?, String?) -> Void) {
    Alamofire.request(UserAPIRouter.checkCellphoneNo(cellphone)).responseJSON { (responseData) in
      if((responseData.result.value) != nil) {
        let jsonResponse = JSON(responseData.result.value!)

        completion(jsonResponse,nil)
      } else {
        completion(nil,responseData.error?.localizedDescription)
      }
    }
  }

  static func checkExist(accountNo: String, completion: @escaping (JSON?, String?) -> Void){
    Alamofire.request(UserAPIRouter.accountExist(accountNo)).responseJSON { (responseData) in
      if((responseData.result.value) != nil) {
        let jsonResponse = JSON(responseData.result.value!)

        completion(jsonResponse,nil)
      } else {
        completion(nil,responseData.error?.localizedDescription)
      }
    }
  }

  static func register(accountNo: String, password: String, code: String, cellphone: String, completion: @escaping (User?, String?) -> Void){
    Alamofire.request(UserAPIRouter.register(accountNo, password, code, cellphone)).responseJSON { (responseData) in
      if((responseData.result.value) != nil) {
        let jsonResponse = JSON(responseData.result.value!)
        let user = User(dictionary: jsonResponse)
        completion(user,nil)
      } else {
        completion(nil,responseData.error?.localizedDescription)
      }
    }
  }

  static func userInfo(ticket: String, completion: @escaping (UserInfo?, String?) -> Void) {
    Alamofire.request(UserAPIRouter.userInfo(ticket)).responseJSON { (responseData) in
      if((responseData.result.value) != nil) {
        let jsonResponse = JSON(responseData.result.value!)
        let user = UserInfo(dictionary: jsonResponse)
        completion(user,nil)
      } else {
        completion(nil,responseData.error?.localizedDescription)
      }
    }
  }

  static func setOnline(ticket: String, guid: String, completion: @escaping (OnlineStatus?, String?) -> Void) {
    Alamofire.request(UserAPIRouter.setOnline(ticket, guid)).responseJSON { (responseData) in
      if((responseData.result.value) != nil) {
        let jsonResponse = JSON(responseData.result.value!)
        let data = jsonResponse["data"].intValue
        let onlineStatus = OnlineStatus(rawValue: data)
        completion(onlineStatus, nil)
      } else {
        completion(nil,responseData.error?.localizedDescription)
      }
    }
  }

  static func inMoney(ticket: String, money: String, completion: @escaping (Bool, String?) -> Void) {
    Alamofire.request(UserAPIRouter.inMoney(ticket, money)).responseJSON { (responseData) in
      if((responseData.result.value) != nil) {
        let jsonResponse = JSON(responseData.result.value!)
        let code = jsonResponse["code"].boolValue
        let msg = jsonResponse["msg"].stringValue
        completion(code, msg)
      } else {
        completion(false,responseData.error?.localizedDescription)
      }
    }
  }

  static func logout(ticket: String, guid: String, completion: @escaping (Bool, String?) -> Void) {
    Alamofire.request(UserAPIRouter.logout(ticket, guid)).responseJSON { (responseData) in
      if((responseData.result.value) != nil) {
        let jsonResponse = JSON(responseData.result.value!)
        let code = jsonResponse["code"].boolValue
        let msg = jsonResponse["msg"].stringValue
        completion(code, msg)
      } else {
        completion(false,responseData.error?.localizedDescription)
      }
    }
  }

  static func otherH5(ticket: String, optype: String, completion: @escaping (String?, String?) -> Void) {
    Alamofire.request(UserAPIRouter.otherH5(ticket, optype)).responseJSON { (responseData) in
      if((responseData.result.value) != nil) {
        let jsonResponse = JSON(responseData.result.value!)
        //let code = jsonResponse["code"].boolValue
        let msg = jsonResponse["msg"].stringValue
        let data = jsonResponse["data"]
        let url = data["url"].string
        completion(url, msg)
      } else {
        completion(nil,responseData.error?.localizedDescription)
      }
    }
  }

  static func accountPrefix( prefix: String, completion: @escaping (Bool, String?) -> Void) {
    Alamofire.request(UserAPIRouter.accountPrefix(prefix)).responseJSON { (responseData) in
      if((responseData.result.value) != nil) {
        let jsonResponse = JSON(responseData.result.value!)
        let code = jsonResponse["code"].boolValue
        let msg = jsonResponse["msg"].stringValue
        completion(code, msg)
      } else {
        completion(false,responseData.error?.localizedDescription)
      }
    }
  }
}

