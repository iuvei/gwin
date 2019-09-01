//
//  BullModel.swift
//  Gwin
//
//  Created by Hai Vu Van on 9/1/19.
//  Copyright © 2019 Hai Vu Van. All rights reserved.
//

import Foundation
import CoreData

public enum BullRoundStatus: Int {
  case addNew = 2
  case betStart = 1
  case betResult = 3
  case betRemove = 0
}

protocol BullModelDelegate: AnyObject {
  func didGetWagerInfo(roundid: Int64, wagerInfos: [BullWagerInfoModel])
  func didGetResultWagerInfo(roundid: Int64, wagerInfos: [BullWagerInfoModel])

  //  func didGetResultWagerInfo(roundid: Int64)
}

class BullModel {
  var round: BullRoundModel
  var historyPackage: BullPackageHistoryModel?
  var betWagerInfo: [BullWagerInfoModel] = []
  var resultWagerInfo: [BullWagerInfoModel] = []
  var expire: Bool
  var roomid: Int
  private var wagerTimer: Timer?
  private var resultWagerTimer: Timer?
  var delegate: BullModelDelegate?

  init(expire: Bool = false, round: BullRoundModel, historyPackage: BullPackageHistoryModel?, roomid: Int, delegate: BullModelDelegate? = nil){
    self.expire = expire
    self.round = round
    self.historyPackage = historyPackage
    self.roomid = roomid
    self.delegate = delegate
  }

  deinit {
    cancelWagerTimer()
  }
  func updateRoundStatus(status: BullRoundStatus) {
    round.status = status.rawValue
    if status == .betRemove {
      cancelWagerTimer()
    }
  }
  func wagerInfoTimer() {
    if wagerTimer == nil{

      wagerTimer = Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(fetchWagerInfo(_:)), userInfo: ["idno": getLastIdno(), "status": 1], repeats: true)
    }
  }

  func resultWagerInfoTimer() {
    if resultWagerTimer == nil{
      resultWagerTimer = Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(fetchResultWagerInfo(_:)), userInfo: ["idno": 0, "status": 3], repeats: true)
    }
  }

  func cancelWagerTimer(){
    wagerTimer?.invalidate()
    wagerTimer = nil
    resultWagerTimer?.invalidate()
    resultWagerTimer = nil
  }

  @objc func fetchWagerInfo(_ timer: Timer) {
    guard let user = RedEnvelopComponent.shared.user else { return }

    guard let userInfo = timer.userInfo as? [String: Any] else { return }
    guard let _idno = userInfo["idno"] as? Int else  { return }
    //guard let _status = userInfo["status"]  as? Int else { return }

    BullAPIClient.wagerinfo(ticket: user.ticket, roomid: roomid, roundid: round.roundid, idno: _idno) { [weak self](infos, error) in
      guard let this = self else {return}
      print("result result 1 --- \(infos.count)")

      if infos.count == 0 { return }

      this.addNewWager(wagers: infos)
      this.delegate?.didGetWagerInfo(roundid:this.round.roundid, wagerInfos: this.betWagerInfo)
    }
  }

  @objc func fetchResultWagerInfo(_ timer: Timer? = nil) {
    guard let user = RedEnvelopComponent.shared.user else { return }


    BullAPIClient.wagerinfo(ticket: user.ticket, roomid: roomid, roundid: round.roundid, idno: 0) { [weak self](infos, error) in
      guard let this = self else {return}
      print("result result 3 --- \(infos.count)")

      if infos.count == 0 { return }

      this.addResultWager(wagers: infos)
      this.delegate?.didGetResultWagerInfo(roundid:this.round.roundid,wagerInfos: this.betWagerInfo)

    }
  }

  func isGrabed(_ grabeds: [NSManagedObject] = []) -> Bool {
    guard let package = historyPackage else {return false}
    for obj in grabeds {
      if package.roundid == obj.value(forKey: "packageid") as? Int64 {
        return true
      }
    }
    return false

  }

  func addNewWager(wagers: [BullWagerInfoModel]){
    for info in wagers {
      var has: Bool = false
      for existInfo in betWagerInfo {
        if info.userno == existInfo.userno{
          has = true
          break
        }
      }
      if !has {
        betWagerInfo.append(info)
      }
    }
  }

  func addResultWager(wagers: [BullWagerInfoModel]){
    for info in wagers {
      var has: Bool = false
      for existInfo in resultWagerInfo {
        if info.userno == existInfo.userno{
          has = true
          break
        }
      }
      if !has {
        resultWagerInfo.append(info)
      }
    }
  }

  func getLastIdno() -> Int{
    if let last = betWagerInfo.last {
      return last.idno
    }
    return 0
  }

  func countWagerInfo() -> Int {
    return resultWagerInfo.count + betWagerInfo.count
  }
}

