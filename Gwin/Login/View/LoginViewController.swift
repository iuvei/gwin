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

class LoginViewController: UIViewController {

  weak var output: LoginViewOutput?

  @IBOutlet weak var accountNoTextfield: UITextField!
  @IBOutlet weak var passwordTextfield: UITextField!
  @IBOutlet weak var rememberButton: UIButton!
  @IBOutlet weak var loginButton: UIButton!

  override func viewDidLoad() {
    super.viewDidLoad()

    // Do any additional setup after loading the view.
    setupViews()
  }

  func setupViews() {
    accountNoTextfield.rounded()
    passwordTextfield.rounded()
    loginButton.rounded()


    accountNoTextfield.setLeftIcon(imageName: "login_phone")
    passwordTextfield.setLeftIcon(imageName: "login_password")

  }

  /*
   // MARK: - Navigation

   // In a storyboard-based application, you will often want to do a little preparation before navigation
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
   // Get the new view controller using segue.destination.
   // Pass the selected object to the new view controller.
   }
   */

  @IBAction func loginPressed(_ sender: Any) {
    guard let accountNo = accountNoTextfield.text, let password = accountNoTextfield.text else { return }

    UserAPIClient.login(accountNo: accountNo, password: password) { (user, message) in
      if let `user` = user {
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

