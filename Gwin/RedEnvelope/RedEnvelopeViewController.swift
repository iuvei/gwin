//
//  RedEnvelopeViewController.swift
//  Gwin
//
//  Created by Hai Vu Van on 8/23/19.
//  Copyright © 2019 Hai Vu Van. All rights reserved.
//

import UIKit

class RedEnvelopeViewController: UIViewController {

  @IBOutlet weak var tableView: UITableView!
  override func viewDidLoad() {
    super.viewDidLoad()
    self.edgesForExtendedLayout = []

    // Do any additional setup after loading the view.
    fetchRoomList()
  }

  func fetchRoomList() {

    guard let `user` = RedEnvelopComponent.shared.user else { return }

    RedEnvelopAPIClient.getRoomList(ticket: user.ticket, roomtype: RoomType.boom) { (room, msg) in

      if let `room` = room {
        print(" room \(room)")
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

}

extension RedEnvelopeViewController: UITableViewDelegate, UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 10
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

    return UITableViewCell()
  }
}

