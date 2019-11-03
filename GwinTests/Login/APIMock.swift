//
//  APIMock.swift
//  GwinTests
//
//  Created by Hai Vu Van on 10/12/19.
//  Copyright © 2019 Hai Vu Van. All rights reserved.
//

import Foundation
import XCTest
import Gwin
import SwiftyJSON

class APIMock {
  public func responseDataFromFile(_ fileName: String) -> Data? {
    final class BundleClass {}
    let bundle = Bundle(for: BundleClass.self)
    guard let pathUrl = bundle.url(forResource: fileName, withExtension: "json") else {
      return nil
    }
    return try? Data(contentsOf: pathUrl)
  }

  public func jsonFromFile (_ fileName: String) -> JSON? {
    if let path = Bundle.main.path(forResource: fileName, ofType: "json") {
      do {
        let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .alwaysMapped)
        let jsonObj = try JSON(data: data)
        return jsonObj
      } catch let error {
        print("parse error: \(error.localizedDescription)")
      }
    } else {
      print("Invalid filename/path.")
    }
    return nil
  }

  public func getUserFrom(_ fileName: String) -> User? {
    guard let fileData = responseDataFromFile(fileName) else {
      XCTAssert(false, "\(fileName) is missing")
      return nil
    }

    //when
    let json = JSON(fileData)
    return User(dictionary: json)
  }
}
