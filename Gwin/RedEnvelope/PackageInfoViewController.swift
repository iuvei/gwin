//
//  PackageInfoViewController.swift
//  Gwin
//
//  Created by Hai Vu Van on 8/24/19.
//  Copyright © 2019 Hai Vu Van. All rights reserved.
//

import UIKit

class PackageInfoViewController: BaseViewController {

  @IBOutlet weak var backButton: UIButton!

  @IBOutlet weak var titleLabel: UILabel!

  @IBOutlet weak var profileButton: UIButton!
  @IBOutlet weak var envelopButton: UIButton!
  
  @IBOutlet weak var amounLabel: UILabel!

  @IBOutlet weak var usernoLabel: UILabel!
  @IBOutlet weak var avatarImageView: UIImageView!
  @IBOutlet weak var packageIdLabel: UILabel!
  @IBOutlet weak var wagerTimeLabel: UIButton!

  @IBOutlet weak var tableView: UITableView!
  private lazy var refreshControl:UIRefreshControl = {
    let view = UIRefreshControl()
    return view
  }()

  var didPressedCreateEnvelop: ()->Void = {}

  private var model: PackageInfoModel?

  //  private var infoPackage: PackageInfoModel?
  private let roomid: Int
  private let packageid: Int64

  init(model: PackageInfoModel? = nil, roomid: Int, packageid: Int64){
    self.model = model
    self.roomid = roomid
    self.packageid = packageid
    super.init(nibName: "PackageInfoViewController", bundle: nil)
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    setTitle(title: "红包详情")
    setupViews()
    fetchPackageInfo()
    backButton.addTarget(self, action: #selector(backPressed(_:)), for: .touchUpInside)
    profileButton.addTarget(self, action: #selector(profilePressed(_:)), for: .touchUpInside)
    envelopButton.addTarget(self, action: #selector(createEnvelopPressed(_:)), for: .touchUpInside)
    // Do any additional setup after loading the view.

  }

  func setupViews() {
    // Add Refresh Control to Table View
    if #available(iOS 10.0, *) {
      tableView.refreshControl = refreshControl
    } else {
      tableView.addSubview(refreshControl)
    }

    refreshControl.addTarget(self, action: #selector(refreshWeatherData(_:)), for: .valueChanged)

    tableView.register(UINib(nibName: "GrabUserViewCell", bundle: nil), forCellReuseIdentifier: "GrabUserViewCell")
    tableView.delegate = self
    tableView.dataSource = self
    avatarImageView.rounded()

    //
    let fontSize: CGFloat = UIDevice.current.screenType == .iPhones_5_5s_5c_SE ? 14.0 : 17.0
    packageIdLabel.font = UIFont.systemFont(ofSize: fontSize)
    wagerTimeLabel.titleLabel?.font = UIFont.systemFont(ofSize: fontSize)
  }

  func fetchPackageInfo() {
    guard let user = RedEnvelopComponent.shared.user  else { return }
    RedEnvelopAPIClient.infoPackage(ticket: user.ticket, roomid: roomid, packageid: packageid) { [weak self] (info, message) in
      guard let this = self else { return }
      this.refreshControl.endRefreshing()
      this.model = info
      if let `info` = info {

        info.findKing(packageid: this.packageid)
        if info.packettag.count > 0{
          this.amounLabel.text = "\(info.packetamount)-\(info.packettag)"
        }else {
          this.amounLabel.text = "\(info.packetamount)"
        }
        
        this.usernoLabel.text = info.userno
        this.packageIdLabel.text = "\(this.packageid) "
        let title = String(format: "  已领取%d／%d个／共%@／%@元", info.grabuser.count, info.packetsize,   (info.outOfStock() || info.isExpire()) ? info.totalPackageAmount().toFormatedString() : "*.**" ,info.packetamount.toFormatedString())
        this.wagerTimeLabel.setTitle(title, for: .normal)

        this.model = info
        this.tableView.reloadData()
        this.fetchAvatarImage()
      }
    }
  }

  func fetchAvatarImage(){
    guard let `model` = model else { return }

    if let image64 = ImageManager.shared.getImage(userno: model.userno) {
      if let data = Data(base64Encoded: image64, options: []) {
        avatarImageView.image = UIImage(data: data)
      }
    } else {
      guard let user = RedEnvelopComponent.shared.user else { return }
      UserAPIClient.getUserImages(ticket: user.ticket, usernos: [model.userno]) {[weak self] (data, _) in
        guard let this = self else { return }
        guard let _data = data else { return }
        for json in _data {
          let userno = json["userno"].stringValue
          let imgString = json["img"].stringValue
          ImageManager.shared.saveImage(userno: userno, image: imgString)
          if userno == model.userno {
            if let data = Data(base64Encoded: imgString, options: []) {
              this.avatarImageView.image = UIImage(data: data)
            }
          }
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

  @objc func createEnvelopPressed(_ sender: UIButton) {
    didPressedCreateEnvelop()
    dismiss(animated: true, completion: nil)
  }

  override func profilePressed(_ sender: UIButton) {
    selectProfileTab()
    dismiss(animated: true, completion: nil)
  }

  override func backPressed(_ sender: UIButton) {
    dismiss(animated: true, completion: nil)
  }

  @objc private func refreshWeatherData(_ sender: Any) {
    // Fetch Weather Data
    fetchPackageInfo()
  }

  @IBAction func viewMoneyPressed(_ sender: Any) {
    if let info = model {
      if (info.outOfStock() || info.isExpire()){
        guard let `user` = RedEnvelopComponent.shared.user else { return }
        UserAPIClient.otherH5(ticket: user.ticket, optype: "order_unsettled") {[weak self] (url, message) in
          guard let `this` = self else { return }

          if let jumpurl = url {
            let webview = WebContainerController(url: jumpurl, title: "冻结金额详情")
            this.present(webview, animated: true, completion: nil)
          }
        }

      }
    }
  }

}


extension PackageInfoViewController: UITableViewDelegate, UITableViewDataSource {

  func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
    return 0.1
  }

  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 80
  }

  func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
    return UIView()
  }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if let model = self.model {
      return model.grabuser.count
    }

    return 0
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    if let cell = tableView.dequeueReusableCell(withIdentifier: "GrabUserViewCell", for: indexPath) as? GrabUserViewCell {
      guard let package = self.model else { return UITableViewCell() }

      let model = package.grabuser[indexPath.row]
      cell.updateViews(model: model, packageid: packageid, outofStock: package.outOfStock())


      return cell
    }
    
    return UITableViewCell()
  }


}

