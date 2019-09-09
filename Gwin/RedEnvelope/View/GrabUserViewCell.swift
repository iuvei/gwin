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

//  @IBOutlet weak var statusImageView: UIImageView!
//  @IBOutlet weak var status2ImageView: UIImageView!
//  @IBOutlet weak var status3ImageView: UIImageView!
  @IBOutlet weak var statusStackView: UIStackView!

  @IBOutlet weak var kingImageView: UIImageView!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
    avatarImageView.rounded()
  }

  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)

    // Configure the view for the selected state
  }

  func updateViews(model: GrabUserModel, packageid: Int64 = 0, outofStock: Bool = false) {
    wagerTimeLabel.text = model.wagertime
    amountLabel.text = "\(model.packetamount.toFormatedString())"

    if model.userno == Constant.systemUserno {
      if model.isExpire() || outofStock {
        amountLabel.text = String(format: "%@", model.packetamount.toFormatedString())
      }else{
        amountLabel.text = "\(Int(model.packetamount)).**"

      }
    }

    if model.userno == RedEnvelopComponent.shared.userno {
      usernoLabel.text = "\(model.userno) (我)"
    }else {
      usernoLabel.text = model.userno
    }

    kingImageView.isHidden = !(LocalDataManager.shared.isKing(userno: model.userno, packageid: packageid) || model.king)

    if model.userno == Constant.systemUserno {
      avatarImageView.image = UIImage(named: "grabuser_system")

    }else {
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

    //
    statusStackView.removeAllArrangedSubviews()
    if let status = model.status, let statusValue = Int(status) {
      let digits = statusValue.getDigits()

      for i in 0 ..< digits.count {
        let statusValue = digits[i]
        let image = UIImage(named: "grabuser_status_\(statusValue)")
        let imageView = UIImageView(image: image).forAutolayout()
        NSLayoutConstraint.activate([
          imageView.widthAnchor.constraint(equalToConstant: 30),
          imageView.heightAnchor.constraint(equalToConstant: 30)])
        statusStackView.addArrangedSubview(imageView)
      }
    }
  }
}

