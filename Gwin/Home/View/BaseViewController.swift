//
//  BaseViewController.swift
//  Gwin
//
//  Created by Hai Vu Van on 8/23/19.
//  Copyright © 2019 Hai Vu Van. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {

  enum Constants {
    static let loadingSize: CGFloat = 100
  }

  private var loadingView: UIViewController?

  override func viewDidLoad() {
    super.viewDidLoad()

    // Do any additional setup after loading the view.
  }

  func showLoadingView(background color: UIColor = .white) {
    loadingView = UIViewController()
    guard let alert = loadingView else { return }

    let containerView = UIView().forAutolayout()
    containerView.rounded()
    containerView.addShadow(offSet: CGSize(width: 5,height: 5), radius: 5)
    containerView.backgroundColor = color

    alert.view.addSubview(containerView)
    alert.view.tintColor = UIColor.black
    let loadingIndicator: UIActivityIndicatorView = UIActivityIndicatorView(frame: .zero) as UIActivityIndicatorView
    loadingIndicator.forAutolayout()
    loadingIndicator.hidesWhenStopped = true
    loadingIndicator.style = UIActivityIndicatorView.Style.gray
    loadingIndicator.startAnimating();

    containerView.addSubview(loadingIndicator)

    NSLayoutConstraint.activate([
      containerView.centerXAnchor.constraint(equalTo: alert.view.centerXAnchor),
      containerView.centerYAnchor.constraint(equalTo: alert.view.centerYAnchor),
      containerView.widthAnchor.constraint(equalToConstant: Constants.loadingSize),
      containerView.heightAnchor.constraint(equalToConstant: Constants.loadingSize),

      loadingIndicator.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
      loadingIndicator.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
    ])

    view.addSubview(alert.view)
    alert.view.boundInside(view: view)
  }

  func hideLoadingView() {
    guard let alert = loadingView else { return }

    alert.view.removeFromSuperview()
    loadingView = nil
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

