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

  @IBOutlet weak var expandButton: UIButton!
  @IBOutlet weak var usernoLabel: UILabel!
  @IBOutlet weak var detailStackView: UIView!
  @IBOutlet weak var wagerTimeLabel: UILabel!

  @IBOutlet weak var macketAmount: UILabel!
  @IBOutlet weak var stackHeightConstraint: NSLayoutConstraint!
  @IBOutlet weak var packageTagLabel: UILabel!
  var didExpandDetail: (Bool)->Void = {_ in }
  private var grabUser: GrabUserModel?

  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
    avatarImageView.rounded()
  }

  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)

    // Configure the view for the selected state
  }

  func updateViews(grabUser: GrabUserModel, details: [BullBetDetailModel]) {
    self.grabUser = grabUser
    if grabUser.userno == RedEnvelopComponent.shared.userno{
      usernoLabel.text = "\(grabUser.userno)(我)"

    }else{
      usernoLabel.text = grabUser.userno

    }
    packageTagLabel.text = String(format: "%@%@", grabUser.packettag, grabUser.winnings.toFormatedString())
    macketAmount.text = String(format: "%@", grabUser.packetamount.toFormatedString())
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
    //
    for view in detailStackView.subviews {
      view.removeFromSuperview()
    }

    if grabUser.expand{
      expandButton.setImage(UIImage(named: "image_colapse"), for: .normal)
      for i in 0 ..< details.count {
        let detail = details[i]
        let label = getDetailView(detail: detail)

        detailStackView.addSubview(label)
        NSLayoutConstraint.activate([
          label.heightAnchor.constraint(equalToConstant: 17),
          label.centerXAnchor.constraint(equalTo: detailStackView.centerXAnchor),
          label.leftAnchor.constraint(equalTo: detailStackView.leftAnchor),
          label.rightAnchor.constraint(equalTo: detailStackView.rightAnchor),
          label.topAnchor.constraint(equalTo: detailStackView.topAnchor, constant: CGFloat(18 * i)),
          ])
      }
      stackHeightConstraint.constant = CGFloat(details.count * 18)
    }else{
      stackHeightConstraint.constant = 0
      expandButton.setImage(UIImage(named: "image_expand"), for: .normal)

    }

  }

  @IBAction func expandPressed(_ sender: Any) {
    //    if let `grabUser` = grabUser {
    //      grabUser.expand = !grabUser.expand
    //      didExpandDetail(grabUser.expand)
    //    }
  }

  func getDetailView(detail: BullBetDetailModel) -> UIView {
    let view = UIView().forAutolayout()
    view.backgroundColor = .groupTableViewBackground
    let normalFont = UIFont.systemFont(ofSize: 11)
    let boldFont = UIFont.systemFont(ofSize: 11, weight: .medium)

    let titleLabel = UILabel().forAutolayout()
    titleLabel.font = normalFont
    let objectLabel = UILabel().forAutolayout()
    objectLabel.font = boldFont

    let takeLabel = UILabel().forAutolayout()
    takeLabel.font = boldFont

    let takeTitleLabel = UILabel().forAutolayout()
    takeTitleLabel.font = normalFont

    view.addSubview(titleLabel)
    view.addSubview(objectLabel)
    view.addSubview(takeLabel)
    view.addSubview(takeTitleLabel)
    
    NSLayoutConstraint.activate([
      titleLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 30),
      titleLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),

      objectLabel.leftAnchor.constraint(equalTo: titleLabel.rightAnchor, constant: 15),
      objectLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),

      takeLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10),
      takeLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),

      takeTitleLabel.rightAnchor.constraint(equalTo: takeLabel.leftAnchor, constant: -15),
      takeTitleLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
      ])

    titleLabel.text = "下注内容"
    objectLabel.text = "\(detail.wagertypename)/\(detail.wagerobject)"
    takeLabel.text = String(format: "%@", detail.stake.toFormatedString())
    takeTitleLabel.text = "下注金额"
    return view
  }
}

