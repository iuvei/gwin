//
//  Interactor.swift
//  MovieApp
//
//  Created by German Saprykin on 17/10/17.
//  Copyright © 2017 German Saprykin. All rights reserved.
//

import Foundation
import RxSwift

// While we are executing the workflow steps against the RIB tree,
// we have to query against if a certain node is active or not,
// if not we have to wait of it is existence and constructed to a ready state.
// That could be done by subscribing on the `isActive`
public protocol ActivenessQueryable {
  var isActive: Bool { get }
  var isActiveObservable: Observable<Bool> { get }
}

open class Interactor: ActivenessQueryable {
  fileprivate var activenessDisposable: CompositeDisposable?

  public init() {}

  open func parentDidChange() {}

  // interactor should be inactive when constructed.
  private let isActiveSubject: BehaviorSubject<Bool> = BehaviorSubject(value: false)

  public var isActive: Bool {
    do {
      return try isActiveSubject.value()
    } catch {
      return false
    }
  }

  public var isActiveObservable: Observable<Bool> {
    return isActiveSubject.distinctUntilChanged()
  }

  func activate() {
    guard !isActive else {
      assertionFailure("interactor should be inactive")
      return
    }

    activenessDisposable = CompositeDisposable()

    isActiveSubject.onNext(true)

    didBecomeActive()
  }

  open func didBecomeActive() {}

  func deactivate() {
    guard isActive else {
      assertionFailure("interactor should be active")
      return
    }

    willResignActive()

    activenessDisposable?.dispose()
    activenessDisposable = nil

    isActiveSubject.onNext(false)
  }

  open func willResignActive() {}

  /**
   * Use streams to update children
   */
  public func _deprecated_setState(_ block:() -> Void) {
    block()
    notifyChildren()
  }

  private weak var baseRouter: Router?
  public func set(baseRouter: Router) {
    self.baseRouter = baseRouter
  }

  private func notifyChildren() {
    guard let router = baseRouter else {
      assertionFailure("baseRouter is nil. Broken lifecycle or not initiated via set(baseRouter:)")
      return
    }
    router.notifyChildrenParentDidChange()
  }

  deinit {
    if isActive {
      deactivate()
    }

    isActiveSubject.onCompleted()
  }
}

extension Disposable {
  public func disposeOnDeactivate(_ interactor: Interactor) {
    if let bag = interactor.activenessDisposable {
      _ = bag.insert(self)
    } else {
      dispose()
    }
  }
}
