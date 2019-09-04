//
//  GrabBankerViewController.swift
//  Gwin
//
//  Created by Hai Vu Van on 8/29/19.
//  Copyright © 2019 Hai Vu Van. All rights reserved.
//

import UIKit

class GrabBankerViewController: BaseViewController {

  @IBOutlet weak var backButton: UIButton!
  @IBOutlet weak var okButton: UIButton!
  @IBOutlet weak var tableView: UITableView!

  @IBOutlet weak var bankqtyTextfield: UITextField!
  @IBOutlet weak var tableHeightConstraint: NSLayoutConstraint!

  private var settings:[BankSettingModel] = []
  var indexSelected: Int = Int.max
  var settingSelected: BankSettingModel?

  var room: RoomModel
  init(room: RoomModel){
    self.room = room
    super.init(nibName: "GrabBankerViewController", bundle: nil)
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    setTitle(title: "闲家抢庄页面")
    // Do any additional setup after loading the view.
    setupViews()
    fetchBankSetting()
  }

  func setupViews() {
    backButton.addTarget(self, action: #selector(backPressed(_:)), for: .touchUpInside)
    okButton.rounded()
    bankqtyTextfield.rounded()
    tableView.register(UINib(nibName: "BankSettingViewCell", bundle: nil), forCellReuseIdentifier: "BankSettingViewCell")
    tableView.alwaysBounceVertical = false
    tableView.delegate = self
    tableView.dataSource = self
  }

  func fetchBankSetting() {
    guard  let user = RedEnvelopComponent.shared.user else {
      return
    }

    BullAPIClient.banksetting(ticket: user.ticket) { [weak self] (settings, error) in
      self?.settings = settings
      self?.tableHeightConstraint.constant = CGFloat(25 * settings.count)
      print("settings \(settings.count)")
      self?.tableView.reloadData()
    }
  }

  func setBanker(setting: BankSettingModel) {
    guard  let user = RedEnvelopComponent.shared.user else { return }
    guard let bankqty = bankqtyTextfield.text, let bankqtyValue  =  Int(bankqty) else {
      showAlertMessage(message: "请选择金额以及下注区间再进行抢庄")
      return
    }
    
    BullAPIClient.setbanker(ticket: user.ticket, roomid: room.roomId, bankqty: bankqtyValue , lockquota: setting.lockquota, stake1: setting.stake1, stake2: setting.stake2) {[weak self] (success, error) in

      if success {
        self?.dismiss(animated: true, completion: nil)
      }else {
        if let message = error {
          self?.showAlertMessage(message: message)
        }
      }
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

  override func backPressed(_ sender: UIButton) {
    dismiss(animated: true, completion: nil)
  }

  @IBAction func okPressed(_ sender: Any) {
    if let setting = settingSelected {
      setBanker(setting: setting)
    }else {
      showAlertMessage(message: "请选择金额以及下注区间再进行抢庄")
    }
  }
}

extension GrabBankerViewController: UITableViewDelegate, UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return settings.count
  }

  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 25
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

    let model = settings[indexPath.row]

    if let cell = tableView.dequeueReusableCell(withIdentifier: "BankSettingViewCell", for: indexPath) as? BankSettingViewCell{
      cell.updateViews(model:model, selected: indexSelected == indexPath.row)
      return cell
    }

    return UITableViewCell()
  }
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    indexSelected = indexPath.row
    settingSelected = settings[indexPath.row]
    tableView.reloadData()
  }
}

