//
//  LoginInteractorTest.swift
//  GwinTests
//
//  Created by Hai Vu Van on 10/12/19.
//  Copyright © 2019 Hai Vu Van. All rights reserved.
//

import XCTest
import SwiftyJSON

@testable import Gwin

class LoginInteractorTest: XCTestCase {
  var interactor: LoginInteractor!
  var router: LoginMock.Router!
  var view: LoginMock.View!
//  var listener: CategoryListingHomeMock.Listener!
//  var analyticsService: CategoryListingHomeMock.AnalyticsService!
//  let serviceProvider = CategoryListingServiceImp()
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
      view = LoginMock.View()
      interactor = LoginInteractor(withListener: nil)

      router = LoginMock.Router()

      interactor.router = router
      interactor.view = view
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

  func testLogin() {
    //given
    let accountNo = "steven1"
    let password = "123456"

    //when
    UserDefaultManager.sharedInstance().saveLoginInfo(accountNo: accountNo, password: password)

    view.startLoadingView()
    LoginAPIMock().validLogin(accountNo: accountNo, password: password) {[weak self] (user, message) in
      guard let `this` = self else { return }
      this.view.endLoadingView()

      if let `user` = user {
        RedEnvelopComponent.shared.userno = accountNo
        RedEnvelopComponent.shared.user = user
        if let appDelegate: AppDelegate = UIApplication.shared.delegate as? AppDelegate {
          appDelegate.setHomeAsRootViewControlelr()
        }
      } else {
        if let error = message {
          this.view.loginFailedWithMessage(message: error)
        }
      }
    }

    XCTAssertTrue(view.isStartLoadingViewCalled)
    XCTAssertTrue(view.isEndLoadingViewCalled)
    XCTAssertNotNil(RedEnvelopComponent.shared.user)
  }

}
