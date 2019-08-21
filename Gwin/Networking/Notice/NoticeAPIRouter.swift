//
//  NoticeAPIRouter.swift
//  Gwin
//
//  Created by Hai Vu Van on 8/21/19.
//  Copyright © 2019 Hai Vu Van. All rights reserved.
//

import Alamofire

public enum NoticeAPIRouter: URLRequestConvertible {
  // 1
  enum Constants {
    static let baseURLPath = "http://103.40.178.46:5013/api/notice"
    static let contentType = "application/json"
  }

  // 2
  case rollMsg(String, Int)
  case popupMsg(String)
  case popularizeImage(String)
  // 3
  var method: HTTPMethod {
    switch self {
    case .rollMsg, .popupMsg, .popularizeImage :
      return .post
    }
  }

  // 4
  var path: String {
    switch self {
    case .rollMsg:
      return "/rollmsg"
    case .popupMsg:
      return "/popupmsg"
    case .popularizeImage:
      return "/popularizeimage"
    }
  }

  // 5
  var parameters: [String: Any] {
    switch self {
    case .rollMsg(let ticket, let mstType):
      return [ "ticket" : ticket,  "data" : ["msgtype" : mstType]]
    case .popupMsg(let ticket):
      return [ "ticket" : ticket,  "data" : ""]
    case .popularizeImage(let ticket):
      return [ "ticket" : ticket,  "data" : ""]
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
