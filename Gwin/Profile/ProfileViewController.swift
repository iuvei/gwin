//
//  ProfileViewController.swift
//  Gwin
//
//  Created by Hai Vu Van on 8/22/19.
//  Copyright © 2019 Hai Vu Van. All rights reserved.
//

import UIKit
import SwiftyJSON

class ProfileViewController: UIViewController {

  enum Constants {
    static let cellHeight: CGFloat = 35
  }


  @IBOutlet weak var infoView: UIView!
  @IBOutlet weak var tableview: UITableView!
  
  @IBOutlet weak var allowCreditLabel: UILabel!
  @IBOutlet weak var creditLabel: UILabel!
  @IBOutlet weak var accountnoLabel: UILabel!
  @IBOutlet weak var accountNameLabel: UILabel!
  private var menuItems:[ProfileItemModel] = []
  override func viewDidLoad() {
    super.viewDidLoad()
    self.edgesForExtendedLayout = []

    // Do any additional setup after loading the view.
    initData()
    setupViews()
    fetchUserInfo()
  }

  func initData() {
    if let path = Bundle.main.path(forResource: "ProfileItems", ofType: "json") {
      do {
        let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
        let jsonObj = try JSON(data: data).array

        jsonObj?.forEach{ json in
          let lobby = ProfileItemModel(json: json)
          menuItems.append(lobby)
        }
      } catch {
        // handle error
        print("Abcdef")
      }
    }
  }

  func fetchUserInfo() {
    guard let user = RedEnvelopComponent.shared.user else { return }
    UserAPIClient.userInfo(ticket: user.ticket) { [weak self] (userInfo, errorMessage) in
      guard let this = self else { return }
      if let `userInfo` = userInfo {
        print("userInfo \(userInfo)")
        this.accountnoLabel.text = userInfo.accountno
        this.accountNameLabel.text = userInfo.accountname
        this.allowCreditLabel.text = "\(userInfo.allowcreditquota)"
        this.creditLabel.text = "\(userInfo.usecreditquota)"
      } else {

      }

    }
  }

  func setupViews() {
    setupTableView()
  }

  func setupTableView() {
    tableview.register(ProfileItemViewCell.self, forCellReuseIdentifier: "profileItemCell")
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

extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {

  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return Constants.cellHeight
  }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return menuItems.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    if let cell = tableView.dequeueReusableCell(withIdentifier: "profileItemCell", for: indexPath) as? ProfileItemViewCell {
      let item = menuItems[indexPath.row]
      cell.updateContent(data: item)
      return cell

    }

    return UITableViewCell()

  }
}

