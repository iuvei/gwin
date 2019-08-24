//
//  CreateEnvelopViewController.swift
//  Gwin
//
//  Created by Hai Vu Van on 8/24/19.
//  Copyright © 2019 Hai Vu Van. All rights reserved.
//

import UIKit

class CreateEnvelopViewController: BaseViewController {

  @IBOutlet weak var sendButton: UIButton!
  @IBOutlet weak var packageTagTextfield: UITextField!

  @IBOutlet weak var packageAmountTextfield: UITextField!

  @IBOutlet weak var packageSizeLabel: UILabel!

  var room: RoomModel

  init(room: RoomModel) {
    self.room = room
    super.init(nibName: "CreateEnvelopViewController", bundle: nil)
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    // Do any additional setup after loading the view.
    packageSizeLabel.text = "\(room.packageSize)"
    packageAmountTextfield.placeholder = "\(room.stake1)-\(room.stake2)"
  }


  /*
   // MARK: - Navigation

   // In a storyboard-based application, you will often want to do a little preparation before navigation
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
   // Get the new view controller using segue.destination.
   // Pass the selected object to the new view controller.
   }
   */
  @IBAction func sendPackagePressed(_ sender: Any) {
    guard let amountText = packageAmountTextfield.text, let amount = Int(amountText) else { return }
    guard let tag = packageTagTextfield.text else { return }
    guard let user = RedEnvelopComponent.shared.user else { return }

    RedEnvelopAPIClient.sendPackage(ticket: user.ticket, roomid: room.roomId, packageamount: amount, packagesize: room.packageSize, packagetag: tag) {[weak self] (success, message) in
      if success {
        self?.navigationController?.popViewController(animated: true)
      }
    }
  }

}

