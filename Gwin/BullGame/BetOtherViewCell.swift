//
//  BetOtherViewCell.swift
//  Gwin
//
//  Created by Hai Vu Van on 8/30/19.
//  Copyright © 2019 Hai Vu Van. All rights reserved.
//

import UIKit

class BetOtherViewCell: UITableViewCell {

  @IBOutlet weak var colorView: UIView!
  @IBOutlet weak var nameLabel: UILabel!

  @IBOutlet weak var typeLabel: UILabel!
  @IBOutlet weak var oddLabel: UILabel!

  @IBOutlet weak var inputTextfield: UITextField!

  var completionHandler: ()->Void = { }
  var didMoneyChanged: (Float)->Void = {_ in }
  var didMoneyInput: (Float)->Void = {_ in }

  var model: BullWagerOddModel?
  var minValue:Int = 0
  var maxValue:Int = 0

  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
    inputTextfield.delegate = self
    inputTextfield.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    inputTextfield.backgroundColor = .white
    inputTextfield.rounded()
    inputTextfield.layer.zPosition = 1
    
  }

  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)

    // Configure the view for the selected state
  }

  func updateView(model: BullWagerOddModel,input: Bool = false, selected: Bool = false, min: Int = 0, max: Int = 0) {
    self.model = model
    self.minValue = min
    self.maxValue = max
    //

    oddLabel.text = String(format: "%@", model.odds.toFormatedString())
    nameLabel.text =  model.name
    typeLabel.text = model.objectName
    inputTextfield.backgroundColor = .white

    if model.selected {
      colorView.backgroundColor = AppColors.tabbarColor.withAlphaComponent(0.8)
    }else {
      colorView.backgroundColor = .white

    }
  }
  @objc func textFieldDidChange(_ textfield: UITextField) {
    if let money = textfield.text, let moneyValue = Float(money) {
      didMoneyChanged(moneyValue)
    }else {
      didMoneyChanged(0)
    }
  }
}

extension BetOtherViewCell: UITextFieldDelegate {
  func textFieldDidBeginEditing(_ textField: UITextField) {
    completionHandler()

  }

  func textFieldDidEndEditing(_ textField: UITextField) {
    if let money = textField.text, let moneyValue = Float(money) {
      didMoneyInput(moneyValue)
    }
  }

  func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    guard let textFieldText = textField.text,
      let rangeOfTextToReplace = Range(range, in: textFieldText) else {
        return false
    }

    let substringToReplace = textFieldText[rangeOfTextToReplace]

    let finalString = "\(textField.text ?? "")\(string)"
    print("sub : \(substringToReplace) string:\(string)  abc: \(finalString)")
    if let `model` =  model {
      if let moneyValue  = Int(finalString) {
        return moneyValue <= maxValue
      }
    }

    return true
  }
}

