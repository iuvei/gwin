//
//  Router.swift
//  MovieApp
//
//  Created by German Saprykin on 19/10/17.
//  Copyright © 2017 German Saprykin. All rights reserved.
//

import Foundation
/*
 Base class for general perpose routers.
 It provides basic behaviour that should be adopted by all routers.
 */

public protocol ShiitakeLogger {
  func logCritical(_ tag: String, _ message: String)
}

public var shiitakeLogger: ShiitakeLogger?

open class Router {

  private enum Constants {
    static let shiitakeErrorDetachFailure = "shiitake.router.detach.failure"
  }

  private var children = [Router]()

  public init() {}

  public func attach(router: Router) {
    children.append(router)
    router.routerDidAttach()
  }

  @discardableResult
  public func detach<T>(file: String = #file, line: Int = #line, _: T.Type) -> Bool {
    return detach(file: file, line: line,where: {child in
      child is T
    })
  }

  @discardableResult
  public func detach(file: String = #file, line: Int = #line, where: ((Router) -> Bool)) -> Bool {
    guard let index = children.index(where: `where`)
      else {
        let message = "\(URL(fileURLWithPath: file).lastPathComponent):\(line): Can't find child router to detach"
        shiitakeLogger?.logCritical(Constants.shiitakeErrorDetachFailure, message)
        assertionFailure(message)
        return false
    }
    return detach(file: file, line: line, router: children[index])
  }

  @discardableResult
  public func detach(file: String = #file, line: Int = #line, router: Router) -> Bool {
    guard let index = children.index(where: { $0 === router })
      else {
        let message = "\(URL(fileURLWithPath: file).lastPathComponent):\(line): Can't find child router to detach (\(router))"
        shiitakeLogger?.logCritical(Constants.shiitakeErrorDetachFailure, message)
        assertionFailure(message)
        return false
    }

    children.remove(at: index)
    router.routerDidDetach()
    return true
  }

  fileprivate func routerDidAttach() {
    activate()
    didAttach()
  }

  private func deactivate() {

  }

  private func activate() {
    willActivate()
    getInteractor().activate()
    didActivate()
  }

  // Should be overrided by children if needed logic after activation, don't invoke manualy
  open func didActivate() {

  }

  // Should be overrided by children if needed logic at attach time, don't invoke manualy
  open func didAttach() {

  }

  // Should be overrided by children if needed logic before activation, don't invoke manualy
  open func willActivate() {

  }

  fileprivate func routerDidDetach() {
    getInteractor().deactivate()
    children.forEach { $0.routerDidDetach() }
    children.removeAll()
    didDetach()
  }

  // Should be overrided by children if needed logic at attach time, don't invoke manualy
  open func didDetach() {

  }

  private func parentDidChange() {
    getInteractor().parentDidChange()
  }

  func notifyChildrenParentDidChange() {
    children.forEach { $0.parentDidChange() }
  }

  open func getInteractor() -> Interactor {
    fatalError("Must be overriden by child")
  }

  public func has<T>(_ router: T.Type) -> Bool {
    return children.index(where: {$0 is T}) != nil
  }
}

/*
 Base class for root routers.
 It allows manualy to triger lifecycle events.
 */
open class RootRouter: Router {
  public override func routerDidAttach() {
    super.routerDidAttach()
  }

  public override func routerDidDetach() {
    super.routerDidDetach()
  }
}
