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

  init(dictionary: JSON) {
    icon = dictionary["icon"].stringValue
    name = dictionary["name"].stringValue
    key = dictionary["key"].stringValue

  }
}

protocol LobbyItemViewOuput: AnyObject {
  func pressedLobbyItem(model: LobbyItemModel)
}

class LobbyItemView: UIView {

  private lazy var stackView: UIStackView = {
    let view = UIStackView()
    view.translatesAutoresizingMaskIntoConstraints = false
    view.axis = self.axis
    view.distribution = .fill
    return view
  }()

  private lazy var coverButton: UIButton = {
    let view = UIButton()
    view.translatesAutoresizingMaskIntoConstraints = false
    view.isUserInteractionEnabled = true
    view.addTarget(self, action: #selector(lobbyItemPressed(_:)), for: .touchUpInside)
    return view
  }()

  private var imageView: UIImageView = {
    let view = UIImageView()
    view.translatesAutoresizingMaskIntoConstraints = false
    view.contentMode = .scaleAspectFit
    return view
  }()

  private var titleLabel: UILabel = {
    let view = UILabel()
    view.translatesAutoresizingMaskIntoConstraints = false
    view.textAlignment = .center
    return view
  }()

  private let model: LobbyItemModel!
  private var output: LobbyItemViewOuput
  private var axis: NSLayoutConstraint.Axis
  init(model: LobbyItemModel, axis: NSLayoutConstraint.Axis = .vertical, output: LobbyItemViewOuput) {
    self.model = model
    self.output = output
    self.axis = axis
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
    stackView.addArrangedSubview(titleLabel)
    if axis == .vertical {
      NSLayoutConstraint.activate([
        imageView.topAnchor.constraint(equalTo: stackView.topAnchor),
        imageView.leftAnchor.constraint(equalTo: stackView.leftAnchor),
        imageView.rightAnchor.constraint(equalTo: stackView.rightAnchor),

        titleLabel.leftAnchor.constraint(equalTo: stackView.leftAnchor),
        titleLabel.bottomAnchor.constraint(equalTo: stackView.bottomAnchor),
        titleLabel.rightAnchor.constraint(equalTo: stackView.rightAnchor),
        titleLabel.heightAnchor.constraint(equalToConstant: 25),

        imageView.bottomAnchor.constraint(equalTo: titleLabel.topAnchor)
        ])
    } else if axis == .horizontal {
      NSLayoutConstraint.activate([
        imageView.topAnchor.constraint(equalTo: stackView.topAnchor),
        imageView.leftAnchor.constraint(equalTo: stackView.leftAnchor),
        imageView.bottomAnchor.constraint(equalTo: stackView.bottomAnchor),
        imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor),

        titleLabel.leftAnchor.constraint(equalTo: imageView.rightAnchor),
        titleLabel.rightAnchor.constraint(equalTo: stackView.rightAnchor),
        titleLabel.centerYAnchor.constraint(equalTo: stackView.centerYAnchor)
        ])
    }
  }

  func updateView() {
    imageView.image = UIImage(named: model.icon)
    titleLabel.text = model.name
  }

  @objc func lobbyItemPressed(_ sender: UIButton) {
    output.pressedLobbyItem(model: model)
  }
}

