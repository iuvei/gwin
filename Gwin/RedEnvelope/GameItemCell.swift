//
//  GameItemCell.swift
//  Gwin
//
//  Created by Hai Vu Van on 8/23/19.
//  Copyright © 2019 Hai Vu Van. All rights reserved.
//

import UIKit

class GameItemCell: UITableViewCell {
  enum Constants{
    static let signalSize: CGFloat = 8
    static let defaultMargin: CGFloat = 8
  }

  private lazy var roomImageView: UIImageView = {
    let imageView = UIImageView().forAutolayout()
    imageView.image = UIImage(named: "boom_room_1")
    return imageView
  }()

  private lazy var titleLabel: UILabel = {
    let label = UILabel().forAutolayout()
    return label
  }()

  private lazy var subTitleLabel: UILabel = {
    let label = UILabel().forAutolayout()
    label.textColor = UIColor.lightGray
    return label
  }()

  private lazy var signalView: UIView = {
    let view = UIView().forAutolayout()
    view.rounded(radius: Constants.signalSize / 2)
    view.backgroundColor = .red
    return view
  }()

  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    setupViews()
  }


  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
  }

  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)

    // Configure the view for the selected state
  }

  func setupViews() {
    contentView.addSubview(roomImageView)
    contentView.addSubview(titleLabel)
    contentView.addSubview(subTitleLabel)
    contentView.addSubview(signalView)

    NSLayoutConstraint.activate([
      roomImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Constants.defaultMargin),
      roomImageView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: Constants.defaultMargin),
      roomImageView.widthAnchor.constraint(equalTo: roomImageView.heightAnchor),
      roomImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),

      titleLabel.leftAnchor.constraint(equalTo: roomImageView.rightAnchor, constant: 10),
      titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
      titleLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -10),

      subTitleLabel.leftAnchor.constraint(equalTo: roomImageView.rightAnchor, constant: 10),
      subTitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
      subTitleLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -10),

      signalView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
      signalView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -10),
      signalView.widthAnchor.constraint(equalToConstant: Constants.signalSize),
      signalView.heightAnchor.constraint(equalToConstant: Constants.signalSize),

      ])
  }

  func updateView(model: RoomModel){

    titleLabel.text = model.roomName
    subTitleLabel.text = model.roomDesc
  }

}

