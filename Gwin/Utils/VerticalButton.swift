//
//  VerticalButton.swift
//  Gwin
//
//  Created by Hai Vu Van on 11/23/19.
//  Copyright © 2019 Hai Vu Van. All rights reserved.
//

import Foundation
import UIKit

class VerticalButton: UIView {

  private lazy var stackView: UIStackView = {
    let stackView = UIStackView().forAutolayout()
    stackView.axis = .vertical
    stackView.distribution = .fill

    return stackView
  }()

  public lazy var buttonView: UIButton = {
    let button = UIButton().forAutolayout()
    button.addTarget(self, action: #selector(buttonPressed(_:)), for: .touchUpInside)
    return button
  }()

  private lazy  var imageView: UIImageView = {
    let imageView =  UIImageView().forAutolayout()
    imageView.contentMode = .scaleAspectFit

    return imageView
  }()

  private lazy var titleLabel: UILabel = {
    let label  = UILabel().forAutolayout()
    label.textAlignment = .center
    label.textColor = .white
    label.font = UIFont.systemFont(ofSize: 9)

    return label
  }()

  var completionHandler: ()-> Void = {}

  var text: String
  var image: UIImage?
  var color: UIColor
  init(with text: String, image: UIImage?, color: UIColor =  AppColors.titleColor) {
    self.text = text
    self.image = image
    self.color = color
    super.init(frame: .zero)
    setupViews()
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  func setupViews() {
    addSubview(stackView)
    addSubview(buttonView)
    stackView.addArrangedSubview(imageView)
    stackView.addArrangedSubview(titleLabel)

    NSLayoutConstraint.activate([
      stackView.topAnchor.constraint(equalTo: topAnchor, constant: 2),
      stackView.leftAnchor.constraint(equalTo: leftAnchor),
      stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -4),
      stackView.rightAnchor.constraint(equalTo: rightAnchor),

      buttonView.topAnchor.constraint(equalTo: topAnchor),
      buttonView.leftAnchor.constraint(equalTo: leftAnchor),
      buttonView.bottomAnchor.constraint(equalTo: bottomAnchor),
      buttonView.rightAnchor.constraint(equalTo: rightAnchor),

      titleLabel.heightAnchor.constraint(equalToConstant: 11)
    ])


    titleLabel.text = text
    titleLabel.textColor = color
    imageView.image = image
  }

  @objc func buttonPressed(_ button: UIButton) {
    completionHandler()
  }
}
