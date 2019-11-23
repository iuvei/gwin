//
//  CountDownView.swift
//  Gwin
//
//  Created by Hai Vu Van on 11/23/19.
//  Copyright © 2019 Hai Vu Van. All rights reserved.
//

import Foundation
import UIKit

class CountDownView: UIView {

  private lazy var numberLabel: UILabel = {
    let label = UILabel().forAutolayout()
    label.textAlignment = .center
    label.textColor = UIColor.lightGray
    label.font = UIFont.systemFont(ofSize: 120)

    return label
  }()

  var count: Int = 5
  var timer: Timer?
  var fadeTimer: Timer?

  init(){
    super.init(frame: .zero)
    setupViews()
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  func setupViews() {
//    backgroundColor = .red
    addSubview(numberLabel)

    NSLayoutConstraint.activate([
      numberLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
      numberLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
      numberLabel.leftAnchor.constraint(equalTo: leftAnchor),
      numberLabel.topAnchor.constraint(equalTo: topAnchor, constant: 0)
      ])
  }


  func startAnimation() {
    count =  5
    timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(update), userInfo: nil, repeats: true)

  }

  func stopAnimation() {
    timer?.invalidate()
    timer = nil

    removeFromSuperview()
  }

  @objc func update() {
    if(count >= 0) {
      numberLabel.alpha = 1
      numberLabel.text = "\(count)"
      UIView.animate(withDuration: 0.7, animations: {[weak self] in
        self?.numberLabel.alpha = 0
      })
      count -= 1
    } else {
      stopAnimation()
    }
  }
}
