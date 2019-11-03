//
//  LoginViewController.swift
//  Gwin
//
//  Created by Hai Vu Van on 8/20/19.
//  Copyright © 2019 Hai Vu Van. All rights reserved.
//

import UIKit

protocol LoginViewInput: AnyObject {
  func startLoadingView()
  func endLoadingView()
  func loginFailedWithMessage(message: String)
  func updateRemeberButtonState(remember: Bool)
}

protocol LoginViewOutput: AnyObject {
  func viewDidLoad()
  func viewDidAppear()
  func viewDidDisAppear()
  func loginButtonPressed(accountNo: String, password: String)
  func rememberButtonPressed(is remember: Bool)
}

public protocol LoginViewControllerInput: AnyObject {
  
}

class LoginViewController: BaseViewController {

  weak var output: LoginViewOutput?

  @IBOutlet weak var accountNoTextfield: UITextField!
  @IBOutlet weak var passwordTextfield: UITextField!
  @IBOutlet weak var rememberButton: UIButton!
  @IBOutlet weak var loginButton: UIButton!

  override func viewDidLoad() {
    super.viewDidLoad()
    output?.viewDidLoad()
    setTitle(title:"登录注册")
    addBackButton(title: "红包炸雷")
    setupViews()
    updateData()
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    output?.viewDidAppear()
  }

  override func viewDidDisappear(_ animated: Bool) {
    super.viewDidDisappear(animated)
    output?.viewDidDisAppear()
  }
  
  func setupViews() {
    accountNoTextfield.rounded()
    passwordTextfield.rounded()
    loginButton.rounded()
    rememberButton.rounded(radius: 2)

    accountNoTextfield.setLeftIcon(imageName: "login_phone")
    passwordTextfield.setLeftIcon(imageName: "login_password")

  }

  func updateData() {
    accountNoTextfield.text = UserDefaultManager.sharedInstance().loginInfoUserName()
    passwordTextfield.text = UserDefaultManager.sharedInstance().loginInfoPassword()
    rememberButton.isSelected = UserDefaultManager.sharedInstance().isRememberLoginInfo()
  }
  /*
   // MARK: - Navigation

   // In a storyboard-based application, you will often want to do a little preparation before navigation
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
   // Get the new view controller using segue.destination.
   // Pass the selected object to the new view controller.
   }
   */
  @IBAction func rememberPressed(_ sender: Any) {
    output?.rememberButtonPressed(is: !rememberButton.isSelected)
  }

  @IBAction func loginPressed(_ sender: Any) {
    guard let accountNo = accountNoTextfield.text, let password = passwordTextfield.text else { return }

    output?.loginButtonPressed(accountNo: accountNo, password: password)
  }
}

extension LoginViewController: LoginViewInput {
  func startLoadingView() {
    showLoadingView()
  }

  func endLoadingView() {
    hideLoadingView()
  }

  func loginFailedWithMessage(message: String) {
    showAlertMessage(message: message)
  }

  func updateRemeberButtonState(remember: Bool) {
    rememberButton.isSelected = remember
  }
}

extension LoginViewController: LoginViewControllerInput {

}

