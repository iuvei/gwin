//
//  BetBullViewController.swift
//  Gwin
//
//  Created by Hai Vu Van on 8/29/19.
//  Copyright © 2019 Hai Vu Van. All rights reserved.
//

import UIKit
import SwiftyJSON

class BetBullViewController: BaseViewController {

  @IBOutlet weak var backButton: UIButton!
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var okButton: UIButton!

  @IBOutlet weak var moneyTextfield: UITextField!
  @IBOutlet weak var leftTabButton: UIButton!
  @IBOutlet weak var rightTabButton: UIButton!

  @IBOutlet weak var inputLabel: UILabel!
  var room: RoomModel
  var roundid: Int64
  var wagerOdds: [BullWagerOddModel] = []
  var oddNames: [String] = []
  init(room: RoomModel, roundid: Int64){
    self.room = room
    self.roundid = roundid

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
        // Do any additional setup after loading the view.
    }


  func setupViews() {

    backButton.addTarget(self, action: #selector(backPressed(_:)), for: .touchUpInside)
    //
    tableView.register(UINib(nibName: "WagerOddViewCell", bundle: nil), forCellReuseIdentifier: "WagerOddViewCell")
    tableView.delegate = self
    tableView.dataSource = self
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
      this.wagerOdds = wagerodds.filter{$0.wagertypeno == 4}
      for odd in this.wagerOdds {
        odd.name = this.getOddNames(model: odd)
      }
      this.tableView.reloadData()
    }
  }

  func betBull(){
    guard let user = RedEnvelopComponent.shared.user else { return }

    BullAPIClient.betting(ticket: user.ticket, roomid: room.roomId, roundid: roundid, wagers: ""){ [weak self](success, error) in
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
  @IBAction func bettingPressed(_ sender: Any) {
  }
}

extension BetBullViewController : UITableViewDelegate, UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return wagerOdds.count
  }

  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 30
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let model = wagerOdds[indexPath.row]
    if let cell = tableView.dequeueReusableCell(withIdentifier: "WagerOddViewCell", for: indexPath) as? WagerOddViewCell {
      cell.updateView(model: model)
      return cell
    }
    return UITableViewCell()
  }
}
