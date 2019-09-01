//
//  BullModel.swift
//  Gwin
//
//  Created by Hai Vu Van on 9/1/19.
//  Copyright © 2019 Hai Vu Van. All rights reserved.
//

import Foundation

class BullModel {
  var round: BullRoundModel?
  var historyPackage: BullPackageHistoryModel?
  
  init(round: BullRoundModel, historyPackage: BullPackageHistoryModel?){
    self.round = round
    self.historyPackage = historyPackage
  }
}
