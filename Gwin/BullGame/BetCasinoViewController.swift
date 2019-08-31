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
    static let cellHeight: CGFloat = 30
  }
  @IBOutlet weak var backButton: UIButton!
  
  @IBOutlet weak var topBetButton: UIButton!
  @IBOutlet weak var betButton: UIButton!
  @IBOutlet weak var tableView: UITableView!

  @IBOutlet weak var leftTabButton: UIButton!
  @IBOutlet weak var rightTabButton: UIButton!

  @IBOutlet weak var inputLabel: UILabel!

  @IBOutlet weak var tableHeightConstraint: NSLayoutConstraint!
  private var  room: RoomModel
  private var roundid: Int64
  var wagerOdds: [BullWagerOddModel] = []
  var oddNames: [String] = []
  var wagertypeno: Int
  var selectedIndex: [Int] = []
  var currentMoney: Float = 0.0

  init(room: RoomModel, roundid: Int64, wagertypeno: Int) {
    self.room = room
    self.roundid = roundid
    self.wagertypeno = wagertypeno
    super.init(nibName: "BetCasinoViewController", bundle: nil)
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    setTitle(title: "牛牛百家乐下注")

    // Do any additional setup after loading the view.

    setupViews()
    loadWaggerOddNames()
    fetchwagerodds()
  }

  func setupViews() {
    if wagertypeno == Wagertypeno.casino.rawValue {
      tableView.register(UINib(nibName: "WagerOddViewCell", bundle: nil), forCellReuseIdentifier: "WagerOddViewCell")
    }else if wagertypeno == Wagertypeno.other.rawValue {
      tableView.register(UINib(nibName: "BetOtherViewCell", bundle: nil), forCellReuseIdentifier: "BetOtherViewCell")
    }

    tableView.delegate = self
    tableView.dataSource = self

    //
    inputLabel.rounded()
    betButton.rounded()
    topBetButton.rounded(borderColor: .red, borderwidth: 1)

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
      this.wagerOdds = wagerodds.filter{$0.wagertypeno == this.wagertypeno}
      for odd in this.wagerOdds {
        odd.name = this.getOddNames(model: odd)
      }
      this.tableHeightConstraint.constant = Constants.cellHeight * CGFloat(min(this.wagerOdds.count,10))
      this.tableView.reloadData()
    }
  }

  func betCasino(){
    guard let user = RedEnvelopComponent.shared.user else { return }

    var waggers = ""

    for index in selectedIndex {
      let model = wagerOdds[index]
      let x = "\(model.wagertypeno):\(model.objectid):\(model.money)"
      waggers = "\(waggers) \(x);"
    }

    BullAPIClient.betting(ticket: user.ticket, roomid: room.roomId, roundid: roundid, wagers: waggers){ [weak self](success, error) in
      guard let this = self else { return }

      if success {
        this.dismiss(animated: true, completion: nil)
      } else {
        if let message = error {
          this.showAlertMessage(message: message)
        }
      }

    }

  }


  func selecteRowAtIndexPath(indexPath: IndexPath) {
    var index:Int?
    for row in selectedIndex {
      if row == indexPath.row {
        index = row
        break
      }
    }

    if index == nil {
      selectedIndex.append(indexPath.row)
      tableView.beginUpdates()
      tableView.reloadRows(at: [indexPath], with: .none)
      tableView.endUpdates()
    }

  }

  @IBAction func betPressed(_ sender: Any) {
    betCasino()
  }

  @IBAction func tabPressed(_ sender: UIButton) {
    let tag = sender.tag
    if tag == 1{
      //left
    }else if tag == 2{
      //right
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
extension BetCasinoViewController: UITableViewDelegate, UITableViewDataSource {

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return wagerOdds.count
  }

  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return Constants.cellHeight
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let model = wagerOdds[indexPath.row]

    var index:Int?
    for row in selectedIndex {
      if row == indexPath.row {
        index = row
        break
      }
    }
    if wagertypeno == Wagertypeno.casino.rawValue {
    if let cell = tableView.dequeueReusableCell(withIdentifier: "WagerOddViewCell", for: indexPath) as? WagerOddViewCell {

      cell.updateView(model: model, selected: indexPath.row == index)
      cell.completionHandler = {[weak self] in
        self?.selecteRowAtIndexPath(indexPath: indexPath)
      }

      cell.didMoneyChanged = {[weak self ]money in
        model.money = money
        self?.updateInputValue()
      }

      //      cell.didMoneyInput = {[weak self ] money in
      //        self?.currentMoney =  self?.currentMoney ?? 0.0 + money
      //      }
      return cell
    }
    } else if wagertypeno == Wagertypeno.other.rawValue {
      if let cell = tableView.dequeueReusableCell(withIdentifier: "BetOtherViewCell", for: indexPath) as? BetOtherViewCell {

        return cell
      }
    }
    return UITableViewCell()
  }

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    var index:Int?
    for row in selectedIndex {
      if row == indexPath.row {
        index = row
        break
      }
    }

    if let `index` = index {
      selectedIndex.remove(at: index)
    }else {
      selectedIndex.append(indexPath.row)
    }

    tableView.reloadData()
  }
}

