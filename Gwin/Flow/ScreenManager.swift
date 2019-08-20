//
//  ScreenManager.swift
//  Gwin
//
//  Created by Hai Vu Van on 8/20/19.
//  Copyright © 2019 Hai Vu Van. All rights reserved.
//

import Foundation
import UIKit

public class ScreenManager {
  static func loginScreen() -> UIViewController {
    let vc = LoginViewController(nibName: "LoginViewController", bundle: nil)
    return vc
  }
}
