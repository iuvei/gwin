//
//  GameRoomViewController.swift
//  Gwin
//
//  Created by Hai Vu Van on 8/26/19.
//  Copyright © 2019 Hai Vu Van. All rights reserved.
//

import UIKit

class GameRoomViewController: UIViewController {

  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var rollMsgLabel: UILabel!

  var rooms: [RoomModel] = []

  override func viewDidLoad() {
    super.viewDidLoad()

    // Do any additional setup after loading the view.
    setTitle(title: "牛牛")
    setupViews()
    fetchBullRoom()

  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
  }

  func setupViews() {

    rollMsgLabel.text = RedEnvelopComponent.shared.rollMsg

    tableView.register(GameItemCell.self, forCellReuseIdentifier: "envelopRoomCell")
  }

  /*
   // MARK: - Navigation

   // In a storyboard-based application, you will often want to do a little preparation before navigation
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
   // Get the new view controller using segue.destination.
   // Pass the selected object to the new view controller.
   }
   */

  func fetchBullRoom() {
    guard let `user` = RedEnvelopComponent.shared.user else { return }

    RedEnvelopAPIClient.getRoomList(ticket: user.ticket, roomtype: RoomType.bull) {[weak self] (rooms, msg) in
      guard let this = self else { return }
      if let _rooms = rooms {
        this.rooms = _rooms
      }

      this.tableView.reloadData()
    }
  }
}


extension GameRoomViewController: UITableViewDelegate, UITableViewDataSource {
  func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
    return UIView()
  }

  func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
    return 0.1
  }

  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 90
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return rooms.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

    if let cell = tableView.dequeueReusableCell(withIdentifier: "envelopRoomCell", for: indexPath) as? GameItemCell {
      let model = rooms[indexPath.row]
      cell.selectionStyle = .none
      cell.updateView(model: model)
      return cell
    }

    return UITableViewCell()
  }

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let model  = rooms[indexPath.row]

    if model.roomPwd.count > 0 {
      showInputPassword(room: model)
    } else {
      doLogin(room: model)
    }
  }
}

extension GameRoomViewController {
  fileprivate func showInputPassword(room: RoomModel) {
    let alertVC = UIAlertController(title: nil, message: "room password", preferredStyle: .alert)
    alertVC.addTextField(configurationHandler: { (textField) in
      textField.isSecureTextEntry = true
      textField.placeholder = "Enter password"
    })

    let saveAction = UIAlertAction(title: "Save", style: .default, handler: { [weak self] alert -> Void in
      if let firstTextField = alertVC.textFields?[0], let roompwd = firstTextField.text, roompwd == room.roomPwd {
        self?.doLogin(room: room)
      }
    })

    let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)

    alertVC.addAction(cancelAction)
    alertVC.addAction(saveAction)
    present(alertVC, animated: true, completion: nil)
  }

  fileprivate func doLogin(room: RoomModel) {

    guard let user = RedEnvelopComponent.shared.user else { return }
    guard let userno = RedEnvelopComponent.shared.userno else { return }

    RedEnvelopAPIClient.roomLogin(ticket: user.ticket, roomId: room.roomId, roomPwd: room.roomPwd) { (success, message) in

      if success {
        let vc = BullDetailViewController(userno: userno , room: room)
        self.navigationController?.pushViewController(vc, animated: true)
      }
    }
  }
}
