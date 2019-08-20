//
//  Workflow.swift
//  Shiitake
//
//  Created by Chao-Hong Meng on 23/1/18.
//  Copyright © 2018 GrabTaxi Pte Ltd. All rights reserved.
//

import Foundation
import RxSwift

//TODO: (Jonas)I think this would be a good place to explain what a workflow is.

/**
    An abstraction of the Workflow graph, it provides different hook for the life-cycle of the workflow so you could do the necessary resource management when the workflow ends.
 */
open class Workflow<Actionable> {
  public init() {}

  /**
      The hook when the whole workflow completed
   */
  open func didComplete() {}

  /**
      The hook when the whole workflow produces into Error
   */
  open func didReceiveError(_ error: Error) {}

  /**
   The method to wrap a transformer between `Actionable`s into `Step` so that we could do the chaining

   - parameter closure: A transfomer when given `Actionable` and `()` context (with Interactor as the implementation object behind),
     do the necessary work to lead us to the next `Actionable` and `Value` if any.
   */
  public func onStep<NextActionable, NextValue>(_ closure: @escaping (Actionable) -> Observable<(NextActionable, NextValue)>) -> Step<Actionable, NextActionable, NextValue> {
    return Step(workflow: self,
                context: entranceReady.asObservable().take(1))
      .onStep { (actionable: Actionable, _) in
        closure(actionable)
      }
  }

  /**
      Hook the `Workflow` to an `Interactor`
  */
  public func run(with entranceActionable: Actionable) -> Disposable {
    entranceReady.onNext((entranceActionable, ()))
    return compositeDisposable
  }

  //We should await on the entrance interactor is "active"
  private let entranceReady = PublishSubject<(Actionable, ())>()

  //the life-cycle of the Steps should be ended with Workflow
  fileprivate let compositeDisposable = CompositeDisposable()
}

/**
    A `Step` is a wrapper of an aynchronous operation: `async (NextActionable, NextValue) Step(Actionable actionable, Value value)`,
    to provide an interface so that we could construct the workflow graph by using ".onStep" and ".done()"
    These methods would construct the graph and store it internally, when the `.done()` is called, it would return the graph then
    we could execute it by awaiting the `Interactor` behind the `Actionable` becomes active
 */
open class Step<WorkflowActionable, Actionable, Value> {
  private let workflow: Workflow<WorkflowActionable>
  private var context: Observable<(Actionable, Value)>

  /**
      We need the underlying `workflow` since the `Step`'s life cycle should end with `Workflow`
  */
  init(workflow: Workflow<WorkflowActionable>, context: Observable<(Actionable, Value)>) {
    self.workflow = workflow
    self.context = context
  }

  /**
     The method to wrap a transformer between `Actionable`s into `Step` so that we could do the chaining

     - parameter closure: A transfomer when given `Actionable` and `Value` context (with Interactor as the implementation object behind),
       do the necessary work to lead us to the next `Actionable` and `Value` if any.
  */
  public func onStep<NextActionable, NextValue>(_ closure: @escaping (Actionable, Value) -> Observable<(NextActionable, NextValue)>) -> Step<WorkflowActionable, NextActionable, NextValue> {
    let nextStep = context
      .flatMapLatest { (actionable: Actionable, value: Value) -> Observable<(Bool, Actionable, Value)> in
        //check against if the interactor is active or not
        //and get the latest one by flatMapLatest

        if let queryable = actionable as? ActivenessQueryable {
          //TODO: (Jonas) If it's crucial that we have this, I think it should be documented for users of this API.
          return queryable.isActiveObservable.map { isActive in
            (isActive, actionable, value)
          }
        } else {
          return Observable.just((true, actionable, value))
        }
      }
      .filter { (isActive: Bool, _, _) -> Bool in
        isActive == true
      }
      .take(1)
      .flatMapLatest { (_, actionable, value) in
        //execute the closure
        closure(actionable, value)
      }
      .take(1)
      .share()  // To make sure this chain be only executed once

    return Step<WorkflowActionable, NextActionable, NextValue>(workflow: workflow, context: nextStep)
  }

  /**
      Adds-on an Error handler for this `Step`
   */
  public func onError(_ onError: @escaping ((Error) -> Void)) -> Step<WorkflowActionable, Actionable, Value> {
    context = context.do(onError: onError)
    return self
  }

  /**
      Return the constructed `Workflow` graph
  */
  @discardableResult
  public func done() -> Workflow<WorkflowActionable> {
    let disposable = context
      //TODO: (Jonas) So if you have a tree, didComplete would be called multiple times. Seems a bit unexpected.
      //I'm actually not sure if I see the value of having workflow-global error/completion handling, rather than making it part of done.
                      .do(onError: workflow.didReceiveError, onCompleted: workflow.didComplete)
                      .subscribe()
    _ = workflow.compositeDisposable.insert(disposable)
    return workflow
  }
}
