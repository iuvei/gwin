//
//  RedEnvelopTabbarController.swift
//  Gwin
//
//  Created by Hai Vu Van on 8/21/19.
//  Copyright © 2019 Hai Vu Van. All rights reserved.
//

import UIKit

class RedEnvelopTabbarController: UITabBarController {

  private var lastIndex: Int = 0

  override func viewDidLoad() {
    super.viewDidLoad()

    // Do any additional setup after loading the view.
  }


  func initViewConstroller() {

  }
  /*
   // MARK: - Navigation

   // In a storyboard-based application, you will often want to do a little preparation before navigation
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
   // Get the new view controller using segue.destination.
   // Pass the selected object to the new view controller.
   }
   */

    func selectItem(withIndex index: Int) {
      selectedIndex = index
    }

  func backToLastView (){
    selectItem(withIndex: lastIndex)
  }

  func selectProfileTab(){
    selectItem(withIndex: 4)

  }

  override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
    if item == self.tabBar.items?[0]{
      //Do something if index is 0
      lastIndex = 0
    }
    else if item == self.tabBar.items?[1]{
      //Do something if index is 1
      lastIndex = 1

    } else if item == self.tabBar.items?[2]{
      //Do something if index is 1
      lastIndex = 2

    }
    else if item == self.tabBar.items?[3]{
      //Do something if index is 1
//      guard let user = RedEnvelopComponent.shared.user else { return }
//      RedEnvelopAPIClient.lottery(ticket: user.ticket, gameno: "6") { (gameurl, def) in
//        if let url = gameurl {
//          let webController = WebContainerController(url: url, lastIndex: self.lastIndex)
//          self.present(webController, animated:true, completion:nil)
//        }
//      }
//      selectedIndex = lastIndex
    } else if item == self.tabBar.items?[4]{
      //Do something if index is 1
      lastIndex = 4

    }
  }

}

