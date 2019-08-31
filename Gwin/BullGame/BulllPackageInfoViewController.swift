//
//  BulllPackageInfoViewController.swift
//  Gwin
//
//  Created by Hai Vu Van on 8/31/19.
//  Copyright © 2019 Hai Vu Van. All rights reserved.
//

import UIKit

class BulllPackageInfoViewController: BaseViewController {


  @IBOutlet weak var backButton: UIButton!

  @IBOutlet weak var titleLabel: UILabel!

  @IBOutlet weak var amounLabel: UILabel!

  @IBOutlet weak var usernoLabel: UILabel!
  @IBOutlet weak var avatarImageView: UIImageView!
  @IBOutlet weak var wagerTimeLabel: UILabel!

  @IBOutlet weak var tableView: UITableView!
  private var details: [BullBetDetailModel] = []
  private let roomid: Int
  private let roundid: Int64
  private let grabedModel: BullPackageModel

  init(roomid: Int, roundid: Int64, grabedModel: BullPackageModel){
    self.roomid = roomid
    self.roundid = roundid
    self.grabedModel = grabedModel
    super.init(nibName: "BulllPackageInfoViewController", bundle: nil)
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    // Do any additional setup after loading the view.
    setupViews()
    updateViews()
    fetchBetDetail()
  }

  func setupViews() {
    tableView.register(UINib(nibName: "BetDetailiewCell", bundle: nil), forCellReuseIdentifier: "BetDetailiewCell")
    tableView.delegate = self
    tableView.dataSource = self
    avatarImageView.rounded()

    //
    backButton.addTarget(self, action: #selector(backPressed(_:)), for: .touchUpInside)
  }

  func updateViews(){
    wagerTimeLabel.text = " 已领取2/2个,共4.88/4.88元, \(roundid)8期"
    usernoLabel.text = grabedModel.userno
    amounLabel.text = "\(grabedModel.packettag)"
  }

  func fetchBetDetail() {
    guard let user = RedEnvelopComponent.shared.user else {return}

    BullAPIClient.betdetail(ticket: user.ticket, roomid: roomid, roundid: roundid, userno: grabedModel.userno) { (details, error) in
      self.details = details
      self.tableView.reloadData()
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
}

extension BulllPackageInfoViewController: UITableViewDelegate, UITableViewDataSource {

  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 70
  }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return details.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    if let cell = tableView.dequeueReusableCell(withIdentifier: "BetDetailiewCell", for: indexPath) as? BetDetailiewCell {
      let _ = details[indexPath.row]
      if indexPath.row % 2 == 0 {
        cell.contentView.backgroundColor = .red
      }else {
        cell.contentView.backgroundColor = .blue

      }

      return cell
    }

    return UITableViewCell()
  }
}


