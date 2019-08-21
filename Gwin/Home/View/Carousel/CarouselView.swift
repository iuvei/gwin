//
//  CarouselView.swift
//  Gwin
//
//  Created by Hai Vu Van on 8/18/19.
//  Copyright © 2019 Hai Vu Van. All rights reserved.
//

import UIKit
import Kingfisher

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

  init(dataSource: [String] = []) {
    self.dataSource = dataSource
    super.init(frame: .zero)
    setupViews()
    updateView(dataSource: dataSource)
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  func setupViews() {
    setupScrollView()
    setupPageControl()
  }

  func setupScrollView() {
    backgroundColor = .red
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
      imageView.contentMode = .scaleAspectFit

      if let imageData = Data(base64Encoded: dataSource[i], options: []){
        let image  = UIImage(data: imageData)
        imageView.image = image
      }

      contentView.addArrangedSubview(imageView)

      if i % 2 == 0 {
        imageView.backgroundColor = .blue
      } else {
        imageView.backgroundColor = .yellow
      }

      NSLayoutConstraint.activate([
        imageView.heightAnchor.constraint(equalTo: heightAnchor),
        imageView.widthAnchor.constraint(equalTo: widthAnchor)
        ])
    }

    scrollView.contentSize =  CGSize(width: frame.width * CGFloat(dataSource.count), height: 1.0)
  }
}

extension CarouselView: UIScrollViewDelegate {
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    let width = frame.size.width
    if width > 0 {
      let pageIndex = round(scrollView.contentOffset.x/frame.size.width)
      pageControl.currentPage = Int(pageIndex)
    }

    if scrollView.contentOffset.y > 0 || scrollView.contentOffset.y < 0 {
      scrollView.contentOffset.y = 0
    }
  }
}

