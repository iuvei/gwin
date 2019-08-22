//
//  ProfileItemViewCell.swift
//  Gwin
//
//  Created by Hai Vu Van on 8/22/19.
//  Copyright © 2019 Hai Vu Van. All rights reserved.
//

import UIKit
import SwiftyJSON

enum ItemType {
  case arrow
  case button
  case onOff
  case none
}

struct ProfileItemModel {
  var icon: String
  var title: String
  init(json: JSON) {
    icon = json["icon"].stringValue
    title = json["title"].stringValue
  }
}

class ProfileItemViewCell: UITableViewCell {
  enum Constants {
    static let defaultMargin: CGFloat = 4
  }

  private lazy var iconImageView: UIImageView = {
    let view = UIImageView().forAutolayout()
    view.contentMode = .scaleAspectFit
    view.image =  UIImage(named: "profile_item_1")
    return view
  }()

  private lazy var titleLabel: UILabel = {
    let view = UILabel().forAutolayout()
    view.text = "abc"
    return view
  }()

  private lazy var actionButton: UIButton = {
    let button = UIButton().forAutolayout()
    button.imageView?.contentMode = .scaleAspectFit
    button.setImage(UIImage(named: "profile_item_arrow"), for: .normal)
    return button
  }()

  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    setupViews()
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)

    // Configure the view for the selected state
  }

  private func setupViews() {
    addSubview(iconImageView)
    addSubview(titleLabel)
    addSubview(actionButton)

    NSLayoutConstraint.activate([
      iconImageView.leftAnchor.constraint(equalTo: leftAnchor, constant: Constants.defaultMargin),
      iconImageView.topAnchor.constraint(equalTo: topAnchor, constant: Constants.defaultMargin),
      iconImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: Constants.defaultMargin),
      iconImageView.widthAnchor.constraint(equalTo: iconImageView.heightAnchor),

      titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
      titleLabel.leftAnchor.constraint(equalTo: iconImageView.rightAnchor, constant: 10),

      actionButton.rightAnchor.constraint(equalTo: rightAnchor),
      actionButton.centerYAnchor.constraint(equalTo: centerYAnchor),
      actionButton.heightAnchor.constraint(equalToConstant: 30)
      ])
  }

  func updateContent(data: ProfileItemModel) {
    iconImageView.image = UIImage(named: data.icon)
    titleLabel.text = data.title
  }
}


