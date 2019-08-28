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

  @IBOutlet weak var amounLabel: UILabel!

  @IBOutlet weak var usernoLabel: UILabel!
  @IBOutlet weak var avatarImageView: UIImageView!
  @IBOutlet weak var wagerTimeLabel: UILabel!

  @IBOutlet weak var tableView: UITableView!
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
    // Do any additional setup after loading the view.

  }

  func setupViews() {
    tableView.register(UINib(nibName: "GrabUserViewCell", bundle: nil), forCellReuseIdentifier: "GrabUserViewCell")
    tableView.delegate = self
    tableView.dataSource = self
    avatarImageView.rounded()
  }

  func fetchPackageInfo() {
    guard let user = RedEnvelopComponent.shared.user  else { return }
    RedEnvelopAPIClient.infoPackage(ticket: user.ticket, roomid: roomid, packageid: packageid) { [weak self] (info, message) in
      guard let this = self else { return }
      if let `info` = info {
        this.amounLabel.text = "\(info.packetamount)-\(info.packettag)"
        this.usernoLabel.text = info.userno
        this.wagerTimeLabel.text = "已领取\(info.packettype)／\(info.packetsize)个／共*.**／\(info.packetamount)元"
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
        guard let _data = data else { return }
        for json in _data {
          let userno = json["userno"].stringValue
          let imgString = json["img"].stringValue
          ImageManager.shared.saveImage(userno: userno, image: imgString)
          if userno == model.userno {
            if let data = Data(base64Encoded: imgString, options: []) {
              self?.avatarImageView.image = UIImage(data: data)
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

  override func backPressed(_ sender: UIButton) {
    dismiss(animated: true, completion: nil)
  }

}


extension PackageInfoViewController: UITableViewDelegate, UITableViewDataSource {

  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 90
  }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if let model = self.model {
      return model.grabuser.count
    }

    return 0
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    if let cell = tableView.dequeueReusableCell(withIdentifier: "GrabUserViewCell", for: indexPath) as? GrabUserViewCell {
      if let model = self.model?.grabuser[indexPath.row] {
        cell.updateViews(model: model, packageid: packageid)
      }

      return cell
    }
    
    return UITableViewCell()
  }
}

