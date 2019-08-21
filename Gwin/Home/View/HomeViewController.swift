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

protocol HomeViewInput: AnyObject {
  func updatePopularizeImage(images: [String])
}

protocol HomeViewOutput: AnyObject {
  func viewDidLoad()
}

public protocol HomeViewControllerInput: AnyObject {
}

class HomeViewController: UIViewController {
  weak var output: HomeViewOutput?

  private var carouselView: CarouselView!

  init(output: HomeViewOutput? = nil) {
    self.output = output
    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.edgesForExtendedLayout = []
    output?.viewDidLoad()
    // Do any additional setup after loading the view.
    setupViews()

  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
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

extension HomeViewController: HomeViewInput {
  func updatePopularizeImage(images: [String]) {
    carouselView.updateView(dataSource: images)
  }
}

extension HomeViewController: HomeViewControllerInput {
  
}

