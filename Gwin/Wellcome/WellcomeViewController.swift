//
//  WellcomeViewController.swift
//  Gwin
//
//  Created by Hai Vu Van on 8/20/19.
//  Copyright © 2019 Hai Vu Van. All rights reserved.
//

import UIKit

class WellcomeViewController: UIViewController {

  @IBOutlet weak var loginButton: UIButton!
  @IBOutlet weak var registerButton: UIButton!

  override func viewDidLoad() {
    super.viewDidLoad()

    // Do any additional setup after loading the view.
    setupViews()
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)

  }

  func setupViews() {
    setNavigationBackgroundColor(color: UIColor(hexString:"D66850"))
    loginButton.rounded()
    registerButton.rounded()
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
    let router = LoginBuilder().build(withListener: nil)
    self.navigationController?.pushViewController(router.viewController, animated: true)
  }


  @IBAction func registerPressed(_ sender: Any) {
    let registerVC = RegisterViewController(nibName: "RegisterViewController", bundle: .main)
    self.navigationController?.pushViewController(registerVC, animated: true)
  }
}

