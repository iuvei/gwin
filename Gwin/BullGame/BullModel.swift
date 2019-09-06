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
  case betClose = 0
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
  var canbet: Bool
  private var wagerTimer: Timer?
//  private var resultWagerTimer: Timer?
  var delegate: BullModelDelegate?

  init(canbet: Bool = false, expire: Bool = false, round: BullRoundModel, historyPackage: BullPackageHistoryModel?, roomid: Int, delegate: BullModelDelegate? = nil){
    self.canbet = canbet
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
    if status == .betClose {
      cancelWagerTimer()
//      expire = true
    }else if status == .addNew && round.status != BullRoundStatus.addNew.rawValue{
      fetchResultWagerInfo()
    }

    round.status = status.rawValue

  }
  func wagerInfoTimer() {
    if wagerTimer == nil{

      wagerTimer = Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(fetchWagerInfo(_:)), userInfo: ["idno": getLastIdno(), "status": 1], repeats: true)
    }
  }

  func resultWagerInfoTimer(cancelCurrent: Bool = false) {
//    if resultWagerTimer == nil{
//      resultWagerTimer = Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(fetchResultWagerInfo(_:)), userInfo: ["idno": 0, "status": 3], repeats: true)
//    }
    fetchResultWagerInfo()
  }

  func cancelWagerTimer(){
    wagerTimer?.invalidate()
    wagerTimer = nil
//    resultWagerTimer?.invalidate()
//    resultWagerTimer = nil
  }

  @objc func fetchWagerInfo(_ timer: Timer? = nil) {
    guard let user = RedEnvelopComponent.shared.user else { return }


    BullAPIClient.wagerinfo(ticket: user.ticket, roomid: roomid, roundid: round.roundid, idno: getLastIdno()) { [weak self](infos, error) in
      guard let this = self else {return}
      print("result result 1 --- \(infos.count)")

      if infos.count == 0 { return }

      if this.addNewWager(wagers: infos) {
        this.delegate?.didGetWagerInfo(roundid:this.round.roundid, wagerInfos: this.betWagerInfo)
      }
    }
  }

  @objc func fetchResultWagerInfo(_ timer: Timer? = nil) {
    guard let user = RedEnvelopComponent.shared.user else { return }


    BullAPIClient.wagerinfo(ticket: user.ticket, roomid: roomid, roundid: round.roundid, idno: 0) { [weak self](infos, error) in
      guard let this = self else {return}
      print("result result 3 ---1 \(infos.map{$0.winning})")
      let winingWagers = infos.filter{$0.winning != 0}
      print("result result 3 ---2 \(winingWagers.count)")

      if winingWagers.count == 0 { return }

      if this.addResultWager(wagers: winingWagers) {
        this.delegate?.didGetResultWagerInfo(roundid:this.round.roundid,wagerInfos: this.resultWagerInfo)
      }
    }
  }

  func isGrabed(_ grabeds: [NSManagedObject] = []) -> Bool {
    let rounid = getRoundId()

    for obj in grabeds {
      if rounid == obj.value(forKey: "packageid") as? Int64 {
        return true
      }
    }

    return false
  }

  func addNewWager(wagers: [BullWagerInfoModel]) -> Bool{
    var hasNew = false
    for info in wagers {
      var has: Bool = false
      for existInfo in betWagerInfo {
        if info.userno == existInfo.userno && info.idno == existInfo.idno {
          has = true
          break
        }
      }
      if !has {
        hasNew = true
        betWagerInfo.append(info)
      }
    }
    return hasNew
  }

  func addResultWager(wagers: [BullWagerInfoModel]) -> Bool{
    var hasNew = false

    for info in wagers {
      var has: Bool = false
      for existInfo in resultWagerInfo {
        if info.userno == existInfo.userno && info.idno == existInfo.idno {
          has = true
          break
        }
      }
      if !has {
        hasNew = true
        resultWagerInfo.append(info)
      }
    }
    return hasNew
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

  func isOnleyself() -> Bool {
//    if !expire {
//      return round.status == BullRoundStatus.betClose.rawValue
//    }
//
//    return false
    return !expire
  }

  func getRoundId() -> Int64 {
    if let package = historyPackage {
      return package.roundid
    }
    return round.roundid
  }
  func getUserno() -> String?{
    if let package = historyPackage {
      return package.userno
    }
    return nil
  }
}

