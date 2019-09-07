//
//  ProfileViewController.swift
//  Gwin
//
//  Created by Hai Vu Van on 8/22/19.
//  Copyright © 2019 Hai Vu Van. All rights reserved.
//

import UIKit
import SwiftyJSON

class ProfileViewController: BaseViewController {

  enum Constants {
    static let cellHeight: CGFloat = 40
    static let iPadCellHeight: CGFloat = 50
    static let updateInfoInterval: TimeInterval = 30
  }


  @IBOutlet weak var infoView: UIView!
  @IBOutlet weak var tableview: UITableView!
  
  @IBOutlet weak var avatarImageView: UIImageView!
  @IBOutlet weak var uploadAvatarButton: UIButton!

  @IBOutlet weak var allowCreditLabel: UILabel!
  @IBOutlet weak var allowCreateTitleLabel: UILabel!
  
  
  @IBOutlet weak var creditLabel: UILabel!
  @IBOutlet weak var creditTitleLabel: UILabel!


  @IBOutlet weak var accountnoLabel: UILabel!
  @IBOutlet weak var accountnoTitleLabel: UILabel!

  @IBOutlet weak var accountNameLabel: UILabel!
  @IBOutlet weak var acoutnameTitleLabel: UILabel!

  @IBOutlet weak var infoHeightConstraint: NSLayoutConstraint!
  private var menuItems:[ProfileItemModel] = []
  private var userInfo:UserInfo?
  private var timer: Timer?

  override func viewDidLoad() {
    super.viewDidLoad()
    self.edgesForExtendedLayout = []
    setTitle(title: "我的")
    initData()
    setupViews()
    fetchUserInfo()
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    hideBackButton()
    timer = Timer.scheduledTimer(timeInterval: Constants.updateInfoInterval, target: self, selector: #selector(fetchUserInfo), userInfo: nil, repeats: true)
  }

  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    timer?.invalidate()
    timer = nil
  }

  func initData() {
    if let path = Bundle.main.path(forResource: "ProfileItems", ofType: "json") {
      do {
        let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
        let jsonObj = try JSON(data: data).array

        jsonObj?.forEach{ json in
          let lobby = ProfileItemModel(json: json)
          menuItems.append(lobby)
        }
      } catch {
        // handle error
        print("Abcdef")
      }
    }
  }

 @objc func fetchUserInfo() {
    guard let user = RedEnvelopComponent.shared.user else { return }
    UserAPIClient.userInfo(ticket: user.ticket) { [weak self] (userInfo, errorMessage) in
      guard let this = self else { return }
      this.userInfo = userInfo
      if let `userInfo` = userInfo {
        print("userInfo \(userInfo)")
        this.accountnoLabel.text = userInfo.accountno
        
        if userInfo.accountname.count > 0 {
          this.accountNameLabel.text = userInfo.accountname
        } else {
          this.accountNameLabel.text = userInfo.accountno
        }

        this.allowCreditLabel.text = "\(userInfo.allowcreditquota.toFormatedString())"
        this.creditLabel.text = "\(userInfo.usecreditquota.toFormatedString())"
        this.fetchUserImage(ticket: user.ticket, userno: userInfo.accountno)
        this.reloadQrCodeCell()
      } else {

      }

    }
  }

  func fetchUserImage(ticket: String, userno: String) {
    ImageManager.shared.downloadImage(usernos: [userno]) { [weak self] in
      guard let this = self else { return }

      if let imagebase64 = ImageManager.shared.getImage(userno: userno) {
        if let imageData = Data(base64Encoded: imagebase64, options: []) {
          let image  = UIImage(data: imageData)
          this.avatarImageView.image = image
        }
      }
    }
  }

  func setupViews() {

    let font = UIDevice.current.iPad ? UIFont.systemFont(ofSize: 20) : UIFont.systemFont(ofSize: 14)
    allowCreditLabel.font = font
    allowCreateTitleLabel.font = font
    creditLabel.font = font
    creditTitleLabel.font = font
    accountnoLabel.font = font
    accountnoTitleLabel.font = font
    accountNameLabel.font = font
    acoutnameTitleLabel.font = font
    //
    //
    infoHeightConstraint.constant = UIDevice.current.iPad ? 100 : 80

    avatarImageView.contentMode = .scaleAspectFit
    uploadAvatarButton.addTarget(self, action: #selector(avatarPressed(_:)), for: .touchUpInside)
    setupTableView()
  }

  func setupTableView() {
    tableview.register(ProfileItemViewCell.self, forCellReuseIdentifier: "profileItemCell")
  }

  /*
   // MARK: - Navigation

   // In a storyboard-based application, you will often want to do a little preparation before navigation
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
   // Get the new view controller using segue.destination.
   // Pass the selected object to the new view controller.
   }
   */
  func logout(){

    guard let `user` = RedEnvelopComponent.shared.user else { return }
    showLoadingView()
    UserAPIClient.logout(ticket: user.ticket, guid: user.guid) {[weak self] (result, message) in
      self?.hideLoadingView()
      if result {
        if let appDelegate: AppDelegate = UIApplication.shared.delegate as? AppDelegate {
          appDelegate.setWellcomeAsRootViewController()
        }
      }
    }
  }

  func jumpURL(optType: String, title: String? = nil) {
    guard let `user` = RedEnvelopComponent.shared.user else { return }
    showLoadingView()
    UserAPIClient.otherH5(ticket: user.ticket, optype: optType) {[weak self] (url, message) in
      guard let `this` = self else { return }
      this.hideLoadingView()
      if let jumpurl = url {
        let webview = WebContainerController(url: jumpurl, title: title)
        this.present(webview, animated: true, completion: nil)
      }
    }
  }

  func reloadQrCodeCell() {
    let indexPath = IndexPath(item: 1, section: 0)
    tableview.beginUpdates()
    tableview.reloadRows(at: [indexPath], with: .none)
    tableview.endUpdates()
  }

  @objc func avatarPressed(_ sender: UIButton) {
    let vc = UploadImageViewController()
    vc.didUploadImage = { [weak self] image in
      self?.avatarImageView.image = image
    }
    present(vc, animated: true, completion: nil)
  }
}

extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {

  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    if UIDevice.current.iPad {
      return Constants.iPadCellHeight
    }

    return Constants.cellHeight
  }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return menuItems.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    if let cell = tableView.dequeueReusableCell(withIdentifier: "profileItemCell", for: indexPath) as? ProfileItemViewCell {
      let item = menuItems[indexPath.row]
      cell.updateContent(data: item, qrcode: self.userInfo?.refercode)
      if item.action ==  ProfileItemAction.qrcode.rawValue {
        cell.didCopyQRCode = { [weak self] in
          UIPasteboard.general.string = self?.userInfo?.refercode
          self?.jumpURL(optType: "recommended_app", title: "快乐彩票")
        }
      }
      return cell
    }

    return UITableViewCell()
  }

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
     let item = menuItems[indexPath.row]
    if item.action == "webview" {
      jumpURL(optType: item.key, title: item.webTitle)
    } else{
      if item.key == "logout" {
        logout()
      }
    }
  }
}

