//
//  CarouselView.swift
//  Gwin
//
//  Created by Hai Vu Van on 8/18/19.
//  Copyright © 2019 Hai Vu Van. All rights reserved.
//

import UIKit
//import Kingfisher

class CarouselView: UIView {

  var dataSource: [String]
  var scrollView: UIScrollView!

  private var pageControl: UIPageControl  = {
    let pageControl = UIPageControl()
    pageControl.translatesAutoresizingMaskIntoConstraints = false

    return pageControl
  }()

  private var contentView: UIStackView = {
    let view = UIStackView()
    view.translatesAutoresizingMaskIntoConstraints = false
    view.axis = .horizontal
    view.distribution = .fill

    return view
  }()

  private var contentViewWidthConstraint: NSLayoutConstraint?
  private var timer: Timer?
  private var index: Int = 0

  init(dataSource: [String] = []) {
    self.dataSource = dataSource
    super.init(frame: .zero)
    setupViews()
    updateView(dataSource: dataSource)
    timer = Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(autoScroll), userInfo: nil, repeats: true)
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  deinit {
    timer?.invalidate()
    timer = nil
  }

  func setupViews() {
    setupScrollView()
    setupPageControl()
  }

  func setupScrollView() {
    backgroundColor = .groupTableViewBackground
    scrollView = UIScrollView()
    scrollView.translatesAutoresizingMaskIntoConstraints = false
    scrollView.delegate = self
    scrollView.isPagingEnabled = true
    scrollView.showsVerticalScrollIndicator = false
    addSubview(scrollView)
    scrollView.addSubview(contentView)

    NSLayoutConstraint.activate([
      scrollView.topAnchor.constraint(equalTo: topAnchor),
      scrollView.leftAnchor.constraint(equalTo: leftAnchor),
      scrollView.bottomAnchor.constraint(equalTo: bottomAnchor),
      scrollView.rightAnchor.constraint(equalTo: rightAnchor),

      contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
      contentView.leftAnchor.constraint(equalTo: scrollView.leftAnchor),
      contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
      scrollView.rightAnchor.constraint(equalTo: contentView.rightAnchor),
      contentView.heightAnchor.constraint(equalTo: heightAnchor)
      ])
  }

  func setupPageControl() {
    addSubview(pageControl)

    NSLayoutConstraint.activate([
      pageControl.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 10),
      pageControl.centerXAnchor.constraint(equalTo: centerXAnchor)
      ])
  }

  func updateView(dataSource: [String]) {
    self.dataSource = dataSource
    pageControl.numberOfPages = dataSource.count
    pageControl.currentPage = 0

    contentView.removeAllArrangedSubviews()

    for i in 0 ..< dataSource.count {
      let imageView = UIImageView()
      imageView.translatesAutoresizingMaskIntoConstraints = false
      imageView.contentMode = .scaleAspectFill

      if let imageData = Data(base64Encoded: dataSource[i], options: []){
        let image  = UIImage(data: imageData)
        imageView.image = image
      }
      imageView.backgroundColor = .groupTableViewBackground
      contentView.addArrangedSubview(imageView)

      NSLayoutConstraint.activate([
        imageView.heightAnchor.constraint(equalTo: heightAnchor),
        imageView.widthAnchor.constraint(equalTo: widthAnchor)
        ])
    }

    scrollView.contentSize =  CGSize(width: frame.width * CGFloat(dataSource.count), height: 1.0)
  }

  @objc func autoScroll() {
    if dataSource.count > 0 {
      index = (index + 1) % dataSource.count
      let width = UIScreen.main.bounds.width
      scrollView.setContentOffset(CGPoint(x: (CGFloat)(index) * width , y: 0), animated: true)
      pageControl.currentPage = index
    }

  }
}

extension CarouselView: UIScrollViewDelegate {
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    let width = frame.size.width
    if width > 0 {
      let pageIndex = round(scrollView.contentOffset.x/frame.size.width)
      index = Int(pageIndex)
      pageControl.currentPage = Int(pageIndex)
    }

    if scrollView.contentOffset.y > 0 || scrollView.contentOffset.y < 0 {
      scrollView.contentOffset.y = 0
    }
  }
}

