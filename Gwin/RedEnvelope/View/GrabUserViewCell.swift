//
//  GrabUserViewCell.swift
//  Gwin
//
//  Created by Hai Vu Van on 8/25/19.
//  Copyright © 2019 Hai Vu Van. All rights reserved.
//

import UIKit

class GrabUserViewCell: UITableViewCell {
  enum Constant {
    static let systemUserno: String = "免死"
  }
  @IBOutlet weak var avatarImageView: UIImageView!
  @IBOutlet weak var wagerTimeLabel: UILabel!

  @IBOutlet weak var usernoLabel: UILabel!
  @IBOutlet weak var amountLabel: UILabel!

  @IBOutlet weak var statusImageView: UIImageView!
  @IBOutlet weak var status2ImageView: UIImageView!
  @IBOutlet weak var status3ImageView: UIImageView!
  
  @IBOutlet weak var extraLabel: UILabel!
  
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

    if model.userno == Constant.systemUserno {
      amountLabel.text = "\(Int(model.packetamount)).**"
      extraLabel.isHidden = true
    }

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

    //
    statusImageView.isHidden = true
    status2ImageView.isHidden = true
    status3ImageView.isHidden = true

    if let status = model.status, let statusValue = Int(status) {
      var digits = statusValue.getDigits()

      for i in 0 ..< digits.count {
        let image = UIImage(named: "grabuser_status_\(i+1)")
        let digit = digits[i]
        if i == 0 {
          statusImageView.isHidden = false
          statusImageView.image = image
        }else if digit == 1{
          status2ImageView.isHidden = false
          status2ImageView.image = image
        }else if digit == 2 {
          status3ImageView.isHidden = false
          status3ImageView.image = image
        }
      }
    }
  }
}

