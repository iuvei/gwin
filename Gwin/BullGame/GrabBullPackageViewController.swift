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

  @IBOutlet weak var nextButton: UIButton!
  @IBOutlet weak var grabButton: UIButton!
  private var history: BullPackageHistoryModel
  private var room: RoomModel
  private var status: Int?
  private var screenIndex: Int?

  var didGrabPackage: (BullPackageModel)->Void = {_ in}

  init(history: BullPackageHistoryModel, room: RoomModel) {
    self.history = history
    self.room = room
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

  func updateViews() {
    usernameLabel.text = history.userno
    packageTagLabel.text = history.packettag

  }


  func fetchPackageStatus() {
    guard let user = RedEnvelopComponent.shared.user else { return }

    BullAPIClient.packetstatus(ticket: user.ticket, roomid: room.roomId , roundid: history.roundid) {[weak self](status, error) in
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

    BullAPIClient.grab(ticket: user.ticket, roomid: room.roomId, roundid: history.roundid) { (pullPackage, error) in
      if let model = pullPackage {
        self.dismiss(animated: true, completion: {

          self.didGrabPackage(model)
        })

      }else{
        if let message = error {
          self.showAlertMessage(message: message)
        }
      }
    }
  }

  @IBAction func packageDetailPressed(_ sender: Any) {

  }

  @IBAction func closePressed(_ sender: Any) {
    dismiss(animated: true, completion: nil)
  }

}

