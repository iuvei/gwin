//
//  LotteryViewController.swift
//  Gwin
//
//  Created by Hai Vu Van on 8/28/19.
//  Copyright © 2019 Hai Vu Van. All rights reserved.
//

import UIKit
import WebKit

class LotteryViewController: BaseViewController {

  private lazy var webView: WKWebView = {
    let webview = WKWebView().forAutolayout()

    return webview
  }()


  override func viewDidLoad() {
    super.viewDidLoad()
    setTitle(title: "快乐彩票")
    // Do any additional setup after loading the view.
    setupViews()
    fetchLoteryURL()
  }

  func setupViews(){
    view.addSubview(webView)
    if #available(iOS 11, *) {
      let guide = view.safeAreaLayoutGuide
      NSLayoutConstraint.activate([
        webView.topAnchor.constraint(equalTo: guide.topAnchor),
        webView.leftAnchor.constraint(equalTo: guide.leftAnchor),
        webView.rightAnchor.constraint(equalTo: guide.rightAnchor),
        webView.bottomAnchor.constraint(equalTo: guide.bottomAnchor),
        ])

    } else {
      NSLayoutConstraint.activate([
        webView.topAnchor.constraint(equalTo: view.topAnchor),
        webView.leftAnchor.constraint(equalTo: view.leftAnchor),
        webView.rightAnchor.constraint(equalTo: view.rightAnchor),
        webView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
  }

  func fetchLoteryURL() {
    guard let user = RedEnvelopComponent.shared.user else { return }
    showLoadingView()
    RedEnvelopAPIClient.lottery(ticket: user.ticket, gameno: "6") {[weak self] (gameurl, def) in
      self?.hideLoadingView()
      if let path = gameurl {
        if let url = URL(string: path) {
          self?.webView.load(URLRequest(url: url))
        }
      }
    }
  }

  override func backPressed(_ sender: UIButton) {
    if let delegate = UIApplication.shared.delegate as? AppDelegate {
      delegate.tabbarController?.backToLastView()
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



