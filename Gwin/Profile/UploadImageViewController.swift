//
//  UploadImageViewController.swift
//  Gwin
//
//  Created by Hai Vu Van on 9/1/19.
//  Copyright © 2019 Hai Vu Van. All rights reserved.
//

import UIKit

class UploadImageViewController: BaseViewController {

  enum Constants {
    static let imageSize: CGFloat = 500
  }

  @IBOutlet weak var backButton: UIButton!
  @IBOutlet weak var cameraButton: UIButton!

  @IBOutlet weak var galaryButton: UIButton!
  @IBOutlet weak var confirmButton: UIButton!
  @IBOutlet weak var exitButton: UIButton!
  @IBOutlet weak var usernoLabel: UILabel!

  @IBOutlet weak var avatarImageView: UIImageView!
  private lazy var imagePicker: UIImagePickerController = {
    let picker =  UIImagePickerController()
    picker.delegate = self
    return picker
  }()

  private var uploadImage: UIImage? = nil
  var didUploadImage: (UIImage)->Void = {_ in}

  init() {
    super.init(nibName: "UploadImageViewController", bundle: nil)
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    // Do any additional setup after loading the view.
    setupViews()
    updateViews()

  }

  func setupViews (){
    cameraButton.imageView?.contentMode = .scaleAspectFit
    galaryButton.imageView?.contentMode = .scaleAspectFit
    backButton.addTarget(self, action: #selector(backPressed(_:)), for: .touchUpInside)
    confirmButton.rounded()
    exitButton.rounded()
  }

  func updateViews(){
    guard let userno = RedEnvelopComponent.shared.userno else { return }
    usernoLabel.text = userno

    if let imgString = ImageManager.shared.getImage(userno: userno) {
      if let data = Data(base64Encoded: imgString, options: []) {
        avatarImageView.image = UIImage(data: data)
      }
    } else {
      guard let user = RedEnvelopComponent.shared.user else { return }
      UserAPIClient.getUserImages(ticket: user.ticket, usernos: [userno]) {[weak self] (data, _) in
        guard let _data = data else { return }
        for json in _data {
          let userno = json["userno"].stringValue
          let imgString = json["img"].stringValue
          if let data = Data(base64Encoded: imgString, options: []) {
            self?.avatarImageView.image = UIImage(data: data)
            ImageManager.shared.saveImage(userno: userno, image: imgString)
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

  @IBAction func cameraPressed(_ sender: Any) {

    imagePicker.sourceType = .camera
    present(imagePicker, animated: true, completion: nil)
  }

  @IBAction func galaryPressed(_ sender: Any) {
    if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum){

      imagePicker.sourceType = .savedPhotosAlbum
      imagePicker.allowsEditing = true

      present(imagePicker, animated: true, completion: nil)
    }

  }
  @IBAction func confirmPressed(_ sender: Any) {
    guard let user = RedEnvelopComponent.shared.user else { return }
    guard let userno = RedEnvelopComponent.shared.userno else { return }
    guard let image = uploadImage else { return }

    guard let resizedImage = resizeImage(image: image, targetSize: CGSize(width: Constants.imageSize, height: Constants.imageSize)) else {return}

    let imageBase64 = ImageManager.convertImageToBase64(image: resizedImage)
    showLoadingView()
    UserAPIClient.uploadImage(ticket: user.ticket, userno: userno, img: imageBase64) { [weak self] (success, error) in
      self?.hideLoadingView()
      if success {
        ImageManager.shared.saveImage(userno: userno, image: imageBase64)
        self?.didUploadImage(resizedImage)
        self?.dismiss(animated: true, completion: nil)
      }else {
        if let message = error {
          self?.showAlertMessage(message: message)
        }
      }
    }
  }

  @IBAction func exitPressed(_ sender: Any) {
    dismiss(animated: true, completion: nil)
  }



}

extension UploadImageViewController {
 fileprivate func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage? {
    let size = image.size

    let widthRatio  = targetSize.width  / size.width
    let heightRatio = targetSize.height / size.height

    // Figure out what our orientation is, and use that to form the rectangle
    var newSize: CGSize
    if(widthRatio > heightRatio) {
      newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
    } else {
      newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
    }

    // This is the rect that we've calculated out and this is what is actually used below
  let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)

    // Actually do the resizing to the rect using the ImageContext stuff
    UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
  image.draw(in: rect)
    let newImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()

    return newImage
  }
}
extension UploadImageViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    imagePicker.dismiss(animated: true, completion: nil)
    if let editImage = info[.editedImage] as? UIImage{
      uploadImage = editImage
    }else {
      uploadImage = info[.originalImage] as? UIImage
    }
    avatarImageView.image = uploadImage
  }
}



