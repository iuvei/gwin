//
//  CreateEnvelopViewController.swift
//  Gwin
//
//  Created by Hai Vu Van on 8/24/19.
//  Copyright © 2019 Hai Vu Van. All rights reserved.
//

import UIKit

class CreateEnvelopViewController: BaseViewController {

  enum Constans {
    static let packageTagMaxLengh: Int = 1
  }

  @IBOutlet weak var sendButton: UIButton!
  @IBOutlet weak var packageTagTextfield: UITextFieldPadding!

  @IBOutlet weak var packageAmountTextfield: UITextFieldPadding!

  @IBOutlet weak var packageSizeLabel: UILabel!
  @IBOutlet weak var titleLabel: UILabel!


  var room: RoomModel

  init(room: RoomModel) {
    self.room = room
    super.init(nibName: "CreateEnvelopViewController", bundle: nil)
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    // Do any additional setup after loading the view.
    setupViews()
  }


  func setupViews() {
    packageTagTextfield.rounded()
    packageAmountTextfield.rounded()
    sendButton.rounded()

    packageSizeLabel.text = "\(room.packageSize)"
    packageAmountTextfield.placeholder = "\(room.stake1)-\(room.stake2)"


    packageTagTextfield.addTarget(self, action: #selector(textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
    packageTagTextfield.delegate = self
    packageAmountTextfield.delegate = self
  
  }

  /*
   // MARK: - Navigation

   // In a storyboard-based application, you will often want to do a little preparation before navigation
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
   // Get the new view controller using segue.destination.
   // Pass the selected object to the new view controller.
   }
   */

  @objc func textFieldDidChange(_ sender: UITextField) {
    titleLabel.text = "¥ \(sender.text ?? "")"
  }

  @IBAction func sendPackagePressed(_ sender: Any) {
    guard let amountText = packageAmountTextfield.text, let amount = Int(amountText) else { return }
    guard let tag = packageTagTextfield.text else { return }
    guard let user = RedEnvelopComponent.shared.user else { return }

    RedEnvelopAPIClient.sendPackage(ticket: user.ticket, roomid: room.roomId, packageamount: amount, packagesize: room.packageSize, packagetag: tag) {[weak self] (success, message) in
      if success {
        self?.navigationController?.popViewController(animated: true)
      }
    }
  }

}

extension CreateEnvelopViewController : UITextFieldDelegate {
  func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    guard let textFieldText = textField.text,
      let rangeOfTextToReplace = Range(range, in: textFieldText) else {
        return false
    }
    let substringToReplace = textFieldText[rangeOfTextToReplace]
    let count = textFieldText.count - substringToReplace.count + string.count
    if textField == packageTagTextfield {

      return count <= Constans.packageTagMaxLengh
    } else if textField == packageAmountTextfield {
      return count <= room.stake2.usefulDigits
    }

    return true
  }
}

