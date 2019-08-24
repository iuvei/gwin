//
//  RedEnvelopeViewController.swift
//  Gwin
//
//  Created by Hai Vu Van on 8/23/19.
//  Copyright © 2019 Hai Vu Van. All rights reserved.
//

import UIKit

class RedEnvelopeViewController: UIViewController {

  @IBOutlet weak var tableView: UITableView!

  var rooms: [RoomModel] = []
  override func viewDidLoad() {
    super.viewDidLoad()
    self.edgesForExtendedLayout = []

    // Do any additional setup after loading the view.
    setupViews()
    fetchRoomList()
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    self.tabBarController?.tabBar.isHidden = false
  }

  func setupViews() {
    tableView.register(GameItemCell.self, forCellReuseIdentifier: "envelopRoomCell")
  }

  func fetchRoomList() {

    guard let `user` = RedEnvelopComponent.shared.user else { return }

    RedEnvelopAPIClient.getRoomList(ticket: user.ticket, roomtype: RoomType.boom) {[weak self] (rooms, msg) in
      guard let this = self else { return }
      if let _rooms = rooms {
        this.rooms = _rooms
      }

      this.tableView.reloadData()
    }
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

extension RedEnvelopeViewController: UITableViewDelegate, UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return rooms.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

    if let cell = tableView.dequeueReusableCell(withIdentifier: "envelopRoomCell", for: indexPath) as? GameItemCell {
      let model = rooms[indexPath.row]
      cell.updateView(model: model)
      return cell
    }

    return UITableViewCell()
  }

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let model  = rooms[indexPath.row]

    doLogin(room: model)

  }

  func doLogin(room: RoomModel) {

    guard let user = RedEnvelopComponent.shared.user else { return }

    RedEnvelopAPIClient.roomLogin(ticket: user.ticket, roomId: room.roomId, roomPwd: room.roomPwd) { (success, message) in

      if success {
        let vc = RoomDetailViewController(userno: "steven", room: room)
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
      }
    }
  }
}

