//
//  LoginAPIMock.swift
//  GwinTests
//
//  Created by Hai Vu Van on 10/12/19.
//  Copyright © 2019 Hai Vu Van. All rights reserved.
//

import Foundation
import Gwin
import SwiftyJSON

class LoginAPIMock: APIMock {
  func validLogin(accountNo: String, password: String, completion:@escaping (User?,String?)->Void) {
    if let jsonResponse = jsonFromFile("LoginSuccessResponse"){

      let msg = jsonResponse["msg"].string
      var user: User? = nil
      let code = jsonResponse["code"].intValue
      if  code == 1 {
        user = User(dictionary: jsonResponse)
      }

      completion(user,msg)
    } else {
      completion(nil, nil)
    }
  }
}
