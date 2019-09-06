//
//  GrabBullPackageViewController.swift
//  Gwin
//
//  Created by Hai Vu Van on 8/31/19.
//  Copyright © 2019 Hai Vu Van. All rights reserved.
//

import UIKit


class GrabBullPackageViewController: BaseViewController {

  enum Constants {

    enum Packetstatus{
      static let  status0: Int  = 0
      static let  status1: Int  = 1
      static let  status21: Int  = 21
      static let  status22: Int  = 22
      static let  status2: Int  = 2
      static let  status3: Int  = 3

    }
  }
  @IBOutlet weak var avatarImageView: UIImageView!
  @IBOutlet weak var usernameLabel: UILabel!
  @IBOutlet weak var packageTagLabel: UILabel!

  @IBOutlet weak var messageLabel: UILabel!
  @IBOutlet weak var nextButton: UIButton!
  @IBOutlet weak var grabButton: UIButton!
  //  private var roundid: Int64
  //  private var room: RoomModel
  private var status: Int?
  //  private var screenIndex: Int?
  //  private var history: BullPackageHistoryModel?
  private var bull: BullModel
  var didGrabPackage: (BullPackageModel)->Void = {_ in}
  var didViewPackageInfo:()-> Void = {}

  init(bull: BullModel, status: Int? = nil) {
    self.bull = bull
    self.status = status
    super.init(nibName: "GrabBullPackageViewController", bundle: nil)
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    updateViews()
    fetchPackageStatus()
    // Do any additional setup after loading the view.
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    SoundManager.shared.playBetSound()
  }

  func updateViews() {
    if let `package` = bull.historyPackage {
      usernameLabel.text = package.userno
      packageTagLabel.text = package.packettag
      packageTagLabel.isHidden = false
      messageLabel.text = bull.isOnleyself() ? "发了一个扫雷红包,金额随机" : "发了一个牛牛红包，金额随机"
    }else {
      usernameLabel.text = "平台"
      packageTagLabel.isHidden = true
      messageLabel.text = "发了一个牛牛红包，金额随机"
    }
  }

  func fetchPackageStatus() {
    guard let user = RedEnvelopComponent.shared.user else { return }

    BullAPIClient.packetstatus(ticket: user.ticket, roomid: bull.roomid , roundid: bull.getRoundId()) {[weak self](status, error) in
      guard let this = self else {return}
      if let `status` = status{
        this.status = status
        if status == Constants.Packetstatus.status0 {
          this.grabButton.isHidden = true
          this.nextButton.isHidden = true
        } else if status == Constants.Packetstatus.status1 {
          this.nextButton.isHidden = true
        } else if status == Constants.Packetstatus.status2 {
          this.grabButton.isHidden = true
          this.nextButton.isHidden = true
          this.messageLabel.text = "当前红包暂未结算 "
          //

        } else if status == Constants.Packetstatus.status3 {
          this.grabButton.isHidden = true
        }else if status == Constants.Packetstatus.status21 {
          this.grabButton.isHidden = true
        }else if status == Constants.Packetstatus.status22 {
          this.grabButton.isHidden = true
        }
      }

    }
  }

  func fetchPackageInfo() {
    //    guard let user = RedEnvelopComponent.shared.user else { return }
    //let roundStatus
    // <3 -> onlyself = 1
    //else ->onlyself = 0
    //    showLoadingView()
    //    BullAPIClient.info(ticket: user.ticket, roomid: room.roomId, roundid: history.roundid, onlyself: 0) { [weak self](model, error) in
    //      guard let this = self else { return }
    //      this.hideLoadingView()
    //
    //      print("info \(model?.packettag)")
    //
    //    }
    didViewPackageInfo()
    dismiss(animated: true, completion: nil)
  }
  /*
   // MARK: - Navigation

   // In a storyboard-based application, you will often want to do a little preparation before navigation
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
   // Get the new view controller using segue.destination.
   // Pass the selected object to the new view controller.
   }
   */
  @IBAction func grabBullPressed(_ sender: Any) {

    guard let user = RedEnvelopComponent.shared.user else {return}
    if processing == true {
      return
    }
    processing = true
    BullAPIClient.grab(ticket: user.ticket, roomid: bull.roomid, roundid: bull.getRoundId()) { [weak self](pullPackage, error) in
      self?.processing = false
      if let model = pullPackage {
        self?.dismiss(animated: true, completion: {

          self?.didGrabPackage(model)
        })

      }else{
        if let message = error {
          self?.packageTagLabel.text = message
          self?.packageTagLabel.isHidden = false
          //
          self?.grabButton.isHidden = true
          self?.nextButton.isHidden = false
        }
      }
    }
  }

  @IBAction func packageDetailPressed(_ sender: Any) {
    fetchPackageInfo()
  }

  @IBAction func closePressed(_ sender: Any) {
    dismiss(animated: true, completion: nil)
  }

}


