//
//  BetCasinoViewController.swift
//  Gwin
//
//  Created by Hai Vu Van on 8/30/19.
//  Copyright © 2019 Hai Vu Van. All rights reserved.
//

import UIKit

enum Wagertypeno: Int {
  case casino = 2
  case other = 3
}

class BetCasinoViewController: BaseViewController {

  enum Constants {
    static let otherBetMaxItem: Int = 9
    static let cellHeight: CGFloat = 30
    static let otherBetName: [String] =  ["牛1- 牛5",
    "牛6-牛牛",
   " 牛1/3/5/7/9",
    "牛2/4/6/8/牛牛",
    "牛1/3/5",
    "牛7/9",
    "牛2/4",
    "牛6/8/牛牛",
    "金牛- 豹子"]
    static let otherBetObjectName:[String] = ["小",
      "大",
      "单",
      "双",
      "小单",
      "大单",
      "小双",
      "大双",
      "合"]

  }
  @IBOutlet weak var backButton: UIButton!

  @IBOutlet weak var topBetButton: UIButton!
  @IBOutlet weak var betButton: UIButton!
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var rightTableView: UITableView!

  @IBOutlet weak var tableScrollView: UIScrollView!
  @IBOutlet weak var leftTabButton: UIButton!
  @IBOutlet weak var rightTabButton: UIButton!

  @IBOutlet weak var inputLabel: UILabel!

  @IBOutlet weak var tableHeightConstraint: NSLayoutConstraint!

  var currentTab: CurrentTab = .left

  private var  room: RoomModel
  private var bullround: BullRoundModel
  var wagerOdds: [BullWagerOddModel] = []

  var oddNames: [String] = []
  var wagertypeno: Int
  //  var selectedIndex: [Int] = []
  var currentMoney: Float = 0.0
  var midleIndex: Int = Constants.otherBetMaxItem

  init(room: RoomModel, round: BullRoundModel, wagertypeno: Int) {
    self.room = room
    self.bullround = round
    self.wagertypeno = wagertypeno
    super.init(nibName: "BetCasinoViewController", bundle: nil)
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    if wagertypeno == Wagertypeno.casino.rawValue {
      setTitle(title: "牛牛百家乐下注")
    }else if wagertypeno == Wagertypeno.other.rawValue {
      setTitle(title: "大小单双合下注 ")
    }
    // Do any additional setup after loading the view.

    setupViews()
    loadWaggerOddNames()
    fetchwagerodds()
  }

  func setupViews() {
    if wagertypeno == Wagertypeno.casino.rawValue {
      tableView.register(UINib(nibName: "WagerOddViewCell", bundle: nil), forCellReuseIdentifier: "WagerOddViewCell")
      rightTableView.register(UINib(nibName: "WagerOddViewCell", bundle: nil), forCellReuseIdentifier: "WagerOddViewCell")

      tableScrollView.isScrollEnabled = false
      rightTabButton.setTitle("\(bullround.stake1)-\(bullround.state2) \(AppText.currency)", for: .normal)
    }else if wagertypeno == Wagertypeno.other.rawValue {
      tableView.register(UINib(nibName: "BetOtherViewCell", bundle: nil), forCellReuseIdentifier: "BetOtherViewCell")
      rightTableView.register(UINib(nibName: "BetOtherViewCell", bundle: nil), forCellReuseIdentifier: "BetOtherViewCell")
      tableScrollView.isScrollEnabled = true
      tableScrollView.isPagingEnabled = true
      leftTabButton.addBottomBorderWithColor(color: AppColors.tabbarColor, width: 2)
      leftTabButton.setTitle("庄", for: .normal)
      rightTabButton.setTitle("闲", for: .normal)
    }

    tableView.delegate = self
    tableView.dataSource = self
    tableView.alwaysBounceVertical = false

    rightTableView.delegate = self
    rightTableView.dataSource = self
    rightTableView.alwaysBounceVertical = false
    //
    inputLabel.rounded()
    betButton.rounded()
    topBetButton.rounded(borderColor: AppColors.titleColor, borderwidth: 1)

    //
    backButton.addTarget(self, action: #selector(backPressed(_:)), for: .touchUpInside)
  }

  /*
   // MARK: - Navigation

   // In a storyboard-based application, you will often want to do a little preparation before navigation
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
   // Get the new view controller using segue.destination.
   // Pass the selected object to the new view controller.
   }
   */

  func loadWaggerOddNames() {
    if let path = Bundle.main.path(forResource: "WagerOdds", ofType: "json") {
      do {
        let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
        if let string = String(data: data, encoding: .utf8) {
          var formatedString = string.replacingOccurrences(of: "\r\n ", with: "")
          formatedString = formatedString.replacingOccurrences(of: "\r\n", with: "")
          oddNames = formatedString.components(separatedBy: ",")
        }
      } catch {
        print("Abcdef")
      }
    }
  }

  func getOddNames(model: BullWagerOddModel) -> String? {
    for str in oddNames {
      let values = str.components(separatedBy: "  ")
      if values[1] == "\(model.wagertypeno)" && values[2] == "\(model.objectid)" {
        return values.last
      }
    }

    return nil
  }

  func fetchwagerodds() {
    guard let user = RedEnvelopComponent.shared.user else { return }

    BullAPIClient.wagerodds(ticket: user.ticket, roomtype: 2) { [weak self](wagerodds, error) in
      guard let this = self else { return }
      if this.wagertypeno == Wagertypeno.casino.rawValue {
        this.wagerOdds = wagerodds.filter{$0.wagertypeno == this.wagertypeno}
        for odd in this.wagerOdds {
          odd.name = this.getOddNames(model: odd)
        }
        this.tableView.reloadData()
        this.tableHeightConstraint.constant = Constants.cellHeight * CGFloat(min(this.wagerOdds.count,10))
      }else if this.wagertypeno == Wagertypeno.other.rawValue {
        let total = wagerodds.filter{$0.wagertypeno == this.wagertypeno}
        var midelIndex =  total.count / 2
        midelIndex =  midelIndex > Constants.otherBetMaxItem ? Constants.otherBetMaxItem : midelIndex


        this.wagerOdds = Array(total[0..<midelIndex*2])

        //map 
        for  i in 0 ..< this.wagerOdds.count {
          let odd = this.wagerOdds[i]
          odd.name =  Constants.otherBetName[i % midelIndex]
          odd.objectName = Constants.otherBetObjectName[i % midelIndex]
          odd.testId = i
        }

        this.tableView.reloadData()
        this.rightTableView.reloadData()
        this.tableHeightConstraint.constant = Constants.cellHeight * CGFloat(this.midleIndex)
      }

    }
  }

  func betCasino(){
    guard let user = RedEnvelopComponent.shared.user else { return }

    var waggers = ""

    for model in wagerOdds {
      if model.selected{
        let x = "\(model.wagertypeno):\(model.objectid):\(Int(model.money))"
        waggers = "\(waggers) \(x);"
      }
    }

    showLoadingView()
    BullAPIClient.betting(ticket: user.ticket, roomid: room.roomId, roundid: bullround.roundid, wagers: waggers){ [weak self](success, error) in
      guard let this = self else { return }
      this.hideLoadingView()
      if success {
        this.dismiss(animated: true, completion: nil)
      } else {
        if let message = error {
          this.showAlertMessage(message: message)
        }
      }

    }

  }


  func reloadCell(at indexPath: IndexPath) {
    if wagertypeno == Wagertypeno.casino.rawValue {
      let model = wagerOdds[indexPath.row]

      if let cell = tableView.cellForRow(at: indexPath) as? WagerOddViewCell{
        cell.updateView(model: model, selected: model.selected, max: bullround.state2)
      }
    }else if wagertypeno == Wagertypeno.other.rawValue {
      if currentTab == .left {
        let model = wagerOdds[indexPath.row]
        if let cell = tableView.cellForRow(at: indexPath) as? BetOtherViewCell{
          cell.updateView(model: model, selected: model.selected, max: bullround.state2)
        }
      }else if currentTab == .right {
        let model = wagerOdds[indexPath.row + midleIndex]

        if let cell = rightTableView.cellForRow(at: indexPath) as? BetOtherViewCell{
          cell.updateView(model: model, selected: model.selected, max: bullround.state2)
        }
      }
    }
  }

  func scrollTo(page index: Int) {
    let positionX = CGFloat(index) * UIScreen.main.bounds.width
    tableScrollView.setContentOffset(CGPoint(x: positionX, y: 0), animated: true)
  }

  @IBAction func betPressed(_ sender: Any) {
    betCasino()
  }

  @IBAction func tabPressed(_ sender: UIButton) {
    if wagertypeno == Wagertypeno.other.rawValue {

      let tag = sender.tag
      didSelectTab(at: tag)
    }
  }

  override func backPressed(_ sender: UIButton) {
    dismiss(animated: true, completion: nil)
  }

}

extension BetCasinoViewController{
  fileprivate func updateInputValue() {
    var totalValue: Float = 0.0
    for model in wagerOdds {

      totalValue += model.money
    }

    inputLabel.text = String(format: "¥ %.2f", totalValue)
  }
}

//MARK - TableViewDelegate
extension BetCasinoViewController: UITableViewDelegate, UITableViewDataSource {

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if wagertypeno == Wagertypeno.casino.rawValue {
      return wagerOdds.count
    }else if wagertypeno == Wagertypeno.other.rawValue {
      return wagerOdds.count / 2
    }
    return 0
  }

  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return Constants.cellHeight
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

    if wagertypeno == Wagertypeno.casino.rawValue {
      let model = wagerOdds[indexPath.row]
      if let cell = tableView.dequeueReusableCell(withIdentifier: "WagerOddViewCell", for: indexPath) as? WagerOddViewCell {

        cell.updateView(model: model, selected: model.selected, max: bullround.state2)
        cell.didMoneyChanged = {[weak self ]money in
          model.money = money
          self?.updateInputValue()
          if money > 0 {
            model.selected = true
            self?.reloadCell(at: indexPath)
          }else if money == 0{
            model.selected = false
            self?.reloadCell(at: indexPath)
          }

        }
        return cell
      }
    } else if wagertypeno == Wagertypeno.other.rawValue {
      let index = indexPath.row + (tableView == self.tableView ? 0 : midleIndex)
      let model: BullWagerOddModel = wagerOdds[index]

      if let cell = tableView.dequeueReusableCell(withIdentifier: "BetOtherViewCell", for: indexPath) as? BetOtherViewCell {
        cell.updateView(model: model, selected: model.selected, max: bullround.state2)

        cell.didMoneyChanged = {[weak self ]money in
          model.money = money
          self?.wagerOdds[index].money = money

          self?.updateInputValue()
          if money > 0 {
            self?.wagerOdds[index].selected = true

            self?.reloadCell(at: indexPath)
          }else if money == 0{
            self?.wagerOdds[index].selected = false
            self?.reloadCell(at: indexPath)
          }

        }
        return cell
      }
    }
    return UITableViewCell()
  }

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    //   let model = wagerOdds[indexPath.row]
    //
    //    model.selected = !model.selected
    //    reloadCell(at: indexPath)
  }
}

extension BetCasinoViewController {

  fileprivate func  didSelectTab(at index: Int) {
    if index == 1 {
      currentTab = .left
      tableScrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
      leftTabButton.addBottomBorderWithColor(color: AppColors.tabbarColor, width: 2)
      rightTabButton.addBottomBorderWithColor(color: .clear, width: 0)
//      rightTableView.reloadData()
    }else if (index == 2) {
      currentTab = .right
      tableScrollView.setContentOffset(CGPoint(x: UIScreen.main.bounds.width, y: 0), animated: true)
      leftTabButton.addBottomBorderWithColor(color: .clear, width: 0)
      rightTabButton.addBottomBorderWithColor(color: AppColors.tabbarColor, width: 2)
//      tableView.reloadData()

    }
  }

  fileprivate func resetTableData(){
    for ood in wagerOdds {
      ood.money = 0
    }

    tableView.reloadData()
    rightTableView.reloadData()
  }

  fileprivate func didStopScroll(){
    let width = UIScreen.main.bounds.width
    if width > 0 {
      let pageIndex = round(tableScrollView.contentOffset.x/width)
      if pageIndex == 0 {
        didSelectTab(at: 1)
      }else if pageIndex == 1 {
        didSelectTab(at: 2)
      }
    }
  }
}

extension BetCasinoViewController: UIScrollViewDelegate {

  func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
    didStopScroll()
  }

  func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
    if !decelerate{
      didStopScroll()
    }
  }
}

