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

class BullDetailViewController: BaseViewController {

  enum Constants {
    static let historyItemWidth: CGFloat = 35
    static let bakerGetText:[String] = ["当前庄家","庄家金额","下注区间","连庄局数","","","","","连庄局数","庄家金额","下注区间","已抢局数"]
    static let bullUserno: String = "平台"
  }

  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var marqueView: UILabel!

  @IBOutlet weak var countdountBetLabel: UILabel!

  @IBOutlet weak var countdountGrabLabel: UILabel!
  @IBOutlet weak var rollMsgMarqueeView: UIWebView!
  @IBOutlet weak var countdownRoundLabel: UILabel!

  @IBOutlet weak var roundHistoryStackView: UIView!

  @IBOutlet weak var bankerCountLabel: UILabel!
  @IBOutlet weak var purchaseDetailLabel: UILabel!

  @IBOutlet weak var historyViewWidthConstraint: NSLayoutConstraint!

  @IBOutlet weak var bottomView: UIView!

  @IBOutlet weak var plusButton: UIButton!
  @IBOutlet weak var action1Button: UIButton!
  @IBOutlet weak var action2Button: UIButton!
  @IBOutlet weak var action3Button: UIButton!
  @IBOutlet weak var action4Button: UIButton!
  @IBOutlet weak var bankerStackView: UIStackView!

  @IBOutlet weak var subgameStackView: UIStackView!
  @IBOutlet weak var bottomBottomConstraint: NSLayoutConstraint!

  @IBOutlet weak var bottomHeightConstraint: NSLayoutConstraint!
  private lazy var bankerGetButton: UIButton = {
    let button = UIButton().forAutolayout()
    button.backgroundColor = UIColor.gray.withAlphaComponent(0.3)
    button.addTarget(self, action: #selector(bankgetGetPressed(_:)), for: .touchUpInside)
    return button
  }()

  private lazy var refreshControl:UIRefreshControl = {
    let view = UIRefreshControl()
    return view
  }()

  
  private var userno: String
  private var room: RoomModel
  private var round: BullRoundModel?
  private var datas: [BullModel] = []
  private var openPackages: [NSManagedObject] = []
  var coundownBet: Int = 0
  var countDownGrab: Int = 0
  var countDownRound: Int = 0
  var firsttime: Bool = true
  private var timer: Timer?
  private var roundTimmer: Timer?

  private var lastRound: BullRoundModel?
  //  private var systemTime: TimeInterval?
  private var wagerInfo: [Int64: [BullWagerInfoModel]] = [:]
  private var wagerOdds: [BullWagerOddModel] = []

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
    setTitle(title: "牛牛红包")
    setupViews()
    fetchOpenPackages()
    fetchBullRound()
    getBullRollMessage()
    fetchSystemTime()
    fetchwagerodds()
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    hideBottomView()
  }

  deinit {
    timer?.invalidate()
    timer = nil
    roundTimmer?.invalidate()
    roundTimmer = nil

  }

  func setupViews() {
    setupBullHistory()
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
    tableView.rowHeight = UITableView.automaticDimension
    tableView.estimatedRowHeight = 400
    if #available(iOS 10.0, *) {
      tableView.refreshControl = refreshControl
    } else {
      tableView.addSubview(refreshControl)
    }

    refreshControl.addTarget(self, action: #selector(refreshData(_:)), for: .valueChanged)
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
    let labelHeight: CGFloat = 17
    let rowCount: Int = 4
    let colCount: Int = 4
    for rowIndex in 0 ..< rowCount {
      let row1 = UIStackView()
      row1.axis = .horizontal
      row1.distribution = .fillEqually
      row1.spacing = 1
      for i in 0 ..< colCount {
        let label = UILabel().forAutolayout()
        if rowIndex % 2 == 0 {
          label.text = Constants.bakerGetText[i + rowIndex * colCount]
        }else{
          label.text = "\(i)"
        }

        label.textAlignment = .center
        label.backgroundColor = .groupTableViewBackground
        label.tag = rowIndex * colCount + (1 + i)
        label.font = UIFont.systemFont(ofSize: 12)
        row1.addArrangedSubview(label)
        if rowIndex % 2 == 1 {
          label.textColor = AppColors.tabbarColor
        }
        NSLayoutConstraint.activate([
          label.heightAnchor.constraint(equalToConstant: labelHeight)
          ])
      }
      bankerStackView.addArrangedSubview(row1)
      if rowIndex == 1 {
        let seperateView = UIView().forAutolayout()
        bankerStackView.addArrangedSubview(seperateView)
        NSLayoutConstraint.activate([
          seperateView.heightAnchor.constraint(equalToConstant: 1)
          ])
      }
    }

    bottomView.addSubview(bankerGetButton)

    NSLayoutConstraint.activate([
      bankerGetButton.rightAnchor.constraint(equalTo: bottomView.rightAnchor),
      bankerGetButton.bottomAnchor.constraint(equalTo: bankerStackView.bottomAnchor),
      bankerGetButton.heightAnchor.constraint(equalToConstant: labelHeight * 2),
      bankerGetButton.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width / 4)
      ])
  }


  func bindRoundDataViews(round: BullRoundModel) {
    //
    bankerCountLabel.text = "庄家点数走势图 第\(round.nextroundid)期"
    purchaseDetailLabel.text = "账单日期\(round.nextopentime.toString())"
    //
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

  func setupBullHistory() {
    let itemWidth: CGFloat = (UIScreen.main.bounds.width / 12)
    var leftMargin: CGFloat = 0
    for index in 0 ..< 12 {

      leftMargin = (itemWidth) * CGFloat(index)
      let itemView = getHistoryItemView(model: nil)

      roundHistoryStackView.addSubview(itemView)
      NSLayoutConstraint.activate([
        itemView.widthAnchor.constraint(equalToConstant: itemWidth),
        itemView.heightAnchor.constraint(equalTo: roundHistoryStackView.heightAnchor),
        itemView.centerYAnchor.constraint(equalTo: roundHistoryStackView.centerYAnchor),
        itemView.leftAnchor.constraint(equalTo: roundHistoryStackView.leftAnchor, constant: leftMargin)
        ])
    }
  }

  func fetchSystemTime() {
    guard let user = RedEnvelopComponent.shared.user else { return }

    UserAPIClient.systemtime(ticket: user.ticket) { (systemtime) in
      if let timer = systemtime {
        RedEnvelopComponent.shared.systemtime = timer.toDate()
        RedEnvelopComponent.shared.doTick()
        //        self.systemTime = timer.toDate().timeIntervalSinceNow
        //        self.tickTimer()
      }
    }
  }

  func fetchBullRound(){
    guard let user = RedEnvelopComponent.shared.user else { return }

    BullAPIClient.round(firsttime: firsttime, ticket: user.ticket, roomid: room.roomId) { [weak self] (round, error) in

      guard let this = self else {return}
      this.firsttime = false
      this.round = round

      if let `round` = round {
        this.coundownBet = Int((round.endtime.timeIntervalSinceNow - round.currtime.timeIntervalSinceNow));
        this.countDownGrab = Int((round.winningtime.timeIntervalSinceNow - round.currtime.timeIntervalSinceNow));
        this.countDownRound = Int((round.nextopentime.timeIntervalSinceNow - round.currtime.timeIntervalSinceNow));



        //
        this.bindRoundDataViews(round: round)

        this.fetchBullHistory(roundid: round.roundid)
        this.fetchBanker(ticket: user.ticket,roomid: this.room.roomId, roundid: round.roundid)
        this.fetchPackageHistory(roundid: round.roundid)
        this.doCounDown()
        //
        if round.status == 2 {
          //add your package
          //          this.cancelWagerTimer()

          if let index = this.getBullModel(roundid: round.roundid){
            let bull = this.datas[index]
            bull.cancelWagerTimer()
            bull.updateRoundStatus(status: .addNew)

            //            bull.fetchResultWagerInfo()
          }else {
            this.addNewBull(round: round)
          }

        }else if round.status == 1 {
          //get wagerinfo
          print("result 1 ------")
          //          this.wagerInfoTimer(roundid: round.roundid)
          if let index = this.getBullModel(roundid: round.roundid) {
            let bull = this.datas[index]
            bull.wagerInfoTimer()
          }else{
            this.addNewBull(round: round)
          }


        } else if round.status == 0 {
          //remove your package
          //          this.cancelWagerTimer()
          if let index = this.getBullModel(roundid: round.roundid) {
            let bull = this.datas[index]
            bull.updateRoundStatus(status: .betClose)
            //this.removePackage(at: index)
          }

        } else if round.status == 3 {
          //get wagerInfo
          print("result 3 ------")
          //          this.resultWagerInfoTimer()
          if let index = this.getBullModel(roundid: round.roundid) {
            let bull = this.datas[index]
            bull.resultWagerInfoTimer()
          }else {
            this.addNewBull(round: round)
          }
        }
      }
    }
  }

  func fetchBullHistory(roundid: Int64) {
    guard let user = RedEnvelopComponent.shared.user else { return }
    BullAPIClient.history(ticket: user.ticket, roomid: room.roomId, roundid: roundid, pagesize: 50) { [weak self] (histories, error) in
      guard let this = self else { return }
      for i in 0 ..< 12 {
        let subview = this.roundHistoryStackView.subviews[i]
        if i < histories.count {
          let history = histories[i]
          for item in subview.subviews {
            if let button  = item as? UIButton {
              button.setTitle(history.packettag, for: .normal)
            }else if let label = item as? UILabel {
              label.text = String("\(history.roundid)".suffix(4))
            }
          }
        }else {
          subview.isHidden = true
        }
      }
    }
  }

  func fetchPackageHistory(loadmore: Bool = false, roundid: Int64) {
    if datas.count > 0 && !loadmore { return }
    guard let user = RedEnvelopComponent.shared.user else { return }
    guard let `round` = round else { return }

    BullAPIClient.packethistory(ticket: user.ticket, roomid: room.roomId, roundid: roundid, topnum: 50) {[weak self] (histoires, error) in
      guard let this = self else { return }
      this.refreshControl.endRefreshing()
      if let copyRound = round.copy() as? BullRoundModel{
        copyRound.roundid = Int64.max
        let reverHistory = histoires.reversed().map{BullModel(expire: true, round: copyRound, historyPackage: $0, roomid: this.room.roomId)}
        if loadmore{
          if reverHistory.count > 0 {
            this.datas.insert(contentsOf: reverHistory, at: 0)
            this.tableView.reloadData()
          }
        }else {
          this.datas = reverHistory
          this.tableView.reloadData()
          this.tableView.scrollToBottom()
        }
      }

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


  func fetchwagerodds() {
    guard let user = RedEnvelopComponent.shared.user else { return }

    BullAPIClient.wagerodds(ticket: user.ticket, roomtype: 2) { [weak self](wagerodds, error) in
      guard let this = self else { return }
      this.wagerOdds = wagerodds
    }

  }

  func getHistoryItemView(model: BullHistoryModel?) -> UIView{
    let view = UIView().forAutolayout()

    let button = UIButton().forAutolayout()
    let imageWidth = (UIScreen.main.bounds.width / 12) - 8
    //    button.rounded(radius: imageWidth/2)
    button.setBackgroundImage(UIImage(named: "history_circle_bg"), for: .normal)
    button.titleLabel?.font = UIFont.systemFont(ofSize: 10)
    button.setTitleColor(UIColor(hexString: "333333"), for: .normal)

    let label = UILabel().forAutolayout()
    label.textAlignment = .center
    label.font = UIFont.systemFont(ofSize: 9)
    label.textColor = AppColors.titleColor
    view.addSubview(button)
    view.addSubview(label)

    NSLayoutConstraint.activate([
      button.topAnchor.constraint(equalTo: view.topAnchor),
      button.widthAnchor.constraint(equalToConstant: imageWidth),
      button.heightAnchor.constraint(equalToConstant: imageWidth),
      button.centerXAnchor.constraint(equalTo: view.centerXAnchor),

      label.topAnchor.constraint(equalTo: button.bottomAnchor),
      label.bottomAnchor.constraint(equalTo: view.bottomAnchor),
      label.leftAnchor.constraint(equalTo: view.leftAnchor),
      label.rightAnchor.constraint(equalTo: view.rightAnchor)
      ])

    button.setTitle(model?.packettag, for: .normal)
    if let roundid = model?.roundid{
      label.text = String("\(roundid)".suffix(4))
    }
    return view
  }

  func getBullModel(roundid: Int64) -> Int? {
    for i in 0 ..< datas.count {
      let bull = datas[i]
      if bull.round.roundid == roundid {
        return i
      }
    }
    return nil
  }

  func toggleBottomView() {
    if plusButton.isSelected {
      showBottomView()

    }else {
      hideBottomView()

    }
  }

  func showBottomView(){
    plusButton.isSelected = false
    bottomBottomConstraint.constant = 0
  }

  func hideBottomView(){
    plusButton.isSelected = true
    bottomBottomConstraint.constant = bottomHeightConstraint.constant - 30

  }

  @objc private func refreshData(_ sender: Any) {
    // Fetch Weather Data
    if let first = datas.first{
      fetchPackageHistory(loadmore: true, roundid: first.getRoundId())
    }else{
      refreshControl.endRefreshing()
    }
  }


  @objc func bankgetGetPressed(_ button: UIButton){
    guard let `round` = round else {return}
    let vc = BankerViewController(roomid: room.roomId, roundid: round.roundid)

    present(vc, animated: true, completion: nil)
  }

  @IBAction func plusPressed(_ sender: Any) {
    toggleBottomView()
  }

  @IBAction func bullSubgamePressed(_ sender: UIButton) {
    let tag = sender.tag
    if tag == 1{
      if let round = self.round {
        let vc = BetBullViewController(room: room, round: round, delegate: self, wagerOdds: wagerOdds)
        present(vc, animated: true, completion: nil)
      }
    } else  if tag == 2 {
      if let round = round{
        let vc = BetCasinoViewController(room: room, round: round, wagertypeno: Wagertypeno.casino.rawValue, wagerOdds: wagerOdds)
        present(vc, animated: true, completion: nil)
      }
    } else  if tag == 3 {
      if let round = self.round {
        let vc = BetCasinoViewController(room: room, round: round, wagertypeno: Wagertypeno.other.rawValue, wagerOdds: wagerOdds)
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

  fileprivate func tickTimer() {
    Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(doTick), userInfo: nil, repeats: true)
  }

  @objc fileprivate func doTick() {
    //    guard let _ = systemTime else { return }
    //      let old = systemTime!
    //      systemTime = systemTime! + 1
    //      let new = systemTime!
    //      let systemDate = Date(timeIntervalSinceNow: systemTime!)
    //      print("do tick \(systemDate.toString()) -> \(new - old)")
    //      print("do tick local \(Date().toString())")

  }

  @objc func updateBullSubView() {
    coundownBet = coundownBet - 1
    countDownGrab -= 1
    countDownRound -= 1

    if let `round` = round{
      marqueView.text = "期数\(round.roundid)"
    }
    countdountBetLabel.text = String(format: "下注时间%2d秒", coundownBet >= 0 ? coundownBet : 0)

    countdountGrabLabel.text = String(format: "抢包时间%2d秒", countDownGrab >= 0 ? countDownGrab : 0)

    countdownRoundLabel.text = String(format: " 新一轮开始%d秒",countDownRound >= 0 ? countDownRound : 0)

    subgameStackView.isHidden = coundownBet <= 0
    if coundownBet <= 0 {

      fetchBullRound()
      timer?.invalidate()
      timer = nil
    }

    if countDownRound <= 0 {
      //      setBullExpire()
      if let `round` = round, let index = getBullModel(roundid: round.roundid) {
        datas[index].expire = true
      }
    }
  }

  //  fileprivate func setBullExpire() {
  //    for bull in datas{
  //      if bull.round.roundid != round?.roundid {
  //          bull.expire = true
  //      }
  //    }
  //  }

}
extension BullDetailViewController {

  fileprivate func addNewBull(round: BullRoundModel){

    let newBull = BullModel(round: round, historyPackage: nil, roomid: room.roomId, delegate: self)
    if newBull.round.status == BullRoundStatus.betStart.rawValue {
      newBull.wagerInfoTimer()
    }else if newBull.round.status == BullRoundStatus.betResult.rawValue {
      newBull.resultWagerInfoTimer()
    }

    datas.append(newBull)
    tableView.beginUpdates()
    tableView.insertRows(at: [IndexPath(row: datas.count - 1, section: 0)], with: .none)
    tableView.endUpdates()
    tableView.scrollToBottom()
  }

  fileprivate func createDumpPackage(round: BullRoundModel)  -> BullModel{

    var package:BullPackageHistoryModel? = nil
    var dict:[String: Any] = [:]
    dict["roundid"] = round.roundid
    dict["userno"] = Constants.bullUserno
    dict["username"] = Constants.bullUserno
    dict["wagertime"] = round.winningtime.toString()//"\(Date().toString())"

    if let json = JSON(rawValue: dict) {
      package =  BullPackageHistoryModel(json: json)
    }

    return  BullModel(round: round, historyPackage: package, roomid: room.roomId, delegate: self)

  }



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

    //    let packageDate = wagertime.toDate()
    //    if let `systemtime` = systemTime {
    //      let timeinterval = systemtime - packageDate.timeIntervalSinceNow
    //      let mins = timeinterval / (60)
    //
    //      return mins > Double(RedEnvelopComponent.limitTime)
    //    }
    return false
  }


}

extension BullDetailViewController{

  fileprivate func removePackage(at index: Int) {

    datas.remove(at: index)

    let lastIndexPath = IndexPath(row: index, section: 0)
    tableView.beginUpdates()
    tableView.deleteRows(at: [lastIndexPath], with: .none)
    tableView.endUpdates()

  }

  private func updateCellAsOpened(rounid: Int64){
    if let index = getBullModel(roundid: rounid) {
      let indexPath = IndexPath(row: index, section: 0)
      tableView.beginUpdates()
      tableView.reloadRows(at: [indexPath], with: .none)
      tableView.endUpdates()
    }
  }
}
extension BullDetailViewController: UITableViewDelegate, UITableViewDataSource {

  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    let bull = datas[indexPath.row]
    return CGFloat(150 + bull.countWagerInfo() * 20)
  }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    print("table count \(datas.count)")
    return datas.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

    let bull = datas[indexPath.row]
    let isGrab = bull.isGrabed(openPackages)
    //    let isBoom = false//isBoomed(packageid: model.packetid)
    //    let isKing = false//isBiggest(packageid: model.packetid)
    //    let isExpired = false//isPackageExpeire(wagertime: model.wagertime)
    //

    if let cell =  tableView.dequeueReusableCell(withIdentifier: "PackageHistoryLeftViewCell", for: indexPath) as? PackageHistoryLeftViewCell {
      cell.selectionStyle = .none
      cell.updateBullViews(bull: bull, isOpen: isGrab)
      return cell
    }


    return UITableViewCell()
  }

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let bull = datas[indexPath.row]

    if bull.getRoundId() == round?.roundid  && coundownBet > 0{
      return
    }
    
    let isGrab = bull.isGrabed(openPackages)

    if isGrab{
      let infoVC = BulllPackageInfoViewController(bull: bull)
      present(infoVC, animated: true, completion: nil)
    }else{
      let vc = GrabBullPackageViewController(bull: bull)
      vc.modalPresentationStyle = .overCurrentContext
      vc.didGrabPackage = {  [weak self] grabbed in
        guard let this = self else { return }
        if let userno = RedEnvelopComponent.shared.userno {

          if let saved = LocalDataManager.shared.savePackage(userno: userno, packageid: bull.getRoundId()) {
            this.openPackages.append(saved)
            this.updateCellAsOpened(rounid: bull.getRoundId())
            //          updateNotifyView()
          }
        }
        //


        let infoVC = BulllPackageInfoViewController(bull: bull, grabedModel: grabbed)
        this.present(infoVC, animated: true, completion: nil)
      }

      vc.didViewPackageInfo = { [weak self] in
        guard let this = self else { return }
        //        let wagertime = model.wagertime.toDate().timeIntervalSinceNow


        //        let currentDate = Date(timeIntervalSinceNow: RedEnvelopComponent.shared.systemTimeInterval)
        //        let wagerDate = Date(timeIntervalSinceNow: wagertime)
        //        print("systimeTime : \(currentDate.toString()) -- wager: \(wagerDate.toString())")

        let infoVC = BulllPackageInfoViewController(bull: bull)
        this.present(infoVC, animated: true, completion: nil)
      }

      present(vc, animated: true, completion: nil)
    }
  }
}

extension BullDetailViewController: BullModelDelegate {
  func didGetWagerInfo(roundid: Int64, wagerInfos: [BullWagerInfoModel]) {
    if let index = getBullModel(roundid: roundid) {
      let bull = datas[index]
      bull.betWagerInfo = wagerInfos
      let indexPath = IndexPath(row: index, section: 0)
      tableView.beginUpdates()
      tableView.reloadRows(at: [indexPath], with: .none)
      tableView.endUpdates()
    }
  }

  func didGetResultWagerInfo(roundid: Int64, wagerInfos: [BullWagerInfoModel]) {
    if let index = getBullModel(roundid: roundid) {
      let bull = datas[index]
      bull.resultWagerInfo = wagerInfos
      let indexPath = IndexPath(row: index, section: 0)
      tableView.beginUpdates()
      tableView.reloadRows(at: [indexPath], with: .none)
      tableView.endUpdates()
    }
  }
}

extension BullDetailViewController: BetBullDelegate {
  func betSuccessFull() {

    if let `round` = round, getBullModel(roundid: round.roundid) == nil {
      addNewBull(round: round)
    }

    subgameStackView.isHidden = true
    hideBottomView()
  }
}




