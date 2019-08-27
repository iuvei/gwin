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
  override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

  func updateViews(model: PackageHistoryModel, isOpen: Bool){
    usernameLabel.text = model.userno
    
    if model.packettag.count > 0 {
      amountLabel.text = "\(model.packetamount)-\(model.packettag)"
    }else {
      amountLabel.text = "\(model.packetamount)"
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
  }
}
