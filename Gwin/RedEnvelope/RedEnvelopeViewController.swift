//
//  RedEnvelopeViewController.swift
//  Gwin
//
//  Created by Hai Vu Van on 8/23/19.
//  Copyright © 2019 Hai Vu Van. All rights reserved.
//

import UIKit

class RedEnvelopeViewController: BaseViewController {

  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var rollMsgView: UIView!
  private lazy var marqueView:ScrollLabel = {
    let view = ScrollLabel().forAutolayout()
    return view
  }()

  var rooms: [RoomModel] = []
  override func viewDidLoad() {
    super.viewDidLoad()
    self.edgesForExtendedLayout = []
    self.tabBarController?.tabBar.isHidden = false

    setTitle(title: "扫雷")
    // Do any additional setup after loading the view.
    setupViews()
    fetchRoomList()
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    hideBackButton()
    processing = false
  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
  }

  func setupViews() {
    tableView.register(GameItemCell.self, forCellReuseIdentifier: "envelopRoomCell")


    rollMsgView.addSubview(marqueView)
    marqueView.updateContent(message: RedEnvelopComponent.shared.rollMsg)
    NSLayoutConstraint.activate([
      marqueView.leftAnchor.constraint(equalTo: rollMsgView.leftAnchor, constant: 40),
      marqueView.topAnchor.constraint(equalTo: rollMsgView.topAnchor),
      marqueView.rightAnchor.constraint(equalTo: rollMsgView.rightAnchor),
      marqueView.bottomAnchor.constraint(equalTo: rollMsgView.bottomAnchor),

      ])
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
  func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
    return UIView()
  }

  func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
    return 0.1
  }

  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 80
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

  func doLogin(room: RoomModel) {
    guard let user = RedEnvelopComponent.shared.user else { return }
    guard let userno = RedEnvelopComponent.shared.userno else { return }
    if processing == true {
      return
    }

    processing = true
    showLoadingView()

    RedEnvelopAPIClient.roomLogin(ticket: user.ticket, roomId: room.roomId, roomPwd: room.roomPwd) { [weak self](success, message) in
      self?.hideLoadingView()
      self?.processing = false
      if success {
        let vc = RoomDetailViewController(userno: userno , room: room)
        vc.hidesBottomBarWhenPushed = true
        self?.navigationController?.pushViewController(vc, animated: true)
      } else {
        if let errorMsg = message {
          self?.showAlertMessage(message: errorMsg)
        }
      }
    }
  }
}

extension RedEnvelopeViewController {
  fileprivate func showInputPassword(room: RoomModel) {
    let alertVC = UIAlertController(title: nil, message: "请输入房间密码", preferredStyle: .alert)
    alertVC.addTextField(configurationHandler: { (textField) in
      textField.isSecureTextEntry = true
      textField.placeholder = "请输入房间密码"
      textField.textAlignment = .center
    })

    let saveAction = UIAlertAction(title: "确认", style: .default, handler: { [weak self] alert -> Void in
      if let firstTextField = alertVC.textFields?[0], let roompwd = firstTextField.text, roompwd == room.roomPwd {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
          self?.doLogin(room: room)
        })
      }else {
        self?.showAlertMessage(message: "输入密码错误，请重新输入")
      }
    })

    let cancelAction = UIAlertAction(title: "取消", style: .default, handler: nil)

    alertVC.addAction(cancelAction)
    alertVC.addAction(saveAction)
//    setupAnimationForAlert()
//    DispatchQueue.main.async {  //make sure all UI updates are on the main thread.
//      self.view.layer.add(CATransition().segueFromBottom(), forKey: nil)
     presentAlert(alertVC, animated: true, completion: nil)
//    }
  }
}


