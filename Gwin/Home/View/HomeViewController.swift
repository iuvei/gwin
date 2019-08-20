//
//  HomeViewController.swift
//  Gwin
//
//  Created by Hai Vu Van on 8/18/19.
//  Copyright © 2019 Hai Vu Van. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class HomeViewController: UIViewController {

  private var carouselView: CarouselView!

  override func viewDidLoad() {
    super.viewDidLoad()
    self.edgesForExtendedLayout = []

    // Do any additional setup after loading the view.
    setupViews()
    UserAPIClient.login(accountNo: "steven", password: "123456") { user, message in
      if let `user` = user {
        print("user \(user)")
      }
    }

  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    carouselView.updateView(dataSource: ["carousel_demo_1","carousel_demo_2"])
  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
  }
  /*
   // MARK: - Navigation

   // In a storyboard-based application, you will often want to do a little preparation before navigation
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
   // Get the new view controller using segue.destination.
   // Pass the selected object to the new view controller.
   }
   */

  func setupViews() {
    carouselView = CarouselView()
    carouselView.translatesAutoresizingMaskIntoConstraints = false

    view.addSubview(carouselView)

    NSLayoutConstraint.activate([
      carouselView.leftAnchor.constraint(equalTo: view.leftAnchor),
      carouselView.topAnchor.constraint(equalTo: view.topAnchor),
      carouselView.rightAnchor.constraint(equalTo: view.rightAnchor),
      carouselView.heightAnchor.constraint(equalToConstant: 300)
      ])
  }

}

