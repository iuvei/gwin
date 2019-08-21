//
//  WebContainerController.swift
//  Gwin
//
//  Created by Hai Vu Van on 8/21/19.
//  Copyright © 2019 Hai Vu Van. All rights reserved.
//

import UIKit
import WebKit

class WebContainerController: UIViewController {

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
    view.addSubview(headerView)
    view.addSubview(webView)

    NSLayoutConstraint.activate([
      headerView.topAnchor.constraint(equalTo: view.topAnchor),
      headerView.leftAnchor.constraint(equalTo: view.leftAnchor),
      headerView.rightAnchor.constraint(equalTo: view.rightAnchor),
      headerView.heightAnchor.constraint(equalToConstant: 44),

      webView.topAnchor.constraint(equalTo: headerView.bottomAnchor),
      webView.leftAnchor.constraint(equalTo: view.leftAnchor),
      webView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
      webView.rightAnchor.constraint(equalTo: view.rightAnchor),

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

}

extension WebContainerController: WKNavigationDelegate {

}

