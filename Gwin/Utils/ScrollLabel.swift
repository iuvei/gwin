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
    webview.backgroundColor = .white
    webview.scrollView.isScrollEnabled = false
    webview.scrollView.bounces = false
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
      webview.heightAnchor.constraint(equalToConstant: 25),
      webview.leftAnchor.constraint(equalTo: leftAnchor),
      webview.centerYAnchor.constraint(equalTo: centerYAnchor , constant: -3),
      webview.rightAnchor.constraint(equalTo: rightAnchor),

      ])
  }

  func updateContent(message: String?) {
    let marquee = "<html><body><font size=\"2\" face=\"sans-serif\"> <marquee>\(message ?? "")</marquee>>/font></body></html>"
    webview.loadHTMLString(marquee, baseURL: nil)
  }
}

