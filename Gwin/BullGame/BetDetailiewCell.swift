//
//  BetDetailiewCell.swift
//  Gwin
//
//  Created by Hai Vu Van on 8/31/19.
//  Copyright © 2019 Hai Vu Van. All rights reserved.
//

import UIKit

class BetDetailiewCell: UITableViewCell {
  @IBOutlet weak var avatarImageView: UIImageView!
  
  @IBOutlet weak var usernoLabel: UILabel!
  @IBOutlet weak var detailStackView: UIStackView!
  @IBOutlet weak var wagerTimeLabel: UILabel!

  @IBOutlet weak var macketAmount: UILabel!
  @IBOutlet weak var stackHeightConstraint: NSLayoutConstraint!
  @IBOutlet weak var packageTagLabel: UILabel!

  override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

  func updateViews(grabUser: GrabUserModel, details: [BullBetDetailModel]) {
    stackHeightConstraint.constant = CGFloat(details.count * 20)
    if grabUser.userno == RedEnvelopComponent.shared.userno{
      usernoLabel.text = "\(grabUser.userno)(我)"

    }else{
      usernoLabel.text = grabUser.userno

    }
    packageTagLabel.text = String(format: "%@%.2f", grabUser.packettag, grabUser.winnings)
    macketAmount.text = String(format: "%.2f", grabUser.packetamount)
    wagerTimeLabel.text = grabUser.wagertime
    //

    if let imgString = ImageManager.shared.getImage(userno: grabUser.userno) {
      if let data = Data(base64Encoded: imgString, options: []) {
        avatarImageView.image = UIImage(data: data)
      }
    } else {
      guard let user = RedEnvelopComponent.shared.user else { return }
      UserAPIClient.getUserImages(ticket: user.ticket, usernos: [grabUser.userno]) {[weak self] (data, _) in
        guard let _data = data else { return }
        for json in _data {
          let userno = json["userno"].stringValue
          let imgString = json["img"].stringValue
          if let data = Data(base64Encoded: imgString, options: []) {
            self?.avatarImageView.image = UIImage(data: data)
            ImageManager.shared.saveImage(userno: userno, image: imgString)
          }
        }
      }

    }
  }

}
