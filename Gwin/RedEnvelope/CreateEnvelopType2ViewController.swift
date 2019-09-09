//
//  CreateEnvelopType2ViewController.swift
//  Gwin
//
//  Created by Hai Vu Van on 8/24/19.
//  Copyright © 2019 Hai Vu Van. All rights reserved.
//

import UIKit

class CreateEnvelopType2ViewController: BaseViewController {

  enum Constans {
    static let packageTagMaxLengh: Int = 1
    static let minPackageSize: Int = 10
    static let maxPackageSize: Int = 200

  }


  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var ammountTextfield: UITextFieldPadding!
  @IBOutlet weak var sizeTextfield: UITextFieldPadding!
  @IBOutlet weak var createButton: UIButton!

  @IBOutlet weak var stakeLabel: UILabel!
  var room: RoomModel

  init(room: RoomModel) {
    self.room = room
    super.init(nibName: "CreateEnvelopType2ViewController", bundle: nil)
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.
    setTitle(title: "福利红包")
    setupViews()
  }


  func setupViews() {
    ammountTextfield.rounded()
    ammountTextfield.placeholder = "\(room.stake1)-\(room.stake2)"
    ammountTextfield.delegate = self
    ammountTextfield.addTarget(self, action: #selector(textFieldDidChange(_:)), for: UIControl.Event.editingChanged)

    sizeTextfield.rounded()
    sizeTextfield.placeholder = "\(Constans.minPackageSize)-\(Constans.maxPackageSize)"
    sizeTextfield.delegate = self

    stakeLabel.text = "\(room.stake1)-\(room.stake2)元"
    createButton.rounded()
  }
  /*
   // MARK: - Navigation

   // In a storyboard-based application, you will often want to do a little preparation before navigation
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
   // Get the new view controller using segue.destination.
   // Pass the selected object to the new view controller.
   }
   */
  @IBAction func createPressed(_ sender: Any) {

    guard let amountText = ammountTextfield.text, let amount = Int(amountText) else {
      showAlertMessage(message: "请输入雷数")
      return
    }
    
    guard let sizeText = sizeTextfield.text, let size = Int(sizeText) else {
      showAlertMessage(message: "红包个数为 10-200")
      return
    }
    guard let user = RedEnvelopComponent.shared.user else { return }

    if size < Constans.minPackageSize || size > Constans.maxPackageSize {
      //showAlertMessage(message: "红包发包范围: \(room.stake1)-\(room.stake2)元")
      //sizeTextfield.becomeFirstResponder()
      sizeTextfield.addBorder(color: UIColor.red, width: 1.0)
      return
    }

    if processing == true {
      return
    }
    
    processing = true
    RedEnvelopAPIClient.sendPackage(ticket: user.ticket, roomid: room.roomId, packageamount: amount, packagesize: size, packagetag: "") { [weak self] (success, message) in
      self?.processing = false
      if success {
        self?.navigationController?.popViewController(animated: true)
      } else {
        if let msg = message {
          self?.showAlertMessage(message: msg)

        }
      }
    }
  }


}

extension CreateEnvelopType2ViewController {
  @objc func textFieldDidChange(_ sender: UITextField) {
    titleLabel.text = "¥ \(sender.text ?? "")"
  }
}

extension CreateEnvelopType2ViewController : UITextFieldDelegate {

  func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    guard let textFieldText = textField.text,
      let rangeOfTextToReplace = Range(range, in: textFieldText) else {
        return false
    }
    let substringToReplace = textFieldText[rangeOfTextToReplace]
    let count = textFieldText.count - substringToReplace.count + string.count

    if textField == ammountTextfield {
      return count <= room.stake2.usefulDigits
    } else if textField == sizeTextfield {
      sizeTextfield.addBorder(color: .clear, width: 0)
      return count <= Constans.maxPackageSize.usefulDigits
    }

    return true
  }

  func textFieldDidEndEditing(_ textField: UITextField) {
//    if textField == ammountTextfield {
//      let amount = Int(textField.text ?? "0") ?? 0
//      let inrange = amount >= room.stake1 && amount <= room.stake2
//      if inrange {
//        ammountTextfield.showCorrectIcon()
//      } else {
//        ammountTextfield.showErrorIcon()
//      }
//    }
  }
}

