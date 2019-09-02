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
    static let actionButtonSize: CGFloat = 35
    static let actionButtonTextWidth: CGFloat = 70

  }

  private lazy var backButton: UIButton = {
    let button = UIButton()
    button.setImage(UIImage(named: "back_button"), for: .normal)
    button.addTarget(self, action: #selector(backPressed(_:)), for: .touchUpInside)
    button.backgroundColor = .clear
    button.semanticContentAttribute = .forceLeftToRight
    button.contentEdgeInsets = UIEdgeInsets(top: 5, left: -10, bottom: 5, right: 10)
    button.titleEdgeInsets = UIEdgeInsets(top: 0, left: -10, bottom: 0, right: 0)
    button.setTitleColor(UIColor(hexString: "FBEAAC"), for: .normal)
    button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
    button.imageView?.contentMode = .scaleAspectFit
    return button
  }()

  private var loadingView: UIViewController?

  override func viewDidLoad() {
    super.viewDidLoad()
    self.edgesForExtendedLayout = []


    let leftItem = UIBarButtonItem(customView: backButton)
    self.navigationItem.leftBarButtonItem = leftItem

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

  func addBackButton(title: String? = nil) {
    if title == nil{
      backButton.frame = CGRect(x: 0, y: 0, width: Constants.actionButtonSize, height: Constants.actionButtonSize)
    }else {
      backButton.frame = CGRect(x: 0, y: 0, width: Constants.actionButtonSize, height: Constants.actionButtonTextWidth)
    }
    backButton.setTitle(title, for: .normal)
    let leftItem = UIBarButtonItem(customView: backButton)
    self.navigationItem.leftBarButtonItem = leftItem
  }

  func hideBackButton() {
    self.navigationItem.leftBarButtonItems = []
    self.navigationItem.setHidesBackButton(true, animated:true);
  }

  func setBackTitle(title: String) {
    backButton.setTitle(title, for: .normal)
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

  @objc func backPressed(_ sender: UIButton) {
    self.navigationController?.popViewController(animated: true)
  }

  func showAlertMessage(title: String? = nil, message: String) {
    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)

    let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
    alert.addAction(okAction)
    present(alert, animated: true, completion: nil)
  }
}

