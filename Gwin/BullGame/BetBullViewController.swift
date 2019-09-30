//
//  BetBullViewController.swift
//  Gwin
//
//  Created by Hai Vu Van on 8/29/19.
//  Copyright © 2019 Hai Vu Van. All rights reserved.
//

import UIKit
import SwiftyJSON

enum CurrentTab {
  case left
  case right
  case none
}

protocol BetBullDelegate: AnyObject {
  func didGrabBullPackage()
}

class BetBullViewController: BaseViewController {

  @IBOutlet weak var backButton: UIButton!
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var rightTableView: UITableView!
  @IBOutlet weak var okButton: UIButton!
  @IBOutlet weak var topBetButton: UIButton!
  
  @IBOutlet weak var stakeLabel: UILabel!

  @IBOutlet weak var moneyTextfield: UITextField!
  @IBOutlet weak var leftTabButton: UIButton!
  @IBOutlet weak var rightTabButton: UIButton!
  @IBOutlet weak var tableScrollView: UIScrollView!
  @IBOutlet weak var contentView: UIView!
  
  @IBOutlet weak var inputLabel: UILabel!
  var room: RoomModel
  var bullround: BullRoundModel
  var wagerOdds: [BullWagerOddModel] = []
  var rightWagerOdds: [BullWagerOddModel] = []

  var oddNames: [String] = []
//  var selectedIndex:[IndexPath] = []
  var currentTab: CurrentTab = .none
  private var delegate: BetBullDelegate?

  init(room: RoomModel, round: BullRoundModel, delegate: BetBullDelegate? = nil, wagerOdds: [BullWagerOddModel] = []){
    self.room = room
    self.bullround = round
    self.delegate = delegate
    self.wagerOdds = wagerOdds
    super.init(nibName: "BetBullViewController", bundle: nil)
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
        super.viewDidLoad()

    setTitle(title: "牛牛红包下注 ")
    setupViews()
    loadWaggerOddNames()
    fetchwagerodds()
    didSelectTab(at: 1)
        // Do any additional setup after loading the view.
    }


  func setupViews() {

    backButton.addTarget(self, action: #selector(backPressed(_:)), for: .touchUpInside)
    //
    tableView.register(UINib(nibName: "WagerOddViewCell", bundle: nil), forCellReuseIdentifier: "WagerOddViewCell")
    tableView.delegate = self
    tableView.dataSource = self
    tableView.alwaysBounceVertical = false
    //
    rightTableView.register(UINib(nibName: "WagerOddViewCell", bundle: nil), forCellReuseIdentifier: "WagerOddViewCell")
    rightTableView.delegate = self
    rightTableView.dataSource = self
    rightTableView.alwaysBounceVertical = false

    //
    tableScrollView.isPagingEnabled = true
    tableScrollView.delegate = self
    //

    moneyTextfield.delegate = self
    moneyTextfield.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    //
    stakeLabel.text = "\(bullround.stake1)-\(bullround.state2)元"

    //
    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tappedView(_:)))
    tapGesture.numberOfTapsRequired = 1
    tapGesture.numberOfTouchesRequired = 1
    contentView.addGestureRecognizer(tapGesture)

    //
    inputLabel.rounded()
    moneyTextfield.rounded()
    okButton.rounded()
    topBetButton.rounded(radius: 4, borderColor: AppColors.titleColor, borderwidth: 1)
    topBetButton.setTitleColor(AppColors.titleColor, for: .normal)
  }


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
    if wagerOdds.count > 0 {
      parseWagerOdds(odds:wagerOdds)
    }else{

      guard let user = RedEnvelopComponent.shared.user else { return }

      BullAPIClient.wagerodds(ticket: user.ticket, roomtype: 2) { [weak self](wagerodds, error) in
        guard let this = self else { return }
        this.parseWagerOdds(odds: wagerodds)
      }
    }
  }

  func parseWagerOdds(odds: [BullWagerOddModel]) {

    wagerOdds = odds.filter{$0.wagertypeno == 4}
    //      this.rightWagerOdds = wagerodds.filter{$0.wagertypeno == 4 && $0.objectid > 10}
    for odd in wagerOdds {
      odd.name = getOddNames(model: odd)
    }

    tableView.reloadData()
    rightTableView.reloadData()
  }

  func betBull(){
    if processing == true {
      return
    }
    processing = true

    guard let user = RedEnvelopComponent.shared.user else { return }

    var wagers = ""
    if currentTab == .none {
      if let money = moneyTextfield.text{
        wagers = "1:0:\(money)"
      }
    }else {

      var wagerArray:[String] = []
      for i in 0 ..< wagerOdds.count {
        let model = wagerOdds[i]
        if model.money > 0 {
          let x = "\(model.wagertypeno):\(model.objectid):\(Int(model.money))"
          wagerArray.append(x)
        }
      }
      wagers = wagerArray.joined(separator: ";")
    }

    showLoadingView()
    print("do bet \(room.roomId) -- \(bullround.roundid) -- \(wagers)")
    BullAPIClient.betting(ticket: user.ticket, roomid: room.roomId, roundid: bullround.roundid, wagers: wagers){ [weak self](success, error) in
      guard let this = self else { return }
      this.hideLoadingView()
      this.processing = false
      if success {
        this.delegate?.didGrabBullPackage()
        this.dismiss(animated: true, completion: nil)
      } else {
        if let message = error {
          print("do bet message \(message)")

          this.showAlertMessage(message: message)
        }
      }

    }

  }

  func selecteRowAtIndexPath(indexPath: IndexPath) {
//    var index:IndexPath?
//    for row in selectedIndex {
//      if row == indexPath {
//        index = row
//        break
//      }
//    }
//
//    if index == nil {
//
//      selectedIndex.append(indexPath)
//    }

  }

  func removeRowAtIndexPath(indexPath: IndexPath) {
//    var index:Int? = nil
//    for i in 0 ..< selectedIndex.count {
//      let _indexPath = selectedIndex[i]
//      if _indexPath == indexPath {
//        index = i
//        break
//      }
//    }
//
//    if let _ =  index {
//      if index! < selectedIndex.count {
//        selectedIndex.remove(at: index!)
//      }
//    }
  }

  func updateInputValue() {
    var total: Float = 0
    for odd in wagerOdds {
      total = total + odd.money
    }
    inputLabel.text = String(format:"¥ %.\(total.countFloatPoint())f",total)
  }

  func  didSelectTab(at index: Int) {
    if index == 1 {
      currentTab = .left
      tableScrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
      leftTabButton.addBottomBorderWithColor(color: AppColors.tabbarColor, width: 2)
      rightTabButton.addBottomBorderWithColor(color: .clear, width: 0)
      rightTableView.reloadData()
    }else if (index == 2) {
      currentTab = .right
      tableScrollView.setContentOffset(CGPoint(x: UIScreen.main.bounds.width, y: 0), animated: true)
      leftTabButton.addBottomBorderWithColor(color: .clear, width: 0)
      rightTabButton.addBottomBorderWithColor(color: AppColors.tabbarColor, width: 2)
      tableView.reloadData()

    }
  }
  
  @objc func textFieldDidChange(_ textfield: UITextField) {
    inputLabel.text = "¥ \(textfield.text ?? "0.0")"
    currentTab = .none
    resetTableData()
  }

  @objc func tappedView(_ sende: UIGestureRecognizer) {
    view.endEditing(true)
  }

  @IBAction func bettingPressed(_ sender: Any) {
    betBull()
  }

  @IBAction func tabButtonPressed(_ sender: UIButton) {
    didSelectTab(at: sender.tag)
  }

  override func backPressed(_ button: UIButton){
    dismiss(animated: true, completion: nil)
  }
}

extension BetBullViewController : UITableViewDelegate, UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if tableView == self.tableView {
    return wagerOdds.filter{$0.objectid <= 10 }.count
    }else if tableView == self.rightTableView {
      return wagerOdds.filter{$0.objectid > 10 }.count
    }
    return 0

  }

  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 30
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    var data:[BullWagerOddModel] = []

    if tableView == self.tableView {
      data = wagerOdds.filter{$0.objectid <= 10}
    } else if tableView == self.rightTableView {
      data = wagerOdds.filter{$0.objectid > 10}
    }

    let model = data[indexPath.row]
//    var index:Int?
//    for row in selectedIndex {
//      if row == indexPath {
//        index = row.row
//        break
//      }
//    }

    if let cell = tableView.dequeueReusableCell(withIdentifier: "WagerOddViewCell", for: indexPath) as? WagerOddViewCell {
      cell.updateView(model: model, selected: model.money > 0, max: bullround.state2)
      cell.completionHandler = {[weak self] in
        guard let this = self else {return }
        if tableView == this.tableView {
          this.currentTab = .left
          this.wagerOdds = this.wagerOdds.map({ (odd) -> BullWagerOddModel in
            if odd.objectid > 10 {
              odd.money = 0
              return odd
            }else {
              return odd
            }
          })
//          this.selectedIndex = []
          this.rightTableView.reloadData()
        }else if tableView == self?.rightTableView {
          self?.currentTab = .right
          this.wagerOdds = this.wagerOdds.map({ (odd) -> BullWagerOddModel in
            if odd.objectid <= 10 {
              odd.money = 0
              return odd
            }else {
              return odd
            }
          })
          this.tableView.reloadData()
        }

      }
      cell.didMoneyChanged = {[weak self ]money in
        guard let this = self else {return}
        model.money = money
        if money > 0.0 {
          this.selecteRowAtIndexPath(indexPath: indexPath)
        }else {
          this.removeRowAtIndexPath(indexPath: indexPath)
        }

        cell.updateView(model: model, selected: money > 0.0, max: this.bullround.state2)
        this.moneyTextfield.text = nil
        this.updateInputValue()
      }
      return cell
    }
    return UITableViewCell()
  }
}
extension BetBullViewController {
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

extension BetBullViewController: UITextFieldDelegate {
  func textFieldDidBeginEditing(_ textField: UITextField) {
    if textField == moneyTextfield {
      currentTab = .none
      resetTableData()
    }
  }
}

extension BetBullViewController: UIScrollViewDelegate {

  func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
   didStopScroll()
  }

  func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
    if !decelerate{
      didStopScroll()
    }
  }
}
