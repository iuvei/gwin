//
//  RegisterViewController.swift
//  Gwin
//
//  Created by Hai Vu Van on 8/20/19.
//  Copyright © 2019 Hai Vu Van. All rights reserved.
//

import UIKit

protocol RegisterViewInput: AnyObject {
  func startCallAPI()
  func endCallAPI()
  func apiError(message: String)
  func didValidatePhoneNo(code: String)
}

protocol RegisterViewOutput: AnyObject {
  func  register(accountNo: String, password: String, code: String, cellphone: String, prefix: String)
  func  validateCellphoneNo(phoneNo: String)
}

protocol RegisterViewControllerInput: AnyObject {

}

class RegisterViewController: BaseViewController {
  private enum Constant {
    static let PhonnumberLimit: Int = 11
    static let UserMInlenght: Int = 5
    static let UserMaxLenght: Int = 20
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

  weak var output: RegisterViewOutput?

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

    if count < Constant.UserMInlenght || count >  Constant.UserMaxLenght {
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

    output?.validateCellphoneNo(phoneNo: phoneno)
   
  }

  @IBAction func registerPressed(_ sender: Any) {

    let accountNo = validateAccountNo()
    let password =  validatePassword()
    let code =  validateRefCode()
    let cellphone =  validatePhonenumber()
    guard let `prefix` = prefix else { return }

    if let `accountNo` = accountNo, let `password` = password, let `code` = code, let `cellphone` = cellphone {
      output?.register(accountNo: accountNo, password: password, code: code, cellphone: cellphone, prefix: prefix)
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
    } else if textfield == linkCodeTextfield {
      let _ = validateRefCode()
    } else if textfield == userTextfield {
      let _ = validateAccountNo()
    } else if textfield == confirmTextfield {
      let _ = validateCode()
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
      if count < Constant.UserMInlenght || count > Constant.UserMaxLenght {
        textField.showErrorIcon()
      }else {
        textField.showCorrectIcon()
      }
    }

    if  count == 0 {
      textField.showErrorIcon()
    }
  }

  func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    if textField == phoneNumberTextfield {
      guard let textFieldText = textField.text,
        let rangeOfTextToReplace = Range(range, in: textFieldText) else {
          return false
      }

      let substringToReplace = textFieldText[rangeOfTextToReplace]
      let count = textFieldText.count - substringToReplace.count + string.count

      return count <= Constant.PhonnumberLimit
    }
    return true
  }
}


extension RegisterViewController: RegisterViewInput {
  func startCallAPI() {
    showLoadingView()
  }

  func endCallAPI() {
    hideLoadingView()
  }

  func apiError(message: String) {
    showAlertMessage(message: message)
  }

  func didValidatePhoneNo(code: String) {
    confirmTextfield.text = code
    let _ = validateCode()
  }
}

extension RegisterViewController: RegisterViewControllerInput {
  
}
