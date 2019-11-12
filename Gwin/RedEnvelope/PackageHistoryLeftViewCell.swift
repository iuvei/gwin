//
//  PackageHistoryLeftViewCell.swift
//  Gwin
//
//  Created by Hai Vu Van on 8/24/19.
//  Copyright © 2019 Hai Vu Van. All rights reserved.
//

import UIKit

class PackageHistoryLeftViewCell: UITableViewCell {
  enum Constants {
    static let defaultInfoHeight: CGFloat = 150
  }
  @IBOutlet weak var usernameLabel: UILabel!
  @IBOutlet weak var avatarImageView: UIImageView!
  @IBOutlet weak var backgroundImageView: UIImageView!
  @IBOutlet weak var amountLabel: UILabel!
  @IBOutlet weak var wagerTimeLabel: UILabel!

  @IBOutlet weak var bullInfoView: UIView!
  @IBOutlet weak var statusImageView: UIImageView!

  @IBOutlet weak var expiredLabel: UILabel!
  @IBOutlet weak var evelopNameLabel: UILabel!

  @IBOutlet weak var wagerStackView: UIView!
  @IBOutlet weak var resultWagerInfoStackView: UIView!

  @IBOutlet weak var topStackHeightConstraint: NSLayoutConstraint!

  @IBOutlet weak var middleHeightConstraint: NSLayoutConstraint!
  @IBOutlet weak var bottomStackHeightConstraint: NSLayoutConstraint!

  @IBOutlet weak var top: NSLayoutConstraint!
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
    }else {
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
      expiredLabel.text = "查看红包"
    }else{
      expiredLabel.text = "红包炸雷"
    }
    topStackHeightConstraint.constant = 0
    bottomStackHeightConstraint.constant = 0
  }


  func updateBullViews(bull: BullModel, isOpen: Bool = false, isKing: Bool = false, isBoomed: Bool = false, expired: Bool = false){
    amountLabel.text = "牛牛红包"
    evelopNameLabel.text = "领取红包"

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

    avatarImageView.image = UIImage(named: "bull_avatar")
    if  let model = bull.historyPackage {
      usernameLabel.text = model.userno
      wagerTimeLabel.text = "\(model.wagertime)"
      expiredLabel.text = "\(model.roundid)"
    }else {
      expiredLabel.text = "\(bull.round.roundid)"
      usernameLabel.text = "平台"
      wagerTimeLabel.text = "\(bull.round.winningtime.toString())"
    }

    for subview in wagerStackView.subviews {
      subview.removeFromSuperview()
    }

    let betWagers = bull.betWagerInfo.sorted {($0.idno < $1.idno) || ($0.userno == RedEnvelopComponent.shared.userno)}

    for i in 0 ..< betWagers.count {
      let info = betWagers[i]
      let label = UILabel().forAutolayout()
      label.font = UIFont.systemFont(ofSize: 12)
      label.text = String(format: "  %@ %@ %@ %@  ", info.userno,AppText.betSuccess, info.wagertypename, info.stake.toFormatedString())
      label.backgroundColor = AppColors.betBgColor
      label.textColor = .white
      label.rounded(radius: 2, borderColor: .clear, borderwidth: 0)
      wagerStackView.addSubview(label)
      NSLayoutConstraint.activate([
        label.heightAnchor.constraint(equalToConstant: 18),
        label.centerXAnchor.constraint(equalTo: wagerStackView.centerXAnchor),
        label.topAnchor.constraint(equalTo: wagerStackView.topAnchor, constant: CGFloat(20 * i))
        ])
    }

    for subview in resultWagerInfoStackView.subviews {
      subview.removeFromSuperview()
    }

    let resultWagers = bull.resultWagerInfo.sorted {$0.idno < $1.idno}

    for i in 0 ..< resultWagers.count {
      let info = resultWagers[i]
      let label = UILabel().forAutolayout()
      label.font = UIFont.systemFont(ofSize: 12)
      label.text = String(format: "  %@ %@ %@ %@, %@ %@  ", AppText.thisRound, info.userno, AppText.betPlace, info.packettag ,info.winning < 0 ? AppText.betTotalLose : AppText.betTotalWin,info.winning.toFormatedString())
      label.backgroundColor = AppColors.betResultBgColor
      label.textColor = .white
      label.rounded(radius: 2, borderColor: .clear, borderwidth: 0)
      resultWagerInfoStackView.addSubview(label)
      NSLayoutConstraint.activate([
        label.heightAnchor.constraint(equalToConstant: 18),
        label.centerXAnchor.constraint(equalTo: resultWagerInfoStackView.centerXAnchor),
        label.topAnchor.constraint(equalTo: resultWagerInfoStackView.topAnchor, constant: CGFloat(20 * i))
        ])
    }

    let height1 =  bull.betWagerInfo.count * 20
    let height2 =  bull.resultWagerInfo.count * 20

    topStackHeightConstraint.constant = CGFloat(height1)
    bottomStackHeightConstraint.constant = CGFloat(height2)

    if bull.canbet || bull.round.status == BullRoundStatus.betClose.rawValue {
      middleHeightConstraint.constant = 0
      bullInfoView.isHidden = true
      top.constant = 0
    }else {
      middleHeightConstraint.constant = Constants.defaultInfoHeight
      top.constant = Constants.defaultInfoHeight

      bullInfoView.isHidden = false
    }

    wagerStackView.updateConstraintsIfNeeded()
    resultWagerInfoStackView.updateConstraintsIfNeeded()
    updateConstraintsIfNeeded()
    contentView.updateConstraintsIfNeeded()
  }
}




