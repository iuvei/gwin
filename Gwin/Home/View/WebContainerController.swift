//
//  WebContainerController.swift
//  Gwin
//
//  Created by Hai Vu Van on 8/21/19.
//  Copyright © 2019 Hai Vu Van. All rights reserved.
//

import UIKit
import WebKit

class WebContainerController: BaseViewController {

  private lazy var webView: WKWebView = {
    let web = WKWebView()
    web.translatesAutoresizingMaskIntoConstraints = false
    web.navigationDelegate = self
    return web
  }()

  private lazy var headerView: UIView = {
    let view = UIView()
    view.translatesAutoresizingMaskIntoConstraints = false
    view.backgroundColor = .red
    return view
  }()

  private lazy var backButton: UIButton = {
    let button = UIButton()
    button.translatesAutoresizingMaskIntoConstraints = false
    button.backgroundColor = .blue
    button.addTarget(self, action: #selector(backButtonPressed(_:)), for: .touchUpInside)
    return button
  }()

  private var urlPath: String
  init(url: String) {
    self.urlPath = url
    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .white
    setupHeaderView()
    setupWebview()
    showLoadingView()
  }

  func setupHeaderView() {
    view.addSubview(headerView)
    if #available(iOS 11, *) {
      let guide = view.safeAreaLayoutGuide
      NSLayoutConstraint.activate([
        headerView.topAnchor.constraint(equalTo: guide.topAnchor),
        headerView.leftAnchor.constraint(equalTo: guide.leftAnchor),
        headerView.rightAnchor.constraint(equalTo: guide.rightAnchor),
        headerView.heightAnchor.constraint(equalToConstant: 44),
        ])

    } else {
      NSLayoutConstraint.activate([
        headerView.topAnchor.constraint(equalTo: view.topAnchor),
        headerView.leftAnchor.constraint(equalTo: view.leftAnchor),
        headerView.rightAnchor.constraint(equalTo: view.rightAnchor),
        headerView.heightAnchor.constraint(equalToConstant: 44),
        ])
    }
  }

  func setupWebview() {
    view.addSubview(webView)

    headerView.addSubview(backButton)

    NSLayoutConstraint.activate([


      webView.topAnchor.constraint(equalTo: headerView.bottomAnchor),
      webView.leftAnchor.constraint(equalTo: view.leftAnchor),
      webView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
      webView.rightAnchor.constraint(equalTo: view.rightAnchor),

      backButton.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
      backButton.leftAnchor.constraint(equalTo: headerView.leftAnchor, constant: 10),
      backButton.heightAnchor.constraint(equalToConstant: 30)
      ])
    // Do any additional setup after loading the view.
    if let url = URL(string: urlPath) {
      webView.load(URLRequest(url: url))
    }
  }
  /*
   // MARK: - Navigation

   // In a storyboard-based application, you will often want to do a little preparation before navigation
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
   // Get the new view controller using segue.destination.
   // Pass the selected object to the new view controller.
   }
   */

  @objc func backButtonPressed(_ sender: UIButton) {
    dismiss(animated: true, completion: nil)
  }
}

extension WebContainerController: WKNavigationDelegate {

  func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
    hideLoadingView()
  }
}

