//
//  BulllPackageInfoViewController.swift
//  Gwin
//
//  Created by Hai Vu Van on 8/31/19.
//  Copyright © 2019 Hai Vu Van. All rights reserved.
//

import UIKit

protocol BulllPackageInfoDelegate: AnyObject {
  func didFetchPackageInfo(package: BullPackageHistoryModel?)
}

class BulllPackageInfoViewController: BaseViewController {


  @IBOutlet weak var backButton: UIButton!

  @IBOutlet weak var profileButton: UIButton!
  @IBOutlet weak var titleLabel: UILabel!

  @IBOutlet weak var amounLabel: UILabel!

  @IBOutlet weak var usernoLabel: UILabel!
  @IBOutlet weak var onlySelfLabel: UILabel!

  @IBOutlet weak var avatarImageView: UIImageView!
  @IBOutlet weak var wagerTimeLabel: UILabel!

  @IBOutlet weak var rounidLabel: UILabel!
  @IBOutlet weak var tableView: UITableView!
  private lazy var refreshControl:UIRefreshControl = {
    let view = UIRefreshControl()
    return view
  }()
  
//  private let roomid: Int
//  private let roundid: Int64
  private var grabedModel: BullPackageModel?
//  private let userno: String
  private let bull: BullModel
  private var betdetails:[IndexPath:[BullBetDetailModel]] = [:]
  private var delegate: BulllPackageInfoDelegate?

  init(bull: BullModel, grabedModel: BullPackageModel? = nil, delegate: BulllPackageInfoDelegate? = nil){
    self.bull =  bull
    self.grabedModel = grabedModel
    self.delegate = delegate
//    self.userno = userno
    super.init(nibName: "BulllPackageInfoViewController", bundle: nil)
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    // Do any additional setup after loading the view.
    setupViews()
    fetchInfo()
  }

  func setupViews() {
    tableView.register(UINib(nibName: "BetDetailiewCell", bundle: nil), forCellReuseIdentifier: "BetDetailiewCell")
    tableView.delegate = self
    tableView.dataSource = self
    tableView.rowHeight = UITableView.automaticDimension
    tableView.estimatedRowHeight = 200
    if #available(iOS 10.0, *) {
      tableView.refreshControl = refreshControl
    } else {
      tableView.addSubview(refreshControl)
    }

    refreshControl.addTarget(self, action: #selector(refreshData(_:)), for: .valueChanged)
    //
    avatarImageView.rounded()

    //
    backButton.addTarget(self, action: #selector(backPressed(_:)), for: .touchUpInside)
    profileButton.addTarget(self, action: #selector(profilePressed(_:)), for: .touchUpInside)
  }

  func updateViews(userno: String, amount: String){
    guard let package = grabedModel else {return}

    let packageAmountText = String(format: "%@", (package.packetamount - package.remainamount).toFormatedString())
    let betAmountText = String(format: "%@", package.packetamount.toFormatedString())


    wagerTimeLabel.text = " 已领取\(package.packetsize - package.remainsize)/\(package.packetsize)个,共\(packageAmountText)/\(betAmountText)元"
    rounidLabel.text = "\(bull.getRoundId()) 期"
    usernoLabel.text = userno
    amounLabel.text = String(format: "%@", amount)

    wagerTimeLabel.isHidden = bull.isOnleyself()
    rounidLabel.isHidden = bull.isOnleyself()
    let resultText = "\(package.packettag)"
    onlySelfLabel.text =  bull.isOnleyself() ? "发了一个牛牛红包，金额随机 \n \(resultText)" : nil
  }

  func fetchBetDetail(userno: String, indexPath: IndexPath) {
    guard let user = RedEnvelopComponent.shared.user else {return}

    BullAPIClient.betdetail(ticket: user.ticket, roomid: bull.roomid, roundid: bull.getRoundId(), userno: userno) { (details, error) in
      self.betdetails[indexPath] = details
      self.tableView.reloadData()
    }
  }

  func fetchInfo(){
    guard let user = RedEnvelopComponent.shared.user else { return }
    //let roundStatus
    // <3 -> onlyself = 1
    //else ->onlyself = 0
    let onlyself = bull.isOnleyself() ? 1 : 0
    BullAPIClient.info(ticket: user.ticket, roomid: bull.roomid, roundid: bull.getRoundId(), onlyself: onlyself) { [weak self](package,model, error) in
      guard let this = self else { return }
      this.refreshControl.endRefreshing()
      this.delegate?.didFetchPackageInfo(package: package)
      guard let `model` = model else {return}
      this.grabedModel = model
      if onlyself  == 1 {
        if model.grabuser.count == 0 {
          this.updateViews(userno: model.userno, amount:String(format: "%@-%@",  model.stake.toFormatedString(),model.packettag))
        }else {
          let user = model.grabuser[0]
          this.updateViews(userno: user.userno, amount: String(format: "%@%@",  user.packetamount.toFormatedString(), AppText.currency))
          this.fetchUserImage(userno: user.userno)
          this.grabedModel?.grabuser.remove(at: 0)
          this.tableView.reloadData()
        }
      }else{
        this.updateViews(userno: model.userno, amount: String(format: "%@-%@",model.stake.toFormatedString() ,model.packettag))
        this.tableView.reloadData()
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
  func fetchUserImage(userno: String) {
    guard let user = RedEnvelopComponent.shared.user else { return }
    if let imgString = ImageManager.shared.getImage(userno: userno) {
      if let data = Data(base64Encoded: imgString, options: []) {
        avatarImageView.image = UIImage(data: data)
      }
    }else {
      UserAPIClient.getUserImages(ticket: user.ticket, usernos: [userno]) {[weak self] (data, _) in
        guard let this = self else { return }
        guard let _data = data else { return }
        for json in _data {
          let userno = json["userno"].stringValue
          let imgString = json["img"].stringValue
          ImageManager.shared.saveImage(userno: userno, image: imgString)
          if let data = Data(base64Encoded: imgString, options: []) {
            this.avatarImageView.image = UIImage(data: data)
          }

        }
      }
    }
  }

  @objc private func refreshData(_ sender: Any) {
    // Fetch Weather Data
    fetchInfo()
  }

  override func backPressed(_ sender: UIButton) {
    dismiss(animated: true, completion: nil)
  }

//  @IBAction func profilePressed(_ sender: Any) {
//    if let delegate =  UIApplication.shared.delegate as? AppDelegate{
//      delegate.tabbarController?.selectProfileTab()
//      dismiss(animated: true, completion: nil)
//    }
//  }

  override func profilePressed(_ sender: UIButton) {
    selectProfileTab()
    dismiss(animated: true, completion: nil)
  }

  func reloadCell(at indexPath: IndexPath) {
    guard let  user = grabedModel?.grabuser[indexPath.row] else { return }

    if let cell = tableView.cellForRow(at: indexPath) as? BetDetailiewCell {
      let details = betdetails[indexPath] ?? []
      cell.updateViews(grabUser: user, details: details)
    }
  }
}

extension BulllPackageInfoViewController: UITableViewDelegate, UITableViewDataSource {

//  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//    return 70
//  }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if let abc = grabedModel{
      return abc.grabuser.count
    }
    return 0
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let  user = grabedModel?.grabuser[indexPath.row] else { return UITableViewCell()}

    if let cell = tableView.dequeueReusableCell(withIdentifier: "BetDetailiewCell", for: indexPath) as? BetDetailiewCell {
      let details = betdetails[indexPath] ?? []
      cell.updateViews(grabUser: user, details: details)
      cell.didExpandDetail = { [weak self] expand in
        user.expand = expand
        self?.reloadCell(at: indexPath)
      }
      return cell
    }

    return UITableViewCell()
  }

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    if let user = grabedModel?.grabuser[indexPath.row] {
      user.expand = !user.expand
      fetchBetDetail(userno: user.userno, indexPath: indexPath)
    }
  }
}



