//
//  ScrollLabel.swift
//  Gwin
//
//  Created by Hai Vu Van on 8/26/19.
//  Copyright © 2019 Hai Vu Van. All rights reserved.
//

import UIKit

class ScrollLabel: UIView {

  private lazy var webview: UIWebView = {
    let webview = UIWebView().forAutolayout()
    webview.backgroundColor = .blue
    return webview
  }()

  init() {
    super.init(frame: .zero)
    setupViews()
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  func setupViews() {
    addSubview(webview)

    NSLayoutConstraint.activate([
    webview.topAnchor.constraint(equalTo: topAnchor),
    webview.leftAnchor.constraint(equalTo: leftAnchor),
    webview.bottomAnchor.constraint(equalTo: bottomAnchor),
    webview.rightAnchor.constraint(equalTo: rightAnchor),

      ])
  }

  func updateContent(message: String?) {
    let marquee = "<html><body><marquee>\(message ?? "")</marquee></body></html>"
    webview.loadHTMLString(marquee, baseURL: nil)
  }
}
