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

    let packageDate = package.wagertime.toDate()
    if let systemtime = RedEnvelopComponent.shared.systemtime {
      let timeinterval = systemtime - packageDate
      let hour = timeinterval / (60 * 60)

      if hour > Double(RedEnvelopComponent.limitTime) {
        grabButton.isHidden = true
      }
    }

    ImageManager.shared.downloadImage(usernos: [package.userno]) {
      if let string = ImageManager.shared.getImage(userno: self.package.userno) {
        if let data = Data(base64Encoded: string, options: []) {
          self.avatarImageView.image = UIImage(data: data)
        }
      }
    }
    // Do any additional setup after loading the view.
  }


  /*
   // MARK: - Navigation

   // In a storyboard-based application, you will often want to do a little preparation before navigation
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
   // Get the new view controller using segue.destination.
   // Pass the selected object to the new view controller.
   }
   */
  func showPackageInfoView() {

  }

  @IBAction func grabPackagePressed(_ sender: Any) {

    guard let user = RedEnvelopComponent.shared.user else { return }

    RedEnvelopAPIClient.grabPackage(ticket: user.ticket, roomid: package.roomid, packageid: package.packetid) { [weak self ] (grabedPackage, message) in
      guard let this = self else {return }
      this.dismiss(animated: true) {
        this.delegate?.openPackageInfo(package: grabedPackage, roomid: this.package.roomid, packageid: this.package.packetid)
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




