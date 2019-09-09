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

  private lazy var profileButton: UIButton = {
    let button = UIButton(frame: CGRect(x: 0,y: 0,width: 35,height: 35))
    button.imageEdgeInsets  = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
    button.imageView?.contentMode = .scaleAspectFit
    button.setImage(UIImage(named: "boom_header_profile"), for: .normal)
    button.addTarget(self, action: #selector(profilePressed(_:)), for: .touchUpInside)
    return button
  }()
  
  private var loadingView: UIViewController?
  public var processing: Bool = false

  override func viewDidLoad() {
    super.viewDidLoad()
    self.edgesForExtendedLayout = []

    backButton.frame = CGRect(x: 0, y: 0, width: Constants.actionButtonSize, height: Constants.actionButtonSize)
    let leftItem = UIBarButtonItem(customView: backButton)
    self.navigationItem.leftBarButtonItem = leftItem

    // Do any additional setup after loading the view.
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    SoundManager.shared.playBipSound()
    processing = false
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
      backButton.frame = CGRect(x: 0, y: 0, width: Constants.actionButtonTextWidth, height: Constants.actionButtonSize)
    }
    
    backButton.setTitle(title, for: .normal)
    let leftItem = UIBarButtonItem(customView: backButton)
    self.navigationItem.leftBarButtonItem = leftItem
  }

  func hideBackButton() {
    self.navigationItem.leftBarButtonItems = []
    self.navigationItem.setHidesBackButton(true, animated:true);
  }

  func addProfileButton(){
    profileButton.frame = CGRect(x: 0, y: 0, width: 35, height: 56)

    let rightItem1 = UIBarButtonItem(customView: profileButton)
    self.navigationItem.rightBarButtonItems = [rightItem1]
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

  func selectProfileTab() {
    if let delegate = UIApplication.shared.delegate as? AppDelegate {
      delegate.selectTabIndex(index: TabIndex.profile)
    }
  }

  @objc func backPressed(_ sender: UIButton) {
    self.navigationController?.popViewController(animated: true)
  }
  
  @objc func profilePressed(_ sender: UIButton) {
    if let delegate = UIApplication.shared.delegate as? AppDelegate {
      delegate.selectTabIndex(index: TabIndex.profile)
    }
  }

  func showAlertMessage(title: String? = nil, message: String) {
    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)

    let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
    alert.addAction(okAction)
    presentAlert(alert, animated: true, completion: nil)
  }

  func presentAlert(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)? = nil) {
    let transition = CATransition()
    transition.duration = 0.3
    transition.type = CATransitionType.fade
    transition.subtype = CATransitionSubtype.fromBottom
    transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
    view.window!.layer.add(transition, forKey: kCATransition)
    super.present(viewControllerToPresent, animated: false, completion: nil)
  }

  override func present(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)? = nil) {
    let transition = CATransition()
    transition.duration = 0.3
    transition.type = CATransitionType.push
    transition.subtype = CATransitionSubtype.fromRight
    transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
    view.window!.layer.add(transition, forKey: kCATransition)


    super.present(viewControllerToPresent, animated: false, completion: nil)
  }
}

