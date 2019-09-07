//
//  LobbyItemView.swift
//  Gwin
//
//  Created by Hai Vu Van on 8/21/19.
//  Copyright © 2019 Hai Vu Van. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON

class LobbyItemModel {
  var icon: String
  var name: String
  var key: String
  var action: String

  init(dictionary: JSON) {
    icon = dictionary["icon"].stringValue
    name = dictionary["name"].stringValue
    key = dictionary["key"].stringValue
    action = dictionary["action"].stringValue

  }
}

protocol LobbyItemViewOuput: AnyObject {
  func pressedLobbyItem(model: LobbyItemModel)
}

class LobbyItemView: UIView {

  private lazy var stackView: UIStackView = {
    let view = UIStackView().forAutolayout()
    view.axis = self.axis
    view.distribution = .fill
    return view
  }()

  private lazy var textStackView: UIView = {
    let view = UIView().forAutolayout()
    return view
  }()

  private lazy var coverButton: UIButton = {
    let view = UIButton().forAutolayout()
    view.isUserInteractionEnabled = true
    view.addTarget(self, action: #selector(lobbyItemPressed(_:)), for: .touchUpInside)
    return view
  }()

  private var imageView: UIImageView = {
    let view = UIImageView().forAutolayout()
    view.contentMode = .scaleAspectFit
    return view
  }()

  private var titleLabel: UILabel = {
    let view = UILabel().forAutolayout()
    view.textAlignment = .center
    view.numberOfLines = 0
    view.font = UIFont.systemFont(ofSize: UIDevice.current.screenType == .iPhones_5_5s_5c_SE ? 12 : 14)
    return view
  }()

  private var subtitleLAbel: UILabel = {
    let label = UILabel().forAutolayout()
    label.textColor = .gray
    label.font = UIFont.systemFont(ofSize: UIDevice.current.screenType == .iPhones_5_5s_5c_SE ? 12 : 14)
    return label
  }()

  private let model: LobbyItemModel!
  private var output: LobbyItemViewOuput
  private var axis: NSLayoutConstraint.Axis
  private var row: Int
  init(model: LobbyItemModel, axis: NSLayoutConstraint.Axis = .vertical, row: Int = 1, output: LobbyItemViewOuput) {
    self.model = model
    self.output = output
    self.axis = axis
    self.row = row
    super.init(frame: .zero)
    setupViews()
    updateView()
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  func setupViews() {
    addSubview(stackView)
    addSubview(coverButton)
    let itemHeight = UIScreen.main.bounds.width / 4

    NSLayoutConstraint.activate([
      stackView.topAnchor.constraint(equalTo: topAnchor),
      stackView.leftAnchor.constraint(equalTo: leftAnchor),
      stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
      stackView.rightAnchor.constraint(equalTo: rightAnchor),

      coverButton.topAnchor.constraint(equalTo: topAnchor),
      coverButton.leftAnchor.constraint(equalTo: leftAnchor),
      coverButton.bottomAnchor.constraint(equalTo: bottomAnchor),
      coverButton.rightAnchor.constraint(equalTo: rightAnchor),
      ])

    stackView.addArrangedSubview(imageView)
    if axis == .vertical {
      stackView.addArrangedSubview(titleLabel)
      NSLayoutConstraint.activate([
        imageView.topAnchor.constraint(equalTo: stackView.topAnchor),
        imageView.leftAnchor.constraint(equalTo: stackView.leftAnchor),
        imageView.rightAnchor.constraint(equalTo: stackView.rightAnchor),
        imageView.heightAnchor.constraint(equalToConstant: itemHeight - 20 ),

        titleLabel.leftAnchor.constraint(equalTo: stackView.leftAnchor),
        titleLabel.bottomAnchor.constraint(equalTo: stackView.bottomAnchor),
        titleLabel.rightAnchor.constraint(equalTo: stackView.rightAnchor),

        imageView.bottomAnchor.constraint(equalTo: titleLabel.topAnchor)
        ])
    } else if axis == .horizontal {
      stackView.addArrangedSubview(textStackView)
      textStackView.addSubview(titleLabel)
      textStackView.addSubview(subtitleLAbel)

      NSLayoutConstraint.activate([
        imageView.topAnchor.constraint(equalTo: stackView.topAnchor),
        imageView.leftAnchor.constraint(equalTo: stackView.leftAnchor),
        imageView.bottomAnchor.constraint(equalTo: stackView.bottomAnchor),
        imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor),
        imageView.heightAnchor.constraint(equalToConstant: itemHeight - 20),

        textStackView.leftAnchor.constraint(equalTo: imageView.rightAnchor),
        textStackView.rightAnchor.constraint(equalTo: stackView.rightAnchor),
        textStackView.centerYAnchor.constraint(equalTo: stackView.centerYAnchor),
        
        titleLabel.centerYAnchor.constraint(equalTo: textStackView.centerYAnchor, constant: -12),
        titleLabel.leftAnchor.constraint(equalTo: textStackView.leftAnchor),

        subtitleLAbel.heightAnchor.constraint(equalToConstant: 25),
        subtitleLAbel.centerYAnchor.constraint(equalTo: textStackView.centerYAnchor, constant: 12),
        subtitleLAbel.leftAnchor.constraint(equalTo: textStackView.leftAnchor),

        ])
    }
  }

  func updateView() {
    imageView.image = UIImage(named: model.icon)
    titleLabel.text = model.name
    if axis == .horizontal {
      subtitleLAbel.text = "开放中"
    }
  }

  @objc func lobbyItemPressed(_ sender: UIButton) {
    output.pressedLobbyItem(model: model)
  }
}

