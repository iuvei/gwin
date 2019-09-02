//
//  BullAPIRouter.swift
//  Gwin
//
//  Created by Hai Vu Van on 8/23/19.
//  Copyright © 2019 Hai Vu Van. All rights reserved.
//

import Foundation

import Alamofire

public enum BullAPIRouter: URLRequestConvertible {
  // 1
  enum Constants {
    static let baseURLPath = "http://103.40.178.46:5013/api/niuniu"
    static let contentType = "application/json"
  }

  // 2
  case round(String, Int)
  case banksetting(String)
  case banker_get(String, Int , Int64, Int)
  case setbanker(String,  Int, Int, Int64, Int, Int)
  case betting(String,  Int, Int64, String)
  case grab(String, Int, Int64)
  case info(String, Int, Int64, Int)
  case packethistory(String, Int, Int64, Int)
  case history(String, Int, Int64, Int)
  case packetstatus(String, Int, Int64)
  case wagerinfo(String, Int, Int64, Int)
  case betdetail(String, Int, Int64, String)
  case wagerodds(String, Int)
  // 3
  var method: HTTPMethod {
//    switch self {
//      case .round, .banksetting, .banker_get, .setbanker, .betting, .grab, .info :
//        return .post
//      default:
//        return .get
//    }
    return .post
  }

  // 4
  var path: String {
    switch self {
    case .round:
      return "/round"
    case .banksetting:
      return "/banksetting"
    case .banker_get:
      return "/banker_get"
    case .setbanker:
      return "/setbanker"
    case .betting:
      return "/betting"
    case .grab:
      return "/grab"
    case .info:
      return "/info"
    case .packethistory:
      return "/packethistory"
    case .history:
      return "/history"
    case .packetstatus:
      return "/packetstatus"
    case .wagerinfo:
      return "/wagerinfo"
    case .betdetail:
      return "/betdetail"
    case .wagerodds:
      return "/wagerodds"
    }
  }

  // 5
  var parameters: [String: Any] {
    switch self {
    case .round(let ticket, let roomid):
      return [ "ticket" : ticket,  "data" : ["roomid" : roomid]]
    case .banksetting(let ticket):
      return [ "ticket" : ticket]
    case .banker_get(let ticket,let roomid, let roundid, let pagesize):
      return [ "ticket" : ticket,  "data" : ["roomid": roomid, "roundid": roundid, "pagesize": pagesize]]
    case .setbanker(let ticket, let roomid, let bankqty, let lockquota, let stake1, let stake2):
        return [ "ticket" : ticket,  "data" : ["roomid": roomid, "bankqty": bankqty, "lockquota": lockquota, "stake1": stake1 , "stake2": stake2 ]]
    case .betting(let ticket,let roomid, let roundid, let wagers):
      return [ "ticket" : ticket,  "data" : ["roomid": roomid, "roundid": roundid, "wagers": wagers]]
    case .grab(let ticket,let roomid, let roundid):
      return [ "ticket" : ticket,  "data" : ["roomid": roomid, "roundid": roundid]]
    case .info(let ticket,let roomid, let roundid, let onlyself):
      return [ "ticket" : ticket,  "data" : ["roomid": roomid, "roundid": roundid, "onlyself": onlyself]]
    case .packethistory(let ticket,let roomid, let roundid, let topnum):
      return [ "ticket" : ticket,  "data" : ["roomid": roomid, "roundid": roundid, "topnum": topnum]]
    case .history(let ticket,let roomid, let roundid, let pagesize):
      return [ "ticket" : ticket,  "data" : ["roomid": roomid, "roundid": roundid, "pagesize": pagesize]]
    case .packetstatus(let ticket,let roomid, let roundid):
      return [ "ticket" : ticket,  "data" : ["roomid": roomid, "roundid": roundid]]
    case .wagerinfo(let ticket,let roomid, let roundid, let idno):
      return [ "ticket" : ticket,  "data" : ["roomid": roomid, "roundid": roundid, "idno": idno]]
    case .betdetail(let ticket,let roomid, let roundid, let userno):
      return [ "ticket" : ticket,  "data" : ["roomid": roomid, "roundid": roundid, "userno": userno]]
    case .wagerodds(let ticket, let roomtype):
      return [ "ticket" : ticket,  "data" : ["roomtype": roomtype]]

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
