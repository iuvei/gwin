//
//  PaddingTextfield.swift
//  Gwin
//
//  Created by Hai Vu Van on 8/25/19.
//  Copyright © 2019 Hai Vu Van. All rights reserved.
//

import Foundation
import UIKit

class UITextFieldPadding : UITextField {

  let padding = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)

  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }

  override func textRect(forBounds bounds: CGRect) -> CGRect {
    return bounds.inset(by: padding)
  }

  override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
    return bounds.inset(by: padding)
  }

  override func editingRect(forBounds bounds: CGRect) -> CGRect {
    return bounds.inset(by: padding)
  }
}
