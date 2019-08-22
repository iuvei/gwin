//
//  RedEnvelopAPIRouter.swift
//  Gwin
//
//  Created by Hai Vu Van on 8/22/19.
//  Copyright © 2019 Hai Vu Van. All rights reserved.
//

import Alamofire

public enum RedEnvelopAPIRouter: URLRequestConvertible {
  // 1
  enum Constants {
    static let baseURLPath = "http://103.40.178.46:5013/api"
    static let contentType = "application/json"
  }

  // 2
  case roomList(String, Int)
  case loginin(String, Int, String)
  case loginout(String, Int)
  case sendPackage(String, Int, Int, Int, String)
  case grabPackage(String, Int, Int)
  case infoPackage(String, Int, Int)
  case historyPackage(String, Int, Int, Int)
  case statusPackage(String, Int, Int)

  // 3
  var method: HTTPMethod {
    switch self {
    case .roomList, .loginin, .loginout, .sendPackage :
      return .post
    default:
      return  .get
    }
  }

  // 4
  var path: String {
    switch self {
    case .roomList:
      return "/room/list"
    case .loginin:
      return "/room/loginin"
    case .loginout:
      return "/room/loginout"
    case .sendPackage:
      return "/packet/send"
    case .grabPackage:
      return "/packet/grab"
    case .infoPackage:
      return "/packet/info"
    case .historyPackage:
      return "/packet/history"
    case .statusPackage:
      return "/packet/status"
    }
  }

  // 5
  var parameters: [String: Any] {
    switch self {
    case .roomList(let ticket, let roomtype):
      return [ "ticket" : ticket,  "data" : ["roomtype" : roomtype]]
    case .loginin(let ticket, let roomtype, let roompwd):
      return [ "ticket" : ticket,  "data" : ["roomid" : roomtype, "roompwd": roompwd]]
    case .loginout(let ticket, let roomId):
      return [ "ticket" : ticket,  "data" : ["roomid": roomId]]
    case .sendPackage(let ticket, let roomId, let amount, let size, let tag):
      return [ "ticket" : ticket,  "data" : ["roomid": roomId, "packetamount": amount, "packetsize": size, "packettag": tag]]
    case .grabPackage(let ticket, let roomId, let packetid):
      return [ "ticket" : ticket,  "data" : ["roomid": roomId, "packetid": packetid]]
    case .infoPackage(let ticket, let roomId, let packetid):
      return [ "ticket" : ticket,  "data" : ["roomid": roomId, "packetid": packetid]]
    case .historyPackage(let ticket, let roomId, let packetid, let topnum):
      return [ "ticket" : ticket,  "data" : ["roomid": roomId, "packetid": packetid, "topnum": topnum]]
    case .statusPackage(let ticket, let roomId, let packetid):
      return [ "ticket" : ticket,  "data" : ["roomid": roomId, "packetid": packetid]]
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
