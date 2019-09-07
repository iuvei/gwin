//
//  HomeViewController.swift
//  Gwin
//
//  Created by Hai Vu Van on 8/18/19.
//  Copyright © 2019 Hai Vu Van. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import MarqueeLabel

protocol HomeViewInput: AnyObject {
  func updatePopularizeImage(images: [String])
}

protocol HomeViewOutput: AnyObject {
  func viewDidLoad()
}

public protocol HomeViewControllerInput: AnyObject {
}

class HomeViewController: BaseViewController {

  enum Constants {
    static let seperateHeight: CGFloat = 1
  }

  weak var output: HomeViewOutput?

  private var carouselView: CarouselView!

  private var messageView: UIView = {
    let view = UIView()
    view.translatesAutoresizingMaskIntoConstraints = false
    view.backgroundColor = .white
    return view
  }()

  private var messageLabel: ScrollLabel = {
    var label = ScrollLabel().forAutolayout()
    return label
  }()

  private lazy var volumeImageView: UIImageView = {
    let image = UIImageView().forAutolayout()
    image.image = UIImage(named: "image_volume")
    image.contentMode = .scaleAspectFit
    return image
  }()

  private lazy var volumSeperateView: UIView = {
    let view = UIView().forAutolayout()
    view.backgroundColor = .groupTableViewBackground
    return view
  }()

  private var scrollView: UIScrollView = {
    let scrollView = UIScrollView()
    scrollView.translatesAutoresizingMaskIntoConstraints = false
    scrollView.backgroundColor = .white
    return scrollView
  }()

  private lazy var contentView: UIView = {
    let view = UIView()
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()

  private lazy var containerStackView: UIStackView = {
    let view = UIStackView()
    view.translatesAutoresizingMaskIntoConstraints = false
    view.axis = .vertical
    view.distribution = .fill
    return view
  }()
  private var popupVc: MessagePopupController?

  private var lobbies: [LobbyItemModel] = []

  override func viewDidLoad() {
    super.viewDidLoad()
    setTitle(title: AppText.Titles.home)
    self.edgesForExtendedLayout = []
    // Do any additional setup after loading the view.
    loadLobbyData()
    setupViews()
    fetchPopularizeImage()
    fetchRollMessage()
    fetchPopupMessage()
    fetchUserStatus()
    bindDataToView()
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    hideBackButton()
  }

  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    popupVc?.dismiss(animated: true, completion: nil)
  }
  /*
   // MARK: - Navigation

   // In a storyboard-based application, you will often want to do a little preparation before navigation
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
   // Get the new view controller using segue.destination.
   // Pass the selected object to the new view controller.
   }
   */

  func setupViews() {
    carouselView = CarouselView()
    carouselView.translatesAutoresizingMaskIntoConstraints = false

    view.addSubview(carouselView)
    view.addSubview(messageView)

    NSLayoutConstraint.activate([
      carouselView.leftAnchor.constraint(equalTo: view.leftAnchor),
      carouselView.topAnchor.constraint(equalTo: view.topAnchor),
      carouselView.rightAnchor.constraint(equalTo: view.rightAnchor),
      carouselView.heightAnchor.constraint(equalTo: carouselView.widthAnchor, multiplier: 3.0 / 5.0),

      messageView.leftAnchor.constraint(equalTo: view.leftAnchor),
      messageView.topAnchor.constraint(equalTo: carouselView.bottomAnchor),
      messageView.rightAnchor.constraint(equalTo: view.rightAnchor),
      messageView.heightAnchor.constraint(equalToConstant: 30),
      ])


    messageView.addSubview(messageLabel)
    messageView.addSubview(volumeImageView)
    messageView.addSubview(volumSeperateView)

    NSLayoutConstraint.activate([
      volumeImageView.leftAnchor.constraint(equalTo: messageView.leftAnchor),
      volumeImageView.topAnchor.constraint(equalTo: messageView.topAnchor, constant: 4),
      volumeImageView.centerYAnchor.constraint(equalTo: messageView.centerYAnchor),
      volumeImageView.widthAnchor.constraint(equalTo: volumeImageView.heightAnchor),
      //
      volumSeperateView.leftAnchor.constraint(equalTo: volumeImageView.rightAnchor),
      volumSeperateView.widthAnchor.constraint(equalToConstant: 1),
      volumSeperateView.centerYAnchor.constraint(equalTo: messageView.centerYAnchor),
      volumSeperateView.topAnchor.constraint(equalTo: messageView.topAnchor, constant: 5),

      //
      messageLabel.leftAnchor.constraint(equalTo: volumeImageView.rightAnchor, constant: 5),
      messageLabel.centerYAnchor.constraint(equalTo: messageView.centerYAnchor),
      messageLabel.rightAnchor.constraint(equalTo: messageView.rightAnchor),
      messageLabel.heightAnchor.constraint(equalTo: messageView.heightAnchor)
      ])
    //
    setupScrollView()
  }

  func setupScrollView() {

    view.addSubview(scrollView)
    scrollView.addSubview(contentView)
    contentView.addSubview(containerStackView)

    NSLayoutConstraint.activate([
      scrollView.leftAnchor.constraint(equalTo: view.leftAnchor),
      scrollView.topAnchor.constraint(equalTo: messageView.bottomAnchor),
      scrollView.rightAnchor.constraint(equalTo: view.rightAnchor),
      scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

      contentView.leftAnchor.constraint(equalTo: scrollView.leftAnchor),
      contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
      contentView.rightAnchor.constraint(equalTo: scrollView.rightAnchor),
      contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
      contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),

      containerStackView.leftAnchor.constraint(equalTo: contentView.leftAnchor),
      containerStackView.topAnchor.constraint(equalTo: contentView.topAnchor),
      containerStackView.rightAnchor.constraint(equalTo: contentView.rightAnchor),

      contentView.heightAnchor.constraint(equalTo: containerStackView.heightAnchor)
      ])
  }
  func loadLobbyData() {
    if let path = Bundle.main.path(forResource: "LobbyJson", ofType: "json") {
      do {
        let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
        let jsonObj = try JSON(data: data).array

        jsonObj?.forEach{ json in
          let lobby = LobbyItemModel(dictionary: json)
          lobbies.append(lobby)
        }
      } catch {
        // handle error
        print("Abcdef")
      }
    }

  }

  func bindDataToView() {
    let stackView1 = getStackView()
    let seperateColor = UIColor(hexString: "#f6f6f6")
    let firstSeperateView = UIView().forAutolayout()
    firstSeperateView.backgroundColor = seperateColor
    containerStackView.addArrangedSubview(firstSeperateView)
    containerStackView.addArrangedSubview(stackView1)
    let itemHeight = view.frame.width / 4

    NSLayoutConstraint.activate([
      stackView1.leftAnchor.constraint(equalTo: containerStackView.leftAnchor),
      stackView1.rightAnchor.constraint(equalTo: containerStackView.rightAnchor),
      stackView1.heightAnchor.constraint(equalToConstant: itemHeight)
      ])

    let buttonSize = view.frame.width / 4
    var lobbyIndex = 0
    if lobbies.count <= 0 {
      return
    }
    for _ in 0..<4 {
      let button = LobbyItemView(model: lobbies[lobbyIndex], output: self)
      button.translatesAutoresizingMaskIntoConstraints = false

      NSLayoutConstraint.activate([
        button.widthAnchor.constraint(equalToConstant: buttonSize),
        //button.heightAnchor.constraint(equalToConstant: itemHeight),
        ])
      stackView1.addArrangedSubview(button)
      lobbyIndex += 1
    }

    //layout 2 games boom and bull
    let secondSeperateView = UIView().forAutolayout()
    secondSeperateView.backgroundColor = seperateColor

    let firstGametitleLabel = TitleStackView(prefix: "红包专场", title: "抢红包新玩法来袭").forAutolayout()
    let stackView2 = getStackView()
    containerStackView.addArrangedSubview(secondSeperateView)
    containerStackView.addArrangedSubview(firstGametitleLabel)
    containerStackView.addArrangedSubview(stackView2)
    NSLayoutConstraint.activate([
      firstSeperateView.leftAnchor.constraint(equalTo: containerStackView.leftAnchor),
      firstSeperateView.rightAnchor.constraint(equalTo: containerStackView.rightAnchor),
      firstSeperateView.heightAnchor.constraint(equalToConstant: Constants.seperateHeight),
      secondSeperateView.leftAnchor.constraint(equalTo: containerStackView.leftAnchor),
      secondSeperateView.rightAnchor.constraint(equalTo: containerStackView.rightAnchor),
      secondSeperateView.heightAnchor.constraint(equalToConstant: Constants.seperateHeight),

      firstGametitleLabel.leftAnchor.constraint(equalTo: containerStackView.leftAnchor, constant: 10),
      firstGametitleLabel.rightAnchor.constraint(equalTo: containerStackView.rightAnchor),
      firstGametitleLabel.heightAnchor.constraint(equalToConstant: 35),

      stackView2.leftAnchor.constraint(equalTo: containerStackView.leftAnchor),
      stackView2.rightAnchor.constraint(equalTo: containerStackView.rightAnchor),
      stackView2.heightAnchor.constraint(equalToConstant: itemHeight)
      ])

    let item2Width = view.frame.width / 2

    for _ in 0..<2 {
      let button = LobbyItemView(model: lobbies[lobbyIndex], axis: .horizontal, output: self)
      button.translatesAutoresizingMaskIntoConstraints = false
      NSLayoutConstraint.activate([
        button.widthAnchor.constraint(equalToConstant: item2Width),
        //button.heightAnchor.constraint(equalToConstant: itemHeight),
        ])
      stackView2.addArrangedSubview(button)
      lobbyIndex += 1
    }

    //
    let lastSeperateView = UIView().forAutolayout()
    lastSeperateView.backgroundColor = seperateColor
    let lasttitleLabel = TitleStackView(prefix: "快乐彩票", title: " 20分钟一期 , 实时结算").forAutolayout()
    let stackView3 = getStackView()
    containerStackView.addArrangedSubview(lastSeperateView)
    containerStackView.addArrangedSubview(lasttitleLabel)
    containerStackView.addArrangedSubview(stackView3)

    NSLayoutConstraint.activate([
      lastSeperateView.leftAnchor.constraint(equalTo: containerStackView.leftAnchor),
      lastSeperateView.rightAnchor.constraint(equalTo: containerStackView.rightAnchor),
      lastSeperateView.heightAnchor.constraint(equalToConstant: Constants.seperateHeight),

      lasttitleLabel.leftAnchor.constraint(equalTo: containerStackView.leftAnchor, constant: 10),
      lasttitleLabel.rightAnchor.constraint(equalTo: containerStackView.rightAnchor),
      lasttitleLabel.heightAnchor.constraint(equalToConstant: 35),

      stackView3.leftAnchor.constraint(equalTo: containerStackView.leftAnchor),
      stackView3.rightAnchor.constraint(equalTo: containerStackView.rightAnchor)
      ])

    let item3Width = view.frame.width / 4

    for _ in 0..<4 {
      let button = LobbyItemView(model: lobbies[lobbyIndex], output: self)
      button.translatesAutoresizingMaskIntoConstraints = false

      NSLayoutConstraint.activate([
        button.widthAnchor.constraint(equalToConstant: item3Width),
        //button.heightAnchor.constraint(equalToConstant: itemHeight),
        ])

      stackView3.addArrangedSubview(button)
      lobbyIndex += 1
    }

    //
    //
    let stackView4 = getStackView()
    containerStackView.addArrangedSubview(stackView4)
    NSLayoutConstraint.activate([
      stackView4.leftAnchor.constraint(equalTo: containerStackView.leftAnchor),
      stackView4.rightAnchor.constraint(equalTo: containerStackView.rightAnchor)
      ])

    let item4Width = view.frame.width / 4

    for _ in 0..<4 {
      let button = LobbyItemView(model: lobbies[lobbyIndex], row: 2, output: self)
      button.translatesAutoresizingMaskIntoConstraints = false

      NSLayoutConstraint.activate([
        button.widthAnchor.constraint(equalToConstant: item4Width)
        ])

      stackView4.addArrangedSubview(button)
      lobbyIndex += 1
    }
  }

  private func getStackView() -> UIStackView {
    let view = UIStackView()
    view.translatesAutoresizingMaskIntoConstraints = false
    view.axis = .horizontal
    view.distribution = .fill
    return view
  }

  private func getLabel(title: String) -> UILabel {
    let label = UILabel().forAutolayout()
    label.text = title
    return label
  }

  func fetchPopularizeImage() {

    guard let user = RedEnvelopComponent.shared.user else { return }

    NoticeAPIClient.getPopularizeImage(ticket: user.ticket) { [weak self] (images, msg) in
      guard let this = self else { return  }
      this.carouselView.updateView(dataSource: images)
    }
  }

  func fetchRollMessage() {
    guard let user = RedEnvelopComponent.shared.user else { return }

    NoticeAPIClient.getRollMsg(ticket: user.ticket, msgType: 0) { [weak self] (rollMsg, msg) in
      guard let this = self else { return  }
      RedEnvelopComponent.shared.rollMsg = rollMsg
      this.messageLabel.updateContent(message: rollMsg)
    }

    UserAPIClient.otherH5(ticket: user.ticket, optype: Optype.recommended_app) { (abc, xyz) in

    }
  }

  func fetchPopupMessage() {
    if  UserDefaultManager.sharedInstance().isShowPoupMessage() != nil { return }

    guard let user = RedEnvelopComponent.shared.user else { return }
    guard let userno = RedEnvelopComponent.shared.userno else { return }

    NoticeAPIClient.getPopupMsg(ticket: user.ticket) { [weak self] (message, errormessage) in
      guard let this = self else {return}
      if message.count > 0 {
        UserDefaultManager.sharedInstance().didShowPopupMessage(userno: userno)
        let vc = MessagePopupController(message: message)
          this.popupVc = vc
          vc.modalPresentationStyle = .overCurrentContext
          this.present(vc, animated: true, completion: nil)

      }
    }
  }

  func fetchUserStatus() {
    if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
      appDelegate.startFetchUserStatus()
    }
  }
}

extension HomeViewController: HomeViewInput {
  func updatePopularizeImage(images: [String]) {
    carouselView.updateView(dataSource: images)
  }
}

extension HomeViewController: HomeViewControllerInput {

}

extension HomeViewController: LobbyItemViewOuput {
  func pressedLobbyItem(model: LobbyItemModel) {
    guard let user = RedEnvelopComponent.shared.user else { return }

    if model.action == "lottery" {

      RedEnvelopAPIClient.lottery(ticket: user.ticket, gameno: model.key) { (gameurl, def) in
        print("Abcddef")
        if let url = gameurl {
          let webController = WebContainerController(url: url)
          self.present(webController, animated:true, completion:nil)
        }
      }
    }else if model.action == "user" {
      UserAPIClient.otherH5(ticket: user.ticket, optype: model.key) { (abc, def) in
        if let url = abc {
          let webController = WebContainerController(url: url)
          self.present(webController, animated:true, completion:nil)
        }
      }
    }else if model.action == "envelop" {
      let key = Int(model.key) ?? 0
      if let appDelegate = UIApplication.shared.delegate as? AppDelegate, let index =  TabIndex(rawValue:key){
        appDelegate.selectTabIndex(index: index)
      }
    }else{

    }

  }
}



