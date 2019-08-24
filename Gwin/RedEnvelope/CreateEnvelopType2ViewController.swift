//
//  CreateEnvelopType2ViewController.swift
//  Gwin
//
//  Created by Hai Vu Van on 8/24/19.
//  Copyright © 2019 Hai Vu Van. All rights reserved.
//

import UIKit

class CreateEnvelopType2ViewController: BaseViewController {



  @IBOutlet weak var ammountTextfield: UITextField!
  @IBOutlet weak var sizeTextfield: UITextField!
  @IBOutlet weak var createButton: UIButton!

  var room: RoomModel

  init(room: RoomModel) {
    self.room = room
    super.init(nibName: "CreateEnvelopType2ViewController", bundle: nil)
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    ammountTextfield.placeholder = "\(room.stake1)-\(room.stake2)"
    sizeTextfield.placeholder = "10-200"
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
  @IBAction func createPressed(_ sender: Any) {

    guard let amountText = ammountTextfield.text, let amount = Int(amountText) else { return }
    guard let sizeText = sizeTextfield.text, let size = Int(sizeText) else { return }
    guard let user = RedEnvelopComponent.shared.user else { return }

    RedEnvelopAPIClient.sendPackage(ticket: user.ticket, roomid: room.roomId, packageamount: amount, packagesize: size, packagetag: "") { [weak self] (success, message) in
      if success {
        self?.navigationController?.popViewController(animated: true)
      }
    }
  }


}
