//
//  RedEnvelopTabbarController.swift
//  Gwin
//
//  Created by Hai Vu Van on 8/21/19.
//  Copyright © 2019 Hai Vu Van. All rights reserved.
//

import UIKit

class RedEnvelopTabbarController: UITabBarController {
  var homeViewController: (UIViewController & HomeViewControllerInput)!
  var secondViewController: UIViewController!
  var actionViewController: UIViewController!
  var thirdViewController: UIViewController!
  var fourthViewController: UIViewController!

  override func viewDidLoad() {
    super.viewDidLoad()
    initViewConstroller()
    viewControllers = [homeViewController, secondViewController, actionViewController, thirdViewController, fourthViewController]

    // Do any additional setup after loading the view.
  }


  func initViewConstroller() {
    let router = HomeBuilder().build()
    homeViewController = router.viewController
    secondViewController = UIViewController()
    thirdViewController = UIViewController()
    actionViewController = UIViewController()
    fourthViewController = UIViewController()

  }
  /*
   // MARK: - Navigation

   // In a storyboard-based application, you will often want to do a little preparation before navigation
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
   // Get the new view controller using segue.destination.
   // Pass the selected object to the new view controller.
   }
   */

}

