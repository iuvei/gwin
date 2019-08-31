//
//  BullDetailViewController.swift
//  Gwin
//
//  Created by Hai Vu Van on 8/29/19.
//  Copyright © 2019 Hai Vu Van. All rights reserved.
//

import UIKit
import CoreData
import SwiftyJSON

class BullDetailViewController: UIViewController {

  enum Constants {
    static let historyItemWidth: CGFloat = 35
  }

  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var marqueView: UILabel!
  @IBOutlet weak var rollMsgMarqueeView: UIWebView!

  @IBOutlet weak var roundHistoryStackView: UIView!

  @IBOutlet weak var historyViewWidthConstraint: NSLayoutConstraint!
  @IBOutlet weak var plusButton: UIButton!
  @IBOutlet weak var action1Button: UIButton!
  @IBOutlet weak var action2Button: UIButton!
  @IBOutlet weak var action3Button: UIButton!
  @IBOutlet weak var action4Button: UIButton!
  @IBOutlet weak var bankerStackView: UIStackView!

  @IBOutlet weak var subgameStackView: UIStackView!
  @IBOutlet weak var bottomBottomConstraint: NSLayoutConstraint!

  @IBOutlet weak var bottomHeightConstraint: NSLayoutConstraint!
  private var userno: String
  private var room: RoomModel
  private var round: BullRoundModel?

  private var histories: [BullPackageHistoryModel] = []
  private var openPackages: [NSManagedObject] = []
  var coundownBet: TimeInterval = 0
  private var timer: Timer?
  private var roundTimmer: Timer?
  private var wagerTimer: Timer?
  private var idno: Int = 0

  private var wagerInfo: [Int64: [BullWagerInfoModel]] = [:]
  init(userno: String, room: RoomModel) {
    self.room = room
    self.userno = userno
    super.init(nibName: "BullDetailViewController", bundle: nil)
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    // Do any additional setup after loading the view.


    setupViews()
    fetchBullRound()
    getBullRollMessage()
  }

  func setupViews() {

    setupTableView()
    setupBottomView()
    setupBankerGetView()
  }

  func setupTableView() {
    tableView.register(UINib(nibName: "PackageHistoryRightViewCell", bundle: nil), forCellReuseIdentifier: "PackageHistoryRightViewCell")
    tableView.register(UINib(nibName: "PackageHistoryLeftViewCell", bundle: nil), forCellReuseIdentifier: "PackageHistoryLeftViewCell")
    tableView.separatorStyle = .none
    tableView.delegate = self
    tableView.dataSource = self
  }

  func setupBottomView() {
    action1Button.centerVertically()
    action1Button.imageView?.contentMode = .scaleAspectFit
    //
    action2Button.centerVertically()
    action2Button.imageView?.contentMode = .scaleAspectFit
    //
    action3Button.centerVertically()
    action3Button.imageView?.contentMode = .scaleAspectFit
    //
    action4Button.imageView?.contentMode = .scaleAspectFit
    action4Button.centerVertically()

    action4Button.isHidden = !room.niuallowchangebanker
  }

  func setupBankerGetView() {
    let row1 = UIStackView()
    row1.axis = .horizontal
    row1.distribution = .fillEqually
    row1.spacing = 1
    for i in 0 ..< 4 {
      let label = UILabel().forAutolayout()
      label.text = "\(i)"
      label.textAlignment = .center
      label.backgroundColor = .groupTableViewBackground
      label.tag = (1 + i)
      row1.addArrangedSubview(label)
    }
    bankerStackView.addArrangedSubview(row1)

    //
    let row2 = UIStackView()
    row2.axis = .horizontal
    row2.distribution = .fillEqually
    row2.spacing = 1
    for i in 0 ..< 4 {
      let label = UILabel().forAutolayout()
      label.text = "\(i)"
      label.textAlignment = .center
      label.backgroundColor = .groupTableViewBackground
      label.textColor = UIColor(hexString:"e75f48")
      label.tag = 4 + (i + 1)
      row2.addArrangedSubview(label)
    }
    bankerStackView.addArrangedSubview(row2)
    //
    let seperateView = UIView().forAutolayout()
    bankerStackView.addArrangedSubview(seperateView)
    //
    let row3 = UIStackView()
    row3.axis = .horizontal
    row3.distribution = .fillEqually
    row3.spacing = 1
    for i in 0 ..< 4 {
      let label = UILabel().forAutolayout()
      label.text = "\(i)"
      label.textAlignment = .center
      label.backgroundColor = .groupTableViewBackground
      label.tag = 8 + (i + 1)

      row3.addArrangedSubview(label)
    }
    bankerStackView.addArrangedSubview(row3)
    //
    let row4 = UIStackView()
    row4.axis = .horizontal
    row4.distribution = .fillEqually
    row4.spacing = 1
    for i in 0 ..< 4 {
      let label = UILabel().forAutolayout()
      label.text = "\(i)"
      label.textAlignment = .center
      label.backgroundColor = .groupTableViewBackground
      label.textColor = UIColor(hexString:"e75f48")
      label.tag = 12 + (i + 1)
      row4.addArrangedSubview(label)
    }
    bankerStackView.addArrangedSubview(row4)

    NSLayoutConstraint.activate([
      seperateView.heightAnchor.constraint(equalToConstant: 1)
      ])
  }


  func bindDataToBankerView(round: BullRoundModel) {
    for row in self.bankerStackView.subviews {
      if row is UIStackView {
        for view in row.subviews {
          if view is UILabel {
            print("label \(view.tag)")
            if let label = view as? UILabel{
              let tag = label.tag
              if tag == 5{
                label.text = round.banker
              }else if  tag == 6{
                label.text = round.lockquota
              }else if tag == 8{
                label.text = "\(round.bankqty)"
              }else if tag == 13{
                label.text = round.nextbanker
              }else if tag == 7 {
                label.text = "\(round.stake1)-\(round.state2)"
              }else if tag == 16{
                label.text = "\(round.bankround)/\(round.remainround)"
              }
            }
          }
        }
      }
    }
  }

  func fetchBullRound(){
    guard let user = RedEnvelopComponent.shared.user else { return }

    BullAPIClient.round(ticket: user.ticket, roomid: room.roomId) { [weak self] (round, error) in

      guard let this = self else {return}
      this.round = round

      if let `round` = round {
        this.coundownBet = (round.endtime.timeIntervalSinceNow - round.currtime.timeIntervalSinceNow);
        print("\(round.endtime.timeIntervalSinceNow) - \(round.currtime.timeIntervalSinceNow)")
        print("countdownbet \(this.coundownBet)")
        let countDownGrab = (round.winningtime.timeIntervalSinceNow - round.currtime.timeIntervalSinceNow);
        let countDownRound = (round.nextopentime.timeIntervalSinceNow - round.currtime.timeIntervalSinceNow);
        this.bindDataToBankerView(round: round)
        let marquee = "期数\(round.roundid) 下注时间\(this.coundownBet)秒  抢包时间\(countDownGrab)秒 新一轮开始\(countDownRound)秒"
        this.marqueView.text = marquee
        this.fetchBullHistory(roundid: round.roundid)
        this.fetchBanker(ticket: user.ticket,roomid: this.room.roomId, roundid: round.roundid)
        this.fetchPackageHistory()
        this.doCounDown()
        //
        if round.status == 2 {
          //add your package
          this.cancelWagerTimer()
        }else if round.status == 1 {
          //get wagerinfo

          this.wagerInfoTimer(idno: this.idno)


        } else if round.status == 0 {
          //remove your package
          this.cancelWagerTimer()
          this.tableView.reloadData()
        } else if round.status == 3 {
          //get wagerInfo
          print("roundstatus 3")
          this.wagerInfoTimer(idno: 0)

        }
      }
    }
  }

  func fetchBullHistory(roundid: Int64) {
    guard let user = RedEnvelopComponent.shared.user else { return }
    BullAPIClient.history(ticket: user.ticket, roomid: room.roomId, roundid: roundid, pagesize: 50) { [weak self] (histories, error) in
      print("bullhistory \(histories.count)")
      guard let this = self else {return}
      let itemWidth: CGFloat = Constants.historyItemWidth
      var leftMargin: CGFloat = 0
      var index: Int = 0
      for history in histories {
        leftMargin = (itemWidth + 5) * CGFloat(index)
        let itemView = this.getHistoryItemView(model: history)

        this.roundHistoryStackView.addSubview(itemView)
        NSLayoutConstraint.activate([
          itemView.widthAnchor.constraint(equalToConstant: itemWidth),
          itemView.heightAnchor.constraint(equalToConstant: Constants.historyItemWidth + 15),
          itemView.centerYAnchor.constraint(equalTo: this.roundHistoryStackView.centerYAnchor),
          itemView.leftAnchor.constraint(equalTo: this.roundHistoryStackView.leftAnchor, constant: leftMargin)
          ])
        index += 1
        if leftMargin >= UIScreen.main.bounds.width {
          this.historyViewWidthConstraint.constant = leftMargin + itemWidth + UIScreen.main.bounds.width
        }

      }
    }
  }

  func fetchPackageHistory() {
    if histories.count > 0 { return }
    guard let user = RedEnvelopComponent.shared.user else { return }
    guard let `round` = round else { return }

    BullAPIClient.packethistory(ticket: user.ticket, roomid: room.roomId, roundid: round.roundid, topnum: 50) { (histoires, error) in

      self.histories = histoires
      if let new  = self.createDumpPackage(round: round){
        self.histories.append(new)
      }
      self.tableView.reloadData()

    }
  }

  func fetchBanker(ticket: String, roomid: Int, roundid: Int64) {
    BullAPIClient.banker_get(ticket: ticket, roomid: roomid, roundi: roundid, pagesize: 20) { (bankers, erorr) in

    }
  }

  func getBullRollMessage() {
    guard let user = RedEnvelopComponent.shared.user else { return }
    BullAPIClient.getbullRollMessage(ticket: user.ticket) {[weak self] (rollmsg) in
      let marquee = "<html><body><font size=\"2\" face=\"sans-serif\"> <marquee>\(rollmsg ?? "")</marquee></font></body></html>"
      self?.rollMsgMarqueeView.loadHTMLString(marquee, baseURL: nil)

    }
  }

  func wagerInfoTimer(idno: Int) {

    wagerTimer = Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(fetchWagerInfo(_:)), userInfo: ["idno": idno], repeats: true)
  }

  func cancelWagerTimer() {
    wagerTimer?.invalidate()
    wagerTimer = nil
  }

  @objc func fetchWagerInfo(_ timer: Timer) {
    guard let user = RedEnvelopComponent.shared.user else { return }
    guard let `round` = round else { return }

    guard let userInfo = timer.userInfo as? [String: Int] else { return }
    guard let _idno = userInfo["idno"] else { return }

    BullAPIClient.wagerinfo(ticket: user.ticket, roomid: room.roomId, roundid: round.roundid, idno: _idno) { [weak self](infos, error) in

      print("wagerInfo \(infos.count)")
      if let info = infos.last {
        self?.idno = info.idno
      }
      if let last = self?.histories.last, infos.count > 0{
        if round.status == 1 {

          last.wagerInfo = infos
          self?.tableView.reloadData()
        }else if round.status == 3{
          last.resultWagerInfo = infos
          self?.tableView.reloadData()
        }
      }

      self?.wagerInfo[round.roundid] = infos
    }
  }

  func getHistoryItemView(model: BullHistoryModel) -> UIView{
    let view = UIView().forAutolayout()

    let button = UIButton().forAutolayout()
    button.rounded(radius: Constants.historyItemWidth / 2)
    button.backgroundColor = .red
    button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
    let label = UILabel().forAutolayout()
    label.textAlignment = .center
    label.font = UIFont.systemFont(ofSize: 10)
    view.addSubview(button)
    view.addSubview(label)

    NSLayoutConstraint.activate([
      button.topAnchor.constraint(equalTo: view.topAnchor),
      button.widthAnchor.constraint(equalToConstant: Constants.historyItemWidth),
      button.heightAnchor.constraint(equalToConstant: Constants.historyItemWidth),
      button.centerXAnchor.constraint(equalTo: view.centerXAnchor),

      label.topAnchor.constraint(equalTo: button.bottomAnchor),
      label.bottomAnchor.constraint(equalTo: view.bottomAnchor),
      label.leftAnchor.constraint(equalTo: view.leftAnchor),
      label.rightAnchor.constraint(equalTo: view.rightAnchor)
      ])

    button.setTitle(model.packettag, for: .normal)
    label.text = String("\(model.roundid)".suffix(4))
    return view
  }
  /*
   // MARK: - Navigation

   // In a storyboard-based application, you will often want to do a little preparation before navigation
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
   // Get the new view controller using segue.destination.
   // Pass the selected object to the new view controller.
   }
   */

  @IBAction func plusPressed(_ sender: Any) {
    plusButton.isSelected = !plusButton.isSelected
    if plusButton.isSelected {
      bottomBottomConstraint.constant = bottomHeightConstraint.constant - 30

    }else {
      bottomBottomConstraint.constant = 0

    }
  }

  @IBAction func bullSubgamePressed(_ sender: UIButton) {
    let tag = sender.tag
    if tag == 1{
      if let round = self.round {
        let vc = BetBullViewController(room: room, round: round, delegate: self)
        present(vc, animated: true, completion: nil)
      }
    } else  if tag == 2 {
      if let round = round{
        let vc = BetCasinoViewController(room: room, roundid: round.roundid, wagertypeno: Wagertypeno.casino.rawValue)
        present(vc, animated: true, completion: nil)
      }
    } else  if tag == 3 {
      if let round = self.round {
        let vc = BetCasinoViewController(room: room, roundid: round.roundid, wagertypeno: Wagertypeno.other.rawValue)
        present(vc, animated: true, completion: nil)
      }
    } else  if tag == 4 {

      let vc = GrabBankerViewController(room: room)
      present(vc, animated: true, completion: nil)
    }


  }


}

extension BullDetailViewController{
  fileprivate func doCounDown() {

    timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateBullSubView), userInfo: nil, repeats: true)
  }

  @objc func updateBullSubView() {
    coundownBet = coundownBet - 1
    subgameStackView.isHidden = coundownBet <= 0
    if coundownBet <= 0 {

      fetchBullRound()
      timer?.invalidate()
      timer = nil
    }
  }

}
extension BullDetailViewController {

  fileprivate func createDumpPackage(round: BullRoundModel)  -> BullPackageHistoryModel?{


      var dict:[String: Any] = [:]
      dict["roundid"] = round.roundid
      dict["userno"] = "Bull"
      dict["wagertime"] = round.winningtime

      if let json = JSON(rawValue: dict) {
        return BullPackageHistoryModel(json: json)
      }

    return nil
    }



  //  fileprivate func fetchOpenPackages() {
  //    if let userno = RedEnvelopComponent.shared.userno {
  //      openPackages = LocalDataManager.shared.fetchPackages(userno: userno)
  //    }
  //  }

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
}
extension BullDetailViewController: UITableViewDelegate, UITableViewDataSource {

  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 165
  }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    print("table count \(histories.count)")
    return histories.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

    let model = histories[indexPath.row]
    //    let isOpen = false//isOpenPackage(packageid: model.packetid)
    //    let isBoom = false//isBoomed(packageid: model.packetid)
    //    let isKing = false//isBiggest(packageid: model.packetid)
    //    let isExpired = false//isPackageExpeire(wagertime: model.wagertime)
    //
    print("model : \(model.packetamount)")
    if userno != model.userno {
      if let cell =  tableView.dequeueReusableCell(withIdentifier: "PackageHistoryLeftViewCell", for: indexPath) as? PackageHistoryLeftViewCell {
        cell.selectionStyle = .none
        cell.updateBullViews(model: model)
        return cell
      }
    } else {
      if let cell =  tableView.dequeueReusableCell(withIdentifier: "PackageHistoryRightViewCell", for: indexPath) as? PackageHistoryRightViewCell {
        cell.selectionStyle = .none
        cell.updateBullViews(model: model)
        return cell
      }
    }

    return UITableViewCell()
  }

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let model = histories[indexPath.row]

    let vc = GrabBullPackageViewController(history: model, room: room)
    vc.modalPresentationStyle = .overCurrentContext
    present(vc, animated: true, completion: nil)
  }
}



// MARK: - WebSocketDelegate
//extension BullDetailViewController {
//  func getGameData(){
//    guard let user = RedEnvelopComponent.shared.user else { return}
//    let jsonString = "{\"action\": \"roompushdata\",\"ticket\": \"\(user.ticket)\",\"data\": { \"roomid\": \(room.roomId)  ,\"packetid\": 0}}"
//
//
//    sendMessage(jsonString)
//  }
//
//  fileprivate func sendMessage(_ message: String) {
//    socket.write(string: message)
//  }
//
//  fileprivate func messageReceived(_ message: String, senderName: String) {
//    print("messageReceived")
//  }
//
//}
//extension BullDetailViewController: WebSocketDelegate {
//  func websocketDidConnect(socket: WebSocketClient) {
//
//    print("websocketDidConnect")
//    getGameData()
//  }
//
//  func websocketDidDisconnect(socket: WebSocketClient, error: Error?) {
//    print("websocketDidDisconnect")
//
//  }
//
//  func websocketDidReceiveMessage(socket: WebSocketClient, text: String) {
//    print("websocketDidReceiveMessage \(text)")
//
//    let json = JSON(parseJSON: text).arrayValue
//
//    var usernos: [String] = []
//    for packageJson in json {
//      let package = PackageHistoryModel(json: packageJson)
//      histories.append(package)
//      if ImageManager.shared.getImage(userno: package.userno) == nil {
//        usernos.append(package.userno)
//      }
//    }
//
//    ImageManager.shared.downloadImage(usernos: usernos) { [weak self ] in
//      DispatchQueue.main.async {
//        self?.tableView.reloadData()
//      }
//    }
//    //
//    DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
//      //self?.updateNotifyView()
//    }
//
//    tableView.reloadData()
//    //    [{"roomid":5,"packetid":158983,"userno":"steven2","username":"","packetamount":200.00,"packettag":"5","wagertime":"2019-08-24 12:03:31"},{"roomid":5,"packetid":158984,"userno":"steven2","username":"","packetamount":2006.00,"packettag":"2","wagertime":"2019-08-24 12:03:48"}]
//
//  }
//
//  func websocketDidReceiveData(socket: WebSocketClient, data: Data) {
//    print("websocketDidReceiveData")
//
//  }
//}

extension BullDetailViewController: BetBullDelegate {
  func betSuccessFull() {
    if let `round` = round {
      var dict:[String: Any] = [:]
      dict["roundid"] = round.roundid
      dict["userno"] = "Bull"
      dict["wagertime"] = round.winningtime

      if let json = JSON(rawValue: dict) {
        let newPackage = BullPackageHistoryModel(json: json)

        histories.append(newPackage)
        tableView.reloadData()
        print("Abc")
      }
    }
  }
}

