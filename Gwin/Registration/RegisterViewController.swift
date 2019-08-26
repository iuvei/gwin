//
//  RegisterViewController.swift
//  Gwin
//
//  Created by Hai Vu Van on 8/20/19.
//  Copyright © 2019 Hai Vu Van. All rights reserved.
//

import UIKit

class RegisterViewController: BaseViewController {

  @IBOutlet weak var userImageView: UIImageView!
  @IBOutlet weak var userTextfield: UITextField!
  @IBOutlet weak var linkCodeTextfield: UITextField!
  @IBOutlet weak var phoneNumberTextfield: UITextField!
  @IBOutlet weak var confirmTextfield: UITextField!
  @IBOutlet weak var passwordTextfield: UITextField!
  @IBOutlet weak var passwordConfirmTextfield: UITextField!
  @IBOutlet weak var registerButton: UIButton!
  @IBOutlet weak var phoneNumberButton: UIButton!


  @IBOutlet weak var scrollView: UIScrollView!
  @IBOutlet weak var contentView: UIView!

  override func viewDidLoad() {
    super.viewDidLoad()
    setupViews()
  }

  func setupViews() {
    userImageView.rounded()
    userTextfield.rounded()
    linkCodeTextfield.rounded()
    phoneNumberTextfield.rounded()
    confirmTextfield.rounded()
    passwordTextfield.rounded()
    passwordConfirmTextfield.rounded()
    phoneNumberButton.rounded()
    registerButton.rounded()
    //
    userTextfield.addPaddingLeft()
    linkCodeTextfield.setLeftIcon(imageName: "register_2")
    phoneNumberTextfield.setLeftIcon(imageName: "register_3")
    confirmTextfield.setLeftIcon(imageName: "register_4")
    passwordTextfield.setLeftIcon(imageName: "register_5")
    passwordConfirmTextfield.setLeftIcon(imageName: "register_6")

    //

    userTextfield.setRightIcon()
    linkCodeTextfield.setRightIcon()
    phoneNumberTextfield.setRightIcon()
    confirmTextfield.setRightIcon()
    passwordTextfield.setRightIcon()
    passwordConfirmTextfield.setRightIcon()

    //
    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tappedView(_:)))
    tapGesture.numberOfTapsRequired = 1
    tapGesture.numberOfTouchesRequired = 1
    contentView.addGestureRecognizer(tapGesture)
  }
  /*
   // MARK: - Navigation

   // In a storyboard-based application, you will often want to do a little preparation before navigation
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
   // Get the new view controller using segue.destination.
   // Pass the selected object to the new view controller.
   }
   */

  private func validateAccountNo() -> String? {
    return userTextfield.text
  }

  private func validatePassword() -> String? {
    guard let password = passwordTextfield.text, let confirm = passwordConfirmTextfield.text else { return nil }
    if password == confirm {
      return password
    }
    
    return nil
  }

  private func validateCode() -> String? {
    return confirmTextfield.text
  }

  private func validatePhonenumber() -> String? {
    return phoneNumberTextfield.text
  }

  @objc func tappedView(_ sende: UIGestureRecognizer) {
    view.endEditing(true)
  }

  @IBAction func phoneNumberPressed(_ sender: Any) {

    guard let phoneno = phoneNumberTextfield.text else { return }

    UserAPIClient.checkCellphoneNo(cellphone: phoneno) { [weak self] (checkCode, errorMessage) in
      if let code = checkCode {
        print("code \(code)")
        self?.confirmTextfield.text = code
      }
    }
  }

  @IBAction func registerPressed(_ sender: Any) {

    let accountNo = validateAccountNo()
    let password =  validatePassword()
    let code =  validateCode()
    let cellphone =  validatePhonenumber()

    if let `accountNo` = accountNo, let `password` = password, let `code` = code, let `cellphone` = cellphone {
      UserAPIClient.register(accountNo: accountNo, password: password, code: code, cellphone: cellphone) { (user, message) in
        if let _ = user, let appDelegate: AppDelegate = UIApplication.shared.delegate as? AppDelegate {
          appDelegate.setHomeAsRootViewControlelr()
        }
      }
    }
  }

  func checkReferenceCode() {
    if let code = linkCodeTextfield.text, code.count > 0 {
      UserAPIClient.accountPrefix(prefix: code) { [weak self](success, error) in
        if success {
          self?.linkCodeTextfield.showCorrectIcon()
        }else {
          self?.linkCodeTextfield.showErrorIcon()
        }
      }
    } else {
      linkCodeTextfield.showErrorIcon()
    }
  }
}


extension RegisterViewController: UITextFieldDelegate {
  
  func textFieldDidBeginEditing(_ textField: UITextField) {
    //textField.removeValidateIcon()
  }

  func textFieldDidEndEditing(_ textField: UITextField) {
    let count = textField.text?.count ?? 0
    if textField == linkCodeTextfield {
      checkReferenceCode()
    } else if textField == passwordConfirmTextfield {
      if count < 6 {
        textField.showErrorIcon()
      } else {
        if passwordConfirmTextfield.text != passwordTextfield.text {
          passwordConfirmTextfield.showErrorIcon()
        } else {
          passwordConfirmTextfield.showCorrectIcon()
        }
      }
    } else if textField == passwordTextfield {
      if count < 6 {
        textField.showErrorIcon()
      }
    } else if textField == phoneNumberTextfield {
      if count < 10 {
        textField.showErrorIcon()
      }else {
        textField.showCorrectIcon()
      }
    } else if textField == userTextfield {
      if count < 6 {
        textField.showErrorIcon()
      }else {
        textField.showCorrectIcon()
      }
    }

    if  count == 0 {
      textField.showErrorIcon()
    }
  }
}
