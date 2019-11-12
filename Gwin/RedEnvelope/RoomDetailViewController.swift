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
import CoreData
import MarqueeLabel

class RoomDetailViewController: BaseViewController {

  enum Constants {
    static let bottomImages: [String] = ["boom_bottom_image_1","boom_bottom_image_2","boom_bottom_image_3","boom_bottom_image_4"]
    static let bottomTitles: [String] = ["发扫雷包","发福利包","充值","提现"]
    static let notifySize: CGFloat = 35
    static let defaultInfoHeight: CGFloat = 150

  }

  private lazy var profileButton: UIButton = {
    let button = UIButton(frame: CGRect(x: 0,y: 0,width: 35,height: 35))
    button.imageEdgeInsets  = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
    button.imageView?.contentMode = .scaleAspectFit
    button.setImage(UIImage(named: "boom_header_profile"), for: .normal)
    button.addTarget(self, action: #selector(profilePressed(_:)), for: .touchUpInside)
    return button
  }()

  private lazy var newPackageButton: UIButton = {
    let button = UIButton(frame: CGRect(x: 0,y: 0,width: 35,height: 35))
    button.imageEdgeInsets  = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
    button.imageView?.contentMode = .scaleAspectFit
    button.setImage(UIImage(named: "boom_header_envelop"), for: .normal)
    button.addTarget(self, action: #selector(bullReportPressed(_:)), for: .touchUpInside)
    return button
  }()

  private lazy var backButton: UIButton = {
    let button = UIButton().forAutolayout()
    button.backgroundColor = .blue
    button.addTarget(self, action: #selector(backPressed(_:)), for: .touchUpInside)
    return button
  }()

  private lazy var notifyView: UIView = {
    let view = UIView().forAutolayout()
    view.isHidden = true
    return view
  }()

  private lazy var notifyBackground: UIImageView = {
    let imageView = UIImageView().forAutolayout()
    imageView.image = UIImage(named: "room_notify")
    imageView.contentMode = .scaleAspectFit
    return imageView
  }()

  private lazy var notifyLabel: UILabel = {
    let label = UILabel().forAutolayout()
    label.textAlignment = .center
    label.textColor = .white
    label.font = UIFont.systemFont(ofSize: 14)
    return label
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

  private lazy var bottomTitleLabel: ScrollLabel = {
    let title = ScrollLabel().forAutolayout()
    title.updateContent(message: "红包炸雷100")
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
  private var openPackages: [NSManagedObject] = []
  private var newMessage: Int = 0

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
    setTitle(title: "可发可抢")
    // Do any additional setup after loading the view.
    fetchOpenPackages()
    initWebsocket()
    setupNavigatorViews()
    setupViews()
    setupTableView()
    setupNotifiView()
    setupBottomView()
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    guard let user = RedEnvelopComponent.shared.user else { return }

    UserAPIClient.systemtime(ticket: user.ticket) { (systemtime) in
      if let timer = systemtime {
        RedEnvelopComponent.shared.systemtime = timer.toDate()
      }
    }
  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
  }

  deinit {
    socket.disconnect(forceTimeout: 0)
    socket.delegate = nil
  }

  func setupNavigatorViews() {

    profileButton.frame = CGRect(x: 0, y: 0, width: 35, height: 56)
    newPackageButton.frame = CGRect(x: 0, y: 0, width: 35, height: 56)

//    let rightItem1 = UIBarButtonItem(customView: profileButton)
    let rightItem2 = UIBarButtonItem(customView: newPackageButton)

    self.navigationItem.rightBarButtonItems = [rightItem2]
//    self.navigationItem.rightBarButtonItems = [rightItem1, rightItem2]

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
        tableView.bottomAnchor.constraint(equalTo: bottomView.topAnchor, constant: -5),

        ])
    }else{
      NSLayoutConstraint.activate([
        bottomView.leftAnchor.constraint(equalTo: view.leftAnchor),
        bottomView.rightAnchor.constraint(equalTo: view.rightAnchor),
        bottomView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

        tableView.topAnchor.constraint(equalTo: view.topAnchor),
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor),
        tableView.bottomAnchor.constraint(equalTo: bottomView.topAnchor, constant: -5),
        ])
    }
  }

  func setupNotifiView() {
    view.addSubview(notifyView)
    notifyView.addSubview(notifyBackground)
    notifyView.addSubview(notifyLabel)
    notifyLabel.rounded(radius: 12, borderColor: .white, borderwidth: 1.5)

    NSLayoutConstraint.activate([
      notifyView.widthAnchor.constraint(equalToConstant: 40),
      notifyView.heightAnchor.constraint(equalToConstant: 40),
      notifyView.rightAnchor.constraint(equalTo: tableView.rightAnchor, constant: -10),
      notifyView.bottomAnchor.constraint(equalTo: tableView.bottomAnchor),

      notifyBackground.topAnchor.constraint(equalTo: notifyView.topAnchor),
      notifyBackground.leftAnchor.constraint(equalTo: notifyView.leftAnchor),
      notifyBackground.rightAnchor.constraint(equalTo: notifyView.rightAnchor),
      notifyBackground.bottomAnchor.constraint(equalTo: notifyView.bottomAnchor),

      notifyLabel.centerXAnchor.constraint(equalTo: notifyView.centerXAnchor),
      notifyLabel.centerYAnchor.constraint(equalTo: notifyView.centerYAnchor, constant: -2),
      notifyLabel.widthAnchor.constraint(equalToConstant: 24),
      notifyLabel.heightAnchor.constraint(equalToConstant: 23),

      ])
  }

  func setupBottomView() {
    let buttonSize = view.frame.size.width / 4
    let firstSeperateView = UIView().forAutolayout()
    let secondSeperateView = UIView().forAutolayout()
    firstSeperateView.backgroundColor = .groupTableViewBackground
    secondSeperateView.backgroundColor = .groupTableViewBackground

    let labelStackView = getHorizontalStackView()
    labelStackView.addArrangedSubview(bottomTitleLabel)
    labelStackView.addArrangedSubview(plusButton)
    bottomView.addArrangedSubview(firstSeperateView)
    bottomView.addArrangedSubview(labelStackView)
    bottomView.addArrangedSubview(secondSeperateView)

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
      firstSeperateView.heightAnchor.constraint(equalToConstant: 1),
      secondSeperateView.heightAnchor.constraint(equalToConstant: 1),

      plusButton.widthAnchor.constraint(equalToConstant: 30),
      plusButton.heightAnchor.constraint(equalToConstant: 30),
      plusButton.rightAnchor.constraint(equalTo: labelStackView.leftAnchor, constant: -10),

      ])
  }

  func setupTableView() {
    tableView.register(UINib(nibName: "PackageHistoryRightViewCell", bundle: nil), forCellReuseIdentifier: "PackageHistoryRightViewCell")
    tableView.register(UINib(nibName: "PackageHistoryLeftViewCell", bundle: nil), forCellReuseIdentifier: "PackageHistoryLeftViewCell")
    tableView.separatorStyle = .none
    tableView.delegate = self
    tableView.dataSource = self
    tableView.rowHeight = UITableView.automaticDimension
    tableView.estimatedRowHeight = Constants.defaultInfoHeight
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

  //12-11
  //remove create package
//  @objc func createPackagePressed(_ sender: UIButton) {
//    showCreatePackage()
//  }

  @objc func bullReportPressed(_ sender: UIButton) {
    openWebview(optType: "orderdetail_1", title: "扫雷账单详情")
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
      openWebview(optType: "deposits")
    } else if tag == 3 {
      openWebview(optType: "withdrawals")
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

  fileprivate func openWebview(optType : String, title: String? = nil) {
    guard let `user` = RedEnvelopComponent.shared.user else { return }
    UserAPIClient.otherH5(ticket: user.ticket, optype: optType) {[weak self] (url, message) in
      guard let `this` = self else { return }

      if let jumpurl = url {
        let webview = WebContainerController(url: jumpurl, title: title)
        this.present(webview, animated: true, completion: nil)
      }
    }
  }

  fileprivate func getHorizontalStackView() -> UIStackView {
    let stack = UIStackView().forAutolayout()
    stack.axis = .horizontal
    stack.distribution = .fill
    return stack
  }
}

extension RoomDetailViewController {
  fileprivate func fetchOpenPackages() {
    if let userno = RedEnvelopComponent.shared.userno {
      openPackages = LocalDataManager.shared.fetchPackages(userno: userno)
    }
  }

  private func isOpenPackage(packageid: Int64) -> Bool {
    for obj in openPackages {
      if packageid == obj.value(forKey: "packageid") as? Int64 {
        return true
      }
    }
    return false
  }

  private func isBoomed(packageid: Int64) -> Bool {
    for obj in openPackages {
      if packageid == obj.value(forKey: "packageid") as? Int64 {
        return obj.value(forKey: "isBoom") as? Bool ?? false
      }
    }
    return false
  }

  private func isBiggest(packageid: Int64) -> Bool {
    for obj in openPackages {
      if packageid == obj.value(forKey: "packageid") as? Int64 {
        return obj.value(forKey: "isbiggest") as? Bool ?? false
      }
    }
    return false
  }

  func isPackageExpeire(wagertime: String) -> Bool{

    let packageDate = wagertime.toDate()
    if let systemtime = RedEnvelopComponent.shared.systemtime {
      let timeinterval = systemtime - packageDate
      let mins = timeinterval / (60)

      return mins > Double(RedEnvelopComponent.limitTime)
    }

    return false
  }


  private func updateCellAsOpened(packageid: Int64){
    var rowIndex: Int = -1
    for i in 0 ..< histories.count {
      let package = histories[i]
      if package.packetid == packageid {
        rowIndex = i
        break
      }
    }

    if rowIndex >= 0 {
      let indexPath = IndexPath(row: rowIndex, section: 0)
      tableView.beginUpdates()
      tableView.reloadRows(at: [indexPath], with: UITableView.RowAnimation.top)
      tableView.endUpdates()
    }
  }

  private func isTableInBottom() -> Bool {
    if  tableView.contentSize.height - (tableView.contentOffset.y + tableView.frame.size.height) <= Constants.defaultInfoHeight / 3 {
      //you reached end of the table
      return true
    }
    return false
  }
}

extension RoomDetailViewController: UITableViewDelegate, UITableViewDataSource {

  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return Constants.defaultInfoHeight
  }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    print("table count \(histories.count)")
    return histories.count
  }

  func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {

    let preIndex = indexPath.row - 1
    let preIndexPath = IndexPath(row: preIndex, section: indexPath.section)
    if let preCell = tableView.cellForRow(at: preIndexPath) {
      if tableView.visibleCells.contains(preCell){
        let model = histories[preIndex]
        model.viewed = true
      }
    }

  }
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

    let model = histories[indexPath.row]
    let isOpen = isOpenPackage(packageid: model.packetid)
    let isBoom = isBoomed(packageid: model.packetid)
    let isKing = isBiggest(packageid: model.packetid)
    let isExpired = isPackageExpeire(wagertime: model.wagertime)


    if userno != model.userno {
      if let cell =  tableView.dequeueReusableCell(withIdentifier: "PackageHistoryLeftViewCell", for: indexPath) as? PackageHistoryLeftViewCell {
        cell.selectionStyle = .none
        cell.updateViews(model: model, isOpen:isOpen, isKing: isKing, isBoomed: isBoom, expired: isExpired)

        return cell
      }
    } else {
      if let cell =  tableView.dequeueReusableCell(withIdentifier: "PackageHistoryRightViewCell", for: indexPath) as? PackageHistoryRightViewCell {
        cell.selectionStyle = .none
        cell.updateViews(model: model, isOpen: isOpen, isKing: isKing, isBoomed:isBoom, expired: isExpired)
        return cell
      }
    }

    return UITableViewCell()
  }

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let model = histories[indexPath.row]
    if isOpenPackage(packageid: model.packetid) {
      let infoVc = PackageInfoViewController(model: nil, roomid: room.roomId, packageid: model.packetid)
      infoVc.didPressedCreateEnvelop = { [weak self] in
          self?.showCreatePackage()
      }
      present(infoVc, animated: true, completion: nil)
    }else {
      let vc = GrabEnvelopViewController(package: model, delegate: self)
      vc.modalPresentationStyle = .overCurrentContext
      present(vc, animated: true, completion: nil)
    }
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

    if histories.count == 0 {
      DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
        self?.tableView.scrollToBottom()
      }
    }else {
      if isTableInBottom(){
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
          self?.tableView.scrollToBottom()
        }
      }
    }

    var usernos: [String] = []
    for packageJson in json {
      let package = PackageHistoryModel(json: packageJson)
      let viewed = isTableInBottom()
      package.viewed = viewed
      histories.append(package)
      if ImageManager.shared.getImage(userno: package.userno) == nil {
        usernos.append(package.userno)
      }
    }


    //
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
      self?.updateNotifyView()
    }

    tableView.reloadData()
    //    [{"roomid":5,"packetid":158983,"userno":"steven2","username":"","packetamount":200.00,"packettag":"5","wagertime":"2019-08-24 12:03:31"},{"roomid":5,"packetid":158984,"userno":"steven2","username":"","packetamount":2006.00,"packettag":"2","wagertime":"2019-08-24 12:03:48"}]

  }

  func websocketDidReceiveData(socket: WebSocketClient, data: Data) {
    print("websocketDidReceiveData")

  }
}

extension RoomDetailViewController: GrabEnvelopPopupDelegate {
  func closePopup() {

  }

  func openPackageInfo(package: PackageInfoModel?, roomid: Int, packageid: Int64) {

    if let `package` = package, let userno = RedEnvelopComponent.shared.userno {
      let isbiggest = package.isGrabBiggest(userno: userno)
      let isBoomed = package.getStatus(userno: userno)
      if let saved = LocalDataManager.shared.savePackage(userno: userno, packageid: packageid, status: isBoomed, isbiggest: isbiggest) {
        openPackages.append(saved)
        updateCellAsOpened(packageid: packageid)
        updateNotifyView()
      }
    }

    //    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
    let infoVc = PackageInfoViewController(model: package, roomid: roomid, packageid: packageid)
     infoVc.didPressedCreateEnvelop = { [weak self] in
        self?.showCreatePackage()
    }
    
    self.present(infoVc, animated: true, completion: nil)
    //    }
  }


}

extension RoomDetailViewController {
  fileprivate func updateNotifyView() {
//    var availableGrab = 0
//    for model in histories{
//      if !model.isExpire() && model.viewed == false {
//        availableGrab += 1
//      }
//
//    }
    let availablePackages = histories.filter{!$0.viewed}
    let newPackages = availablePackages.filter{!$0.isExpire()}
//    let notOpenPackage = availableGrab - openPackages.count

    notifyLabel.text = "\(newPackages.count)"
    notifyView.isHidden = newPackages.count <= 0

    print("updateNotifyView \(availablePackages.count) -- \(newPackages.count)")
    //    }
  }

  fileprivate func updateViewedStatus() {
    if tableView.contentOffset.y >= (tableView.contentSize.height - tableView.frame.size.height) {
      //you reached end of the table
      for model in histories{
        model.viewed = true
      }
    }
      updateNotifyView()

  }
}

extension RoomDetailViewController: UIScrollViewDelegate {
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    if scrollView == tableView {
      updateViewedStatus()
    }
  }

  func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
    if !decelerate{

      if scrollView == tableView {
        updateViewedStatus()
      }
    }
  }
}






