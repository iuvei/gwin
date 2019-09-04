//
//  TitleStackView.swift
//  Gwin
//
//  Created by Hai Vu Van on 8/25/19.
//  Copyright © 2019 Hai Vu Van. All rights reserved.
//

import Foundation
import UIKit

class TitleStackView: UIView {
  private lazy var prefixLabel: UILabel = {
    let label = UILabel().forAutolayout()
    label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
    return label
  }()

  private lazy var titleLabel: UILabel = {
    let label = UILabel().forAutolayout()
    label.font = UIFont.systemFont(ofSize: 15)
    label.textColor = .gray
    label.textAlignment = .left
    return label
  }()

  private lazy var stackView: UIStackView = {
    let stack = UIStackView().forAutolayout()
    stack.axis = .horizontal
    stack.distribution = .fill
    return stack
  }()

  private var prefix: String
  private var title: String

  init(prefix: String, title: String) {
    self.prefix = prefix
    self.title = title
    super.init(frame: .zero)
    setupViews()
    prefixLabel.text = prefix
    titleLabel.text = title
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  func setupViews() {
    addSubview(stackView)
    stackView.boundInside(view: self)
    stackView.addArrangedSubview(prefixLabel)
    stackView.addArrangedSubview(titleLabel)

    NSLayoutConstraint.activate([
      prefixLabel.leftAnchor.constraint(equalTo: stackView.leftAnchor),
      prefixLabel.topAnchor.constraint(equalTo: stackView.topAnchor),
      prefixLabel.bottomAnchor.constraint(equalTo: stackView.bottomAnchor),
      prefixLabel.widthAnchor.constraint(equalToConstant: 70),

      titleLabel.leftAnchor.constraint(equalTo: prefixLabel.rightAnchor, constant: 5),
      titleLabel.topAnchor.constraint(equalTo: stackView.topAnchor),
      titleLabel.bottomAnchor.constraint(equalTo: stackView.bottomAnchor),
    ])
  }
}
