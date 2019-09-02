//
//  BankSettingViewCell.swift
//  Gwin
//
//  Created by Hai Vu Van on 8/29/19.
//  Copyright © 2019 Hai Vu Van. All rights reserved.
//

import UIKit

class BankSettingViewCell: UITableViewCell {

  @IBOutlet weak var lockquotaLabel: UILabel!

  @IBOutlet weak var stakeLabel: UILabel!

  override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

  func updateViews(model: BankSettingModel, selected: Bool = false) {
    lockquotaLabel.text = "\(model.lockquota)"
    stakeLabel.text = "\(model.stake1)-\(model.stake2)"

    if selected {
      contentView.backgroundColor = AppColors.tabbarColor
    } else {
      contentView.backgroundColor = .white

    }
  }
    
}
