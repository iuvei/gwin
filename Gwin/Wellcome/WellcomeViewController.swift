//
//  WellcomeViewController.swift
//  Gwin
//
//  Created by Hai Vu Van on 8/20/19.
//  Copyright © 2019 Hai Vu Van. All rights reserved.
//

import UIKit

class WellcomeViewController: BaseViewController {

  @IBOutlet weak var loginButton: UIButton!
  @IBOutlet weak var registerButton: UIButton!

  override func viewDidLoad() {
    super.viewDidLoad()

    // Do any additional setup after loading the view.
    setTitle(title: AppText.Titles.wellcome)
    hideBackButton()
    setupViews()

    if UserDefaultManager.sharedInstance().autoLogin() {
      guard let userno = UserDefaultManager.sharedInstance().loginInfoUserName() else {return}
      guard let password = UserDefaultManager.sharedInstance().loginInfoPassword() else {return}
      
      showLoadingView()
      UserAPIClient.login(accountNo: userno, password: password) {[weak self] (user, message) in
        guard let `this` = self else { return }
        this.hideLoadingView()
        if let `user` = user {
          RedEnvelopComponent.shared.userno = userno
          RedEnvelopComponent.shared.user = user
          if let appDelegate: AppDelegate = UIApplication.shared.delegate as? AppDelegate {
            appDelegate.setHomeAsRootViewControlelr()
          }
        }
      }

    }
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)

  }

  func setupViews() {
    loginButton.rounded()
    loginButton.applyGradient(withColours: [UIColor(hexString: "D7566A"), UIColor(hexString: "e75f48")], gradientOrientation: .horizontal)
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

