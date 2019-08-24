//
//  RoomDetailViewController.swift
//  Gwin
//
//  Created by Hai Vu Van on 8/24/19.
//  Copyright © 2019 Hai Vu Van. All rights reserved.
//

import UIKit
import SwiftyJSON
import Starscream

class RoomDetailViewController: BaseViewController {

  enum Constants {
    static let bottomImages: [String] = ["boom_bottom_image_1","boom_bottom_image_2","boom_bottom_image_3","boom_bottom_image_4"]
    static let bottomTitles: [String] = ["发扫雷包","发福利包","充值","提现"]
  }

  private lazy var profileButton: UIButton = {
    let button = UIButton().forAutolayout()
    button.imageView?.contentMode = .scaleAspectFit
    button.setImage(UIImage(named: "boom_header_profile"), for: .normal)
    return button
  }()

  private lazy var newPackageButton: UIButton = {
    let button = UIButton().forAutolayout()
    button.imageView?.contentMode = .scaleAspectFit
    button.setImage(UIImage(named: "boom_header_envelop"), for: .normal)
    button.addTarget(self, action: #selector(createPackagePressed(_:)), for: .touchUpInside)
    return button
  }()

  private lazy var backButton: UIButton = {
    let button = UIButton().forAutolayout()
    button.backgroundColor = .blue
    button.addTarget(self, action: #selector(backPressed(_:)), for: .touchUpInside)
    return button
  }()

  private var tableView: UITableView = {
    let tableView = UITableView(frame: .zero).forAutolayout()

    return tableView
  }()

  private lazy var bottomView: UIStackView = {
    let view = UIStackView().forAutolayout()
    view.axis = .vertical
    view.distribution = .fill
    return view
  }()

  private lazy var bottomTitleLabel: UILabel = {
    let title = UILabel().forAutolayout()
    title.text = "accccdddd"
    return title
  }()

  private lazy var plusButton: UIButton = {
    let button = UIButton().forAutolayout()
    button.imageView?.contentMode = .scaleAspectFit
    button.setImage(UIImage(named: "boom_bottom_plus"), for: .normal)
    button.addTarget(self, action: #selector(expandPressed(_:)), for: .touchUpInside)
    return button
  }()

  private lazy var bottomButtonStackView: UIStackView = {
    let view = UIStackView().forAutolayout()
    view.axis = .horizontal
    view.distribution = .fill
    return view
  }()

  private var bottomHeighConstraint: NSLayoutConstraint?

  private var userno: String
  private var room: RoomModel
  var socket: WebSocket

  private var histories: [PackageHistoryModel] = []
  init(userno: String, room: RoomModel) {
    self.userno = userno
    self.room = room
    self.socket  = WebSocket(url: URL(string: "ws://103.40.178.46:5013//GameConnect.ashx?userno=\(userno)")!, protocols: [])

    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .white
    // Do any additional setup after loading the view.
    initWebsocket()
    setupNavigatorViews()
    setupViews()
    setupTableView()
    setupBottomView()
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    self.tabBarController?.tabBar.isHidden = false
  }
  
  deinit {
    socket.disconnect(forceTimeout: 0)
    socket.delegate = nil
  }

  func setupNavigatorViews() {
    let rightItem1 = UIBarButtonItem(customView: profileButton)
    let rightItem2 = UIBarButtonItem(customView: newPackageButton)

    self.navigationItem.rightBarButtonItems = [rightItem2, rightItem1]
    self.setTitle(title: "可发可抢")
  }

  func setupViews() {
    view.addSubview(tableView)
    view.addSubview(bottomView)

    if #available(iOS 11, *) {
      let guide = view.safeAreaLayoutGuide
      NSLayoutConstraint.activate([

        bottomView.leftAnchor.constraint(equalTo: guide.leftAnchor),
        bottomView.rightAnchor.constraint(equalTo: guide.rightAnchor),
        bottomView.bottomAnchor.constraint(equalTo: guide.bottomAnchor),

        tableView.topAnchor.constraint(equalTo: guide.topAnchor),
        tableView.leftAnchor.constraint(equalTo: guide.leftAnchor),
        tableView.rightAnchor.constraint(equalTo: guide.rightAnchor),
        tableView.bottomAnchor.constraint(equalTo: bottomView.topAnchor),

        ])
    }else{
      NSLayoutConstraint.activate([
        bottomView.leftAnchor.constraint(equalTo: view.leftAnchor),
        bottomView.rightAnchor.constraint(equalTo: view.rightAnchor),
        bottomView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

        tableView.topAnchor.constraint(equalTo: view.topAnchor),
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor),
        tableView.bottomAnchor.constraint(equalTo: bottomView.topAnchor),
        ])
    }
  }

  func setupBottomView() {
    let buttonSize = view.frame.size.width / 4

    let labelStackView = getHorizontalStackView()
    labelStackView.addArrangedSubview(bottomTitleLabel)
    labelStackView.addArrangedSubview(plusButton)

    bottomView.addArrangedSubview(labelStackView)

    for i in 0 ..< Constants.bottomImages.count {
      let button = UIButton().forAutolayout()
      button.tag = i
      button.addTarget(self, action: #selector(actionPressed(_:)), for: .touchUpInside)
      button.setTitle(Constants.bottomTitles[i], for: .normal)
      button.setImage(UIImage(named: Constants.bottomImages[i]), for: .normal)
      button.adjustImageAndTitleOffsetsForButton()
      button.setTitleColor(.black, for: .normal)
      bottomButtonStackView.addArrangedSubview(button)

      NSLayoutConstraint.activate([
        button.widthAnchor.constraint(equalToConstant: buttonSize),
        button.heightAnchor.constraint(equalToConstant: buttonSize),

        ])
    }

    NSLayoutConstraint.activate([
      plusButton.widthAnchor.constraint(equalToConstant: 30),
      plusButton.heightAnchor.constraint(equalToConstant: 30),
      plusButton.rightAnchor.constraint(equalTo: labelStackView.leftAnchor, constant: -10)
      ])

  }

  func setupTableView() {
    tableView.register(UINib(nibName: "PackageHistoryRightViewCell", bundle: nil), forCellReuseIdentifier: "PackageHistoryRightViewCell")
    tableView.register(UINib(nibName: "PackageHistoryLeftViewCell", bundle: nil), forCellReuseIdentifier: "PackageHistoryLeftViewCell")

    tableView.delegate = self
    tableView.dataSource = self
  }

  func initWebsocket() {
    socket.delegate = self
    socket.connect()
  }

  func getGameData(){
    guard let user = RedEnvelopComponent.shared.user else { return}
    let jsonString = "{\"action\": \"roompushdata\",\"ticket\": \"\(user.ticket)\",\"data\": { \"roomid\": \(room.roomId)  ,\"packetid\": 0}}"


    sendMessage(jsonString)
  }

  @objc func createPackagePressed(_ sender: UIButton) {
    showCreatePackage()
  }

  @objc func expandPressed(_ sender: UIButton){
    plusButton.isSelected = !plusButton.isSelected
    if plusButton.isSelected {
      bottomView.addArrangedSubview(bottomButtonStackView)
    }else {
      bottomButtonStackView.removeFromSuperview()
    }
  }

  @objc func actionPressed(_ sender: UIButton){
    let tag = sender.tag
    if tag == 0 {
      showCreatePackage()
    } else if tag == 1 {
      showCreatePackageType2()
    } else if tag == 2 {

    } else if tag == 3 {

    }
  }
}

extension RoomDetailViewController {

  fileprivate func sendMessage(_ message: String) {
    socket.write(string: message)
  }

  fileprivate func messageReceived(_ message: String, senderName: String) {
    print("messageReceived")
  }
}

extension RoomDetailViewController {

  fileprivate func showCreatePackage(){
    let vc = CreateEnvelopViewController(room: room)

    vc.hidesBottomBarWhenPushed = true
    self.navigationController?.pushViewController(vc, animated: true)

  }

  fileprivate func showCreatePackageType2() {
    let vc = CreateEnvelopType2ViewController(room: room)

    vc.hidesBottomBarWhenPushed = true
    self.navigationController?.pushViewController(vc, animated: true)
  }

  fileprivate func getHorizontalStackView() -> UIStackView {
    let stack = UIStackView().forAutolayout()
    stack.axis = .horizontal
    stack.distribution = .fill
    return stack
  }
}

extension RoomDetailViewController: UITableViewDelegate, UITableViewDataSource {

  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 165
  }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return histories.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

    let model = histories[indexPath.row]
    if userno == model.userno {
      if let cell =  tableView.dequeueReusableCell(withIdentifier: "PackageHistoryLeftViewCell", for: indexPath) as? PackageHistoryLeftViewCell {

        cell.updateViews(model: model)
      }
    } else {
      if let cell =  tableView.dequeueReusableCell(withIdentifier: "PackageHistoryRightViewCell", for: indexPath) as? PackageHistoryRightViewCell {

        cell.updateViews(model: model)
      }
    }

    return UITableViewCell()
  }

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let vc = PackageInfoViewController(nibName: "PackageInfoViewController", bundle: nil)
   present(vc, animated: true, completion: nil)
  }
}



// MARK: - WebSocketDelegate
extension RoomDetailViewController: WebSocketDelegate {
  func websocketDidConnect(socket: WebSocketClient) {

    print("websocketDidConnect")
    getGameData()
  }

  func websocketDidDisconnect(socket: WebSocketClient, error: Error?) {
    print("websocketDidDisconnect")

  }

  func websocketDidReceiveMessage(socket: WebSocketClient, text: String) {
    print("websocketDidReceiveMessage \(text)")

    let json = JSON(parseJSON: text).arrayValue

    for packageJson in json {
      let package = PackageHistoryModel(json: packageJson)
      histories.append(package)
    }
    tableView.reloadData()
    //    [{"roomid":5,"packetid":158983,"userno":"steven2","username":"","packetamount":200.00,"packettag":"5","wagertime":"2019-08-24 12:03:31"},{"roomid":5,"packetid":158984,"userno":"steven2","username":"","packetamount":2006.00,"packettag":"2","wagertime":"2019-08-24 12:03:48"}]

  }

  func websocketDidReceiveData(socket: WebSocketClient, data: Data) {
    print("websocketDidReceiveData")

  }
}






