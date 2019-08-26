//
//  LoginViewController.swift
//  Gwin
//
//  Created by Hai Vu Van on 8/20/19.
//  Copyright © 2019 Hai Vu Van. All rights reserved.
//

import UIKit

protocol LoginViewInput: AnyObject {
}

protocol LoginViewOutput: AnyObject {
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
    setTitle(title:"登录")
    // Do any additional setup after loading the view.
    setupViews()
    updateData()
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
  }

  func setupViews() {
    accountNoTextfield.rounded()
    passwordTextfield.rounded()
    loginButton.rounded()


    accountNoTextfield.setLeftIcon(imageName: "login_phone")
    passwordTextfield.setLeftIcon(imageName: "login_password")

  }

  func updateData() {
    accountNoTextfield.text = UserDefaultManager.sharedInstance().loginInfoUserName()
    passwordTextfield.text = UserDefaultManager.sharedInstance().loginInfoPassword()
    loginButton.isSelected = UserDefaultManager.sharedInstance().isRememberLoginInfo()
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
    rememberButton.isSelected = !rememberButton.isSelected
    UserDefaultManager.sharedInstance().rememberLoginInfo(rememberButton.isSelected)
  }

  @IBAction func loginPressed(_ sender: Any) {
    guard let accountNo = accountNoTextfield.text, let password = passwordTextfield.text else { return }

    UserDefaultManager.sharedInstance().saveLoginInfo(accountNo: accountNo, password: password)

    showLoadingView()
    UserAPIClient.login(accountNo: accountNo, password: password) {[weak self] (user, message) in
      guard let `this` = self else { return }
      this.hideLoadingView()
      if let `user` = user {
        RedEnvelopComponent.shared.userno = accountNo
        RedEnvelopComponent.shared.user = user
        if let appDelegate: AppDelegate = UIApplication.shared.delegate as? AppDelegate {
          appDelegate.setHomeAsRootViewControlelr()
        }
      } else {

      }
    }
  }
}

extension LoginViewController: LoginViewInput {

}

extension LoginViewController: LoginViewControllerInput {

}

