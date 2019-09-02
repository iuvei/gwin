//
//  BankerViewController.swift
//  Gwin
//
//  Created by Hai Vu Van on 9/2/19.
//  Copyright © 2019 Hai Vu Van. All rights reserved.
//

import UIKit

class BankerViewController: BaseViewController {

  private var roomid: Int
  private var roundid: Int64?

  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var backButton: UIButton!

  private var datas:[BankGetModel] = []
  init(roomid: Int, roundid: Int64) {
    self.roomid = roomid
    self.roundid = roundid
    super.init(nibName: "BankerViewController", bundle: nil)
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    // Do any additional setup after loading the view.
    setupViews()
    fetchBanker()
  }


  func setupViews() {
    tableView.register(UINib(nibName: "BankerViewCell", bundle: nil), forCellReuseIdentifier: "BankerViewCell")
    tableView.delegate = self
    tableView.delegate = self

    //
    backButton.addTarget(self, action: #selector(backPressed(_:)), for: .touchUpInside)
  }

  func fetchBanker() {
    guard let user = RedEnvelopComponent.shared.user else {return}
    guard let `roundid` = roundid else {return }
    showLoadingView()
    BullAPIClient.banker_get(ticket: user.ticket, roomid: roomid, roundi: roundid, pagesize: 50) { (bankers, erorr) in
      self.hideLoadingView()
      self.datas.append(contentsOf: bankers)
      self.roundid = bankers.last?.roundid
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

extension BankerViewController: UITableViewDelegate, UITableViewDataSource {

  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 30
  }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return datas.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

    let banker = datas[indexPath.row]

    if let cell = tableView.dequeueReusableCell(withIdentifier: "BankerViewCell", for: indexPath) as? BankerViewCell {
      cell.updateViews(index: indexPath.row, banker:banker)

      if indexPath.row == self.datas.count - 1 {
        fetchBanker()
      }
      return cell
    }

    return UITableViewCell()
  }
}

