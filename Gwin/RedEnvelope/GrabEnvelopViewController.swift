//
//  GrabEnvelopViewController.swift
//  Gwin
//
//  Created by Hai Vu Van on 8/24/19.
//  Copyright © 2019 Hai Vu Van. All rights reserved.
//

import UIKit

protocol GrabEnvelopPopupDelegate: AnyObject {
  func closePopup()
  func openPackageInfo(package: PackageInfoModel?, roomid: Int, packageid: Int64)
}

class GrabEnvelopViewController: UIViewController {

  @IBOutlet weak var grabButton: UIButton!
  @IBOutlet weak var avatarImageView: UIImageView!

  @IBOutlet weak var messageLabel: UILabel!
  @IBOutlet weak var usernoLabel: UILabel!
  @IBOutlet weak var amountLabel: UILabel!

  @IBOutlet weak var continueButton: UIButton!
  var package: PackageHistoryModel
  var delegate: GrabEnvelopPopupDelegate?
  init(package: PackageHistoryModel, delegate: GrabEnvelopPopupDelegate? = nil) {
    self.package =  package
    self.delegate = delegate
    super.init(nibName: "GrabEnvelopViewController", bundle: nil)
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    checkPackageExpeire()
    getPackageStatus()
    setupViews()
  }
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    SoundManager.shared.playBetSound()
  }

  func setupViews() {
    avatarImageView.rounded()
    ImageManager.shared.downloadImage(usernos: [package.userno]) {
      if let string = ImageManager.shared.getImage(userno: self.package.userno) {
        if let data = Data(base64Encoded: string, options: []) {
          self.avatarImageView.image = UIImage(data: data)
        }
      }
    }

    if package.packettag.count > 0 {
      amountLabel.text = "\(package.packetamount)-\(package.packettag)"
    }else {
      amountLabel.text = "\(package.packetamount)"
      messageLabel.text = "发了一个福利红包,金额随机"

    }
    usernoLabel.text = package.userno
  }

  func checkPackageExpeire() {

    let packageDate = package.wagertime.toDate()
    if let systemtime = RedEnvelopComponent.shared.systemtime {
      let timeinterval = systemtime - packageDate
      let hour = timeinterval / (60 * 60)

      if hour > Double(RedEnvelopComponent.limitTime) {
        grabButton.isHidden = true
        continueButton.isHidden = false
      }
    }
  }

  func showPackageInfoView() {

  }

  func getPackageStatus() {

    guard let user = RedEnvelopComponent.shared.user else { return }

    RedEnvelopAPIClient.statusPackage(ticket: user.ticket, roomid: package.roomid, packageid: package.packetid) {[weak self] (status, errorMessage) in
      if let `status` = status, status == .canGrab {
        self?.grabButton.isHidden = false
        self?.continueButton.isHidden = true

      }else {
        self?.grabButton.isHidden = true
        self?.continueButton.isHidden = false

      }
    }
  }

  @IBAction func grabPackagePressed(_ sender: Any) {

    guard let user = RedEnvelopComponent.shared.user else { return }

    RedEnvelopAPIClient.grabPackage(ticket: user.ticket, roomid: package.roomid, packageid: package.packetid) { [weak self ] (package, message) in
      guard let this = self else {return }
      this.dismiss(animated: true) {
        if let grabedPackage = package {
          this.delegate?.openPackageInfo(package: grabedPackage, roomid: this.package.roomid, packageid: this.package.packetid)
        }else {
          if let msg = message {
            this.messageLabel.text = msg
            this.messageLabel.isHidden = false
          }
        }
      }

    }
  }

  @IBAction func packageInfoPressed(_ sender: Any) {
    dismiss(animated: true) { [weak self] in
      guard let this = self else {return }
      this.delegate?.openPackageInfo(package: nil, roomid: this.package.roomid, packageid: this.package.packetid)
    }
  }

  @IBAction func closePressed(_ sender: Any) {
    dismiss(animated: true, completion: nil)
  }
}




