//
//  PackageHistoryLeftViewCell.swift
//  Gwin
//
//  Created by Hai Vu Van on 8/24/19.
//  Copyright © 2019 Hai Vu Van. All rights reserved.
//

import UIKit

class PackageHistoryLeftViewCell: UITableViewCell {

  @IBOutlet weak var usernameLabel: UILabel!
  @IBOutlet weak var avatarImageView: UIImageView!
  @IBOutlet weak var backgroundImageView: UIImageView!
  @IBOutlet weak var amountLabel: UILabel!
  @IBOutlet weak var wagerTimeLabel: UILabel!

  @IBOutlet weak var statusImageView: UIImageView!

  @IBOutlet weak var expiredLabel: UILabel!
  @IBOutlet weak var evelopNameLabel: UILabel!

  @IBOutlet weak var wagerStackView: UIStackView!
  @IBOutlet weak var resultWagerInfoStackView: UIStackView!

  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
    avatarImageView.rounded()
  }

  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)

    // Configure the view for the selected state
  }

  func updateViews(model: PackageHistoryModel, isOpen: Bool, isKing: Bool = false, isBoomed: Bool = false, expired: Bool = false){
    usernameLabel.text = model.userno

    if model.packettag.count > 0 {
      amountLabel.text = "\(model.packetamount)-\(model.packettag)"
      evelopNameLabel.text = "扫雷红包"
    }else {
      amountLabel.text = "\(model.packetamount)"
      evelopNameLabel.text = "福利红包"
    }

    wagerTimeLabel.text = "\(model.packetid) \(model.wagertime)"
    if let imagebase64 = ImageManager.shared.getImage(userno: model.userno) {
      if let imageData = Data(base64Encoded: imagebase64, options: []) {
        let image  = UIImage(data: imageData)
        avatarImageView.image = image
      }
    }
    if isOpen {
      backgroundImageView.image = UIImage(named: "package_left_bg_read")
    } else {
      backgroundImageView.image = UIImage(named: "package_left_bg")
    }
    if isBoomed {
      statusImageView.isHidden = false
      statusImageView.image = UIImage(named: "grabuser_boom")
    } else {
      if isKing {
        statusImageView.isHidden = false
        statusImageView.image = UIImage(named: "grabuser_king")
      } else {
        statusImageView.isHidden = true
      }
    }
    if expired{
      expiredLabel.text = "红包已过期"
    }else{
      expiredLabel.text = "红包炸雷"
    }
  }


  func updateBullViews(model: BullPackageHistoryModel, isOpen: Bool = false, isKing: Bool = false, isBoomed: Bool = false, expired: Bool = false){
    usernameLabel.text = model.userno

    if model.packettag.count > 0 {
      amountLabel.text = "\(model.packetamount)-\(model.packettag)"
      evelopNameLabel.text = "扫雷红包"
    }else {
      amountLabel.text = "\(model.packetamount)"
      evelopNameLabel.text = "福利红包"
    }

    wagerTimeLabel.text = "\(model.wagertime)"
    if let imagebase64 = ImageManager.shared.getImage(userno: model.userno) {
      if let imageData = Data(base64Encoded: imagebase64, options: []) {
        let image  = UIImage(data: imageData)
        avatarImageView.image = image
      }
    }
    if isOpen {
      backgroundImageView.image = UIImage(named: "package_left_bg_read")
    } else {
      backgroundImageView.image = UIImage(named: "package_left_bg")
    }
    if isBoomed {
      statusImageView.isHidden = false
      statusImageView.image = UIImage(named: "grabuser_boom")
    } else {
      if isKing {
        statusImageView.isHidden = false
        statusImageView.image = UIImage(named: "grabuser_king")
      } else {
        statusImageView.isHidden = true
      }
    }
    
    expiredLabel.text = "\(model.roundid)"

    wagerStackView.removeAllArrangedSubviews()
    for info in model.wagerInfo {
      let label = UILabel().forAutolayout()
      label.font = UIFont.systemFont(ofSize: 12)
      label.text = "\(info.userno) XX \(info.stake)"
      wagerStackView.addArrangedSubview(label)
    }

    for info in model.resultWagerInfo {
      let label = UILabel().forAutolayout()
      label.font = UIFont.systemFont(ofSize: 12)
      label.text = "\(info.userno) YY \(info.stake)"
      resultWagerInfoStackView.addArrangedSubview(label)
    }
  }
}

