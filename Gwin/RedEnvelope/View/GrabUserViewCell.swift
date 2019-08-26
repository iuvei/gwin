//
//  GrabUserViewCell.swift
//  Gwin
//
//  Created by Hai Vu Van on 8/25/19.
//  Copyright © 2019 Hai Vu Van. All rights reserved.
//

import UIKit

class GrabUserViewCell: UITableViewCell {

  @IBOutlet weak var avatarImageView: UIImageView!
  @IBOutlet weak var wagerTimeLabel: UILabel!

  @IBOutlet weak var usernoLabel: UILabel!
  @IBOutlet weak var amountLabel: UILabel!
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
    avatarImageView.rounded()
  }

  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)

    // Configure the view for the selected state
  }

  func updateViews(model: GrabUserModel) {
    wagerTimeLabel.text = model.wagertime
    usernoLabel.text = model.userno
    amountLabel.text = "\(model.packetamount)"
    if let imgString = ImageManager.shared.getImage(userno: model.userno) {
      if let data = Data(base64Encoded: imgString, options: []) {
        avatarImageView.image = UIImage(data: data)
      }
    } else {
      guard let user = RedEnvelopComponent.shared.user else { return }
      UserAPIClient.getUserImages(ticket: user.ticket, usernos: [model.userno]) {[weak self] (data, _) in
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

