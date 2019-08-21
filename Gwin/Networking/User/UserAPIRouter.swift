//
//  UserAPIRouter.swift
//  Gwin
//
//  Created by Hai Vu Van on 8/20/19.
//  Copyright © 2019 Hai Vu Van. All rights reserved.
//

import Alamofire

public enum UserAPIRouter: URLRequestConvertible {
  // 1
  enum Constants {
    static let baseURLPath = "http://103.40.178.46:5013/api/user"
    static let contentType = "application/json"
  }

  // 2
  case login(String, String)
  case checkCellphoneNo(String)
  case accountExist(String)
  case register(String, String, String, String)
  case userInfo(String)
  case setOnline(String, String)
  case inMoney(String, String)
  case logout(String, String)
  case otherH5(String, String)
  case accountPrefix(String)
  // 3
  var method: HTTPMethod {
    switch self {
    case .login, .checkCellphoneNo, .accountExist, .register, .userInfo, .otherH5, .accountPrefix:
      return .post
    default:
      return .get
    }
  }

  // 4
  var path: String {
    switch self {
    case .login:
      return "/login"
    case .checkCellphoneNo:
      return "/checkcellphoneno"
    case .accountExist:
      return "/isexist"
    case .register:
      return "/register"
    case .userInfo:
      return "/userinfo"
    case .setOnline:
      return "/setonline"
    case .inMoney:
      return "/inmoney"
    case .logout:
      return "/logout"
    case .otherH5:
      return "/JumpUrl"
    case .accountPrefix:
      return "/prefix"
    }
  }

  // 5
  var parameters: [String: Any] {
    switch self {
    case .login(let accountNo, let pwd):
      return [ "data" : ["accountno" : accountNo, "pwd" : pwd]]
    case .checkCellphoneNo(let cellphoneNo):
        return [ "data" : ["cellphoneno" : cellphoneNo]]
    case .accountExist(let accountNo):
      return [ "data" : ["accountno" : accountNo]]
    case .register(let accountNo, let pwd, let code, let cellphoneNo):
      return [ "data" : ["accountno": accountNo, "pwd" : pwd, "code" : code, "cellphoneno" : cellphoneNo]]
    case .setOnline(let ticket, let guid):
      return ["ticket" : ticket , "data" : ["guid" : guid]]
    case .inMoney(let ticket, let money):
      return ["ticket" : ticket , "data" : ["money" : money]]
    case .logout(let ticket, let guid):
      return ["ticket" : ticket , "data" : ["guid" : guid]]
    case .otherH5(let ticket, let optype):
      return ["ticket" : ticket , "data" : ["optype" : optype]]
    case .accountPrefix(let prefix):
      return ["data" : ["prefix" : prefix]]
    default:
      return [:]
    }
  }

  // 6
  public func asURLRequest() throws -> URLRequest {
    let url = try Constants.baseURLPath.asURL()

    var request = URLRequest(url: url.appendingPathComponent(path))
    request.httpMethod = method.rawValue
    request.setValue(Constants.contentType, forHTTPHeaderField: "Content-Type")
    request.setValue(Constants.contentType, forHTTPHeaderField: "Accept")


    request.timeoutInterval = TimeInterval(10 * 1000)

    return try JSONEncoding.default.encode(request, with: parameters)
  }
}
