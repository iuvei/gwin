//
//  BankerViewCell.swift
//  Gwin
//
//  Created by Hai Vu Van on 9/2/19.
//  Copyright © 2019 Hai Vu Van. All rights reserved.
//

import UIKit

class BankerViewCell: UITableViewCell {

  @IBOutlet weak var indexLabel: UILabel!
  @IBOutlet weak var usernoLabel: UILabel!
  @IBOutlet weak var timeLabel: UILabel!
  @IBOutlet weak var stakeLabel: UILabel!
  
  @IBOutlet weak var unknowLabel: UILabel!
  @IBOutlet weak var amountLabel: UILabel!
  override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

  func updateViews(index: Int, banker: BankGetModel) {
    indexLabel.text = String(format: "%d", index + 1)
    usernoLabel.text = banker.userno
    unknowLabel.text = String("\(banker.roundid)".suffix(4))
    amountLabel.text = banker.lockquota
    stakeLabel.text = String(format: "%d-%d", banker.stake1,banker.state2)
    timeLabel.text = banker.opentime.toString(dateFormat: "HH:mm:ss")
  }
    
}
