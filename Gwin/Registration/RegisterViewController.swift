//
//  RegisterViewController.swift
//  Gwin
//
//  Created by Hai Vu Van on 8/20/19.
//  Copyright © 2019 Hai Vu Van. All rights reserved.
//

import UIKit

class RegisterViewController: BaseViewController {
  enum Constant {
    static let PhonnumberLimit: Int = 11
    static let UserNoLimit: Int = 6
    static let PasswordLimit: Int = 6
  }

  @IBOutlet weak var userImageView: UIButton!

  @IBOutlet weak var prefixLabel: UILabel!
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

  private var prefix: String?

  override func viewDidLoad() {
    super.viewDidLoad()
    setTitle(title: "注册")
    setBackTitle(title:"红包炸雷")
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
    phoneNumberTextfield.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
    linkCodeTextfield.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
    userTextfield.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)

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
    let count = userTextfield.text?.count ?? 0

    if count < Constant.UserNoLimit {
      userTextfield.showErrorIcon()
    } else {
      userTextfield.showCorrectIcon()
    }

    return userTextfield.text
  }

  private func validatePassword() -> String? {

    let password = passwordTextfield.text
    let confirm = passwordConfirmTextfield.text

    let passwordcount1 = password?.count ?? 0
    let confirmcount = confirm?.count ?? 0

    if passwordcount1 < Constant.PasswordLimit {
      passwordTextfield.showErrorIcon()
    }else {
      passwordTextfield.showCorrectIcon()
    }

    if confirmcount < Constant.PasswordLimit {
      passwordConfirmTextfield.showErrorIcon()
    }else {
      passwordConfirmTextfield.showCorrectIcon()
    }

    if password == confirm && passwordcount1 >= 6 && confirmcount >= 6{
      passwordTextfield.showCorrectIcon()
      passwordConfirmTextfield.showCorrectIcon()
      return password
    }else {
      passwordConfirmTextfield.showErrorIcon()
    }

    return nil
  }

  private func validateCode() -> String? {
    let count = confirmTextfield.text?.count ?? 0

    if count == 0 {
      confirmTextfield.showErrorIcon()
    } else {
      confirmTextfield.showCorrectIcon()
    }

    return confirmTextfield.text
  }

  private func validatePhonenumber() -> String? {
    let count = phoneNumberTextfield.text?.count ?? 0

    if count != Constant.PhonnumberLimit {
      phoneNumberTextfield.showErrorIcon()
    }else {
      phoneNumberTextfield.showCorrectIcon()
    }

    return phoneNumberTextfield.text
  }

  private func validateRefCode() -> String? {

    if let _ = prefix {
    linkCodeTextfield.showCorrectIcon()
    } else {
      linkCodeTextfield.showErrorIcon()
    }

    return linkCodeTextfield.text
  }

  @objc func tappedView(_ sende: UIGestureRecognizer) {
    view.endEditing(true)
  }

  @IBAction func phoneNumberPressed(_ sender: Any) {

    guard let phoneno = validatePhonenumber() else { return }

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
    let code =  validateRefCode()
    let cellphone =  validatePhonenumber()
    guard let `prefix` = prefix else { return }
    showLoadingView()
    if let `accountNo` = accountNo, let `password` = password, let `code` = code, let `cellphone` = cellphone {
      UserAPIClient.register(accountNo: "\(prefix)\(accountNo)", password: password, code: code, cellphone: cellphone) { [weak self] (user, message) in
        guard let this = self else { return }
        this.hideLoadingView()

        if let `user` = user, let appDelegate: AppDelegate = UIApplication.shared.delegate as? AppDelegate {
          UserDefaultManager.sharedInstance().removeLoginInfo()
          RedEnvelopComponent.shared.user = user
          RedEnvelopComponent.shared.userno = "\(prefix)\(accountNo)"
          appDelegate.setHomeAsRootViewControlelr()
        } else {
          if let msg = message {
            this.showAlertMessage(message: msg)
          }
        }
      }
    }
  }

  func checkReferenceCode() {
    if let code = linkCodeTextfield.text, code.count > 0 {
      UserAPIClient.accountPrefix(prefix: code) { [weak self](prefix, error) in
        self?.prefixLabel.text = prefix
        self?.prefix = prefix

        if let _ = prefix {
          self?.linkCodeTextfield.showCorrectIcon()
        }else {
          self?.linkCodeTextfield.showErrorIcon()
        }
      }
    } else {
      linkCodeTextfield.showErrorIcon()
    }
  }

  @objc func textFieldDidChange(_ textfield: UITextField) {

    if textfield == phoneNumberTextfield {
      let _ = validatePhonenumber()
    }

    if textfield == linkCodeTextfield {
      let _ = validateRefCode()
    }

    if textfield == userTextfield {
      let _ = validateAccountNo()
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
      if count < Constant.PhonnumberLimit {
        textField.showErrorIcon()
      }else {
        textField.showCorrectIcon()
      }
    } else if textField == userTextfield {
      if count < Constant.UserNoLimit {
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
