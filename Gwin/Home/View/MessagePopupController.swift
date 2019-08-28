//
//  MessagePopupController.swift
//  Gwin
//
//  Created by Hai Vu Van on 8/25/19.
//  Copyright © 2019 Hai Vu Van. All rights reserved.
//

import Foundation
import UIKit

class MessagePopupController: UIViewController {

  private lazy var messageContent: UIView = {
    let view = UIView().forAutolayout()
    view.backgroundColor = .white
    view.rounded(radius: 16)
    return view
  }()

  private lazy var headerView: UIView = {
    let view = UIView().forAutolayout()
    view.backgroundColor = UIColor(hexString: "e75f48")
    return view
  }()

  private lazy var closeButton: UIView = {
    let button = UIButton().forAutolayout()
    button.setImage(UIImage(named: "popup_close"), for: .normal)
    button.addTarget(self, action: #selector(closePressed(_:)), for: .touchUpInside)
    return button
  }()

  private lazy var messageLAbel: UILabel = {
    let label = UILabel().forAutolayout()
    label.numberOfLines = 0
    label.textColor = .black
    return label
  }()

  private let message: [String]

  init(message: [String]) {
    self.message = message
    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    self.view.backgroundColor = UIColor.black.withAlphaComponent(0.3)

    view.addSubview(messageContent)
    messageContent.addSubview(headerView)
    messageContent.addSubview(closeButton)
    messageContent.addSubview(messageLAbel)

    NSLayoutConstraint.activate([
      messageContent.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      messageContent.centerYAnchor.constraint(equalTo: view.centerYAnchor),
      messageContent.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9),

      headerView.topAnchor.constraint(equalTo: messageContent.topAnchor),
      headerView.leftAnchor.constraint(equalTo: messageContent.leftAnchor),
      headerView.rightAnchor.constraint(equalTo: messageContent.rightAnchor),
      headerView.heightAnchor.constraint(equalToConstant:44),

      closeButton.leftAnchor.constraint(equalTo: messageContent.leftAnchor, constant: 10),
      closeButton.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
      closeButton.widthAnchor.constraint(equalToConstant: 30),
      closeButton.heightAnchor.constraint(equalToConstant: 30),

      messageLAbel.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 30),
      messageLAbel.leftAnchor.constraint(equalTo: messageContent.leftAnchor, constant: 16),
      messageLAbel.centerXAnchor.constraint(equalTo: messageContent.centerXAnchor),
      messageContent.bottomAnchor.constraint(equalTo: messageLAbel.bottomAnchor, constant: 100),

      ])

    //
    var text: String = ""
    for index in 0 ..< message.count {
      text = "\(text) \(index + 1). \(message[index]) \n\n"
    }
    messageLAbel.text = text
  }

  @objc func closePressed(_ sender: UIButton) {
    dismiss(animated: true, completion: nil)
  }
}
