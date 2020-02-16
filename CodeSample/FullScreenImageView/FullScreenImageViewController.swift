//
//  FullScreenImageViewController.swift
//  CodeSample
//
//  Created by AJ Fragoso on 2/10/18.
//  Copyright © 2018 AJ Fragoso. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
import AlamofireImage

/// `FullScreenImageViewController` displays a high quality Flickr image selected by the user and affords basic zooming
/// capabilities.
class FullScreenImageViewController: UIViewController {
	private let blurEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
	private let scrollContainerView = UIView()
	private let imageScrollView = UIScrollView()
	private let imageView = UIImageView()
	private let titleContainerView = UIView()
	private let titleLabel = UILabel()
	private let closeButton = UIButton()
	private let activityIndicator = UIActivityIndicatorView()
	private let photo: FlickrPhoto

	// MARK: initializers
	init(photo: FlickrPhoto) {
		self.photo = photo
		super.init(nibName: nil, bundle: nil)
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	override func viewDidLoad() {
		super.viewDidLoad()

		styleView()
		addSubviews()
		addInteractionResponses()

		loadHighQualityPhoto()
	}

	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		imageScrollView.contentSize = imageView.frame.size
		drawTitleGradientLayer()
	}

	// MARK: internal functions
	func loadHighQualityPhoto() {
		guard let photoURL = URL(string: photo.source(size: FlickrPhoto.Size.large1024)) else {
			return
		}

		activityIndicator.startAnimating()

		imageView.af_setImage(withURL: photoURL,
							  imageTransition: .crossDissolve(0.25),
							  runImageTransitionIfCached: false) { [weak self] (response) in
								if response.error != nil {
									self?.loadDefaultPhoto()
								} else {
									self?.activityIndicator.stopAnimating()
								}
		}
	}

	func loadDefaultPhoto() {
		guard let photoURL = URL(string: photo.source()) else {
			return
		}

		imageView.af_setImage(withURL: photoURL,
							  imageTransition: .crossDissolve(0.25),
							  runImageTransitionIfCached: false) { [weak self] (response) in
								self?.activityIndicator.stopAnimating()
								if let error = response.error {
									self?.showAlert(title: "Failed to load the photo",
																	 message: error.localizedDescription,
																	 acknowledgement: "OK")
								}
		}
	}

	// MARK: private functions
	private func drawTitleGradientLayer() {
		let gradient = CAGradientLayer()
		gradient.frame = titleContainerView.bounds
		gradient.colors = [UIColor.black.cgColor, UIColor.clear.cgColor]
		titleContainerView.layer.insertSublayer(gradient, at: 0)
	}
}

// MARK: - `ViewBuilder`
extension FullScreenImageViewController: ViewBuilder {
	func styleView() {
		view.backgroundColor = .clear
		modalTransitionStyle = .crossDissolve
	}

	func addSubviews() {
		addBlurEffectView()
		addScrollContainerView()
		addImageScrollView()
		addImageView()
		addTitleContainerView()
		addTitleLabel()
		addActivityIndicator()
		addCloseButton()
	}

	func addBlurEffectView() {
		view.addSubview(blurEffectView)

		blurEffectView.snp.makeConstraints { make in
			make.edges.equalToSuperview()
		}
	}

	func addScrollContainerView() {
		view.addSubview(scrollContainerView)
		scrollContainerView.backgroundColor = .black

		scrollContainerView.snp.makeConstraints { make in
			make.leading.trailing.equalToSuperview()
			make.top.equalTo(self.view.safeAreaInsets.top).offset(100)
			make.bottom.equalTo(self.view.safeAreaInsets.bottom).inset(100)
		}
	}

	func addImageScrollView() {
		scrollContainerView.addSubview(imageScrollView)
		imageScrollView.minimumZoomScale = 1.0
		imageScrollView.maximumZoomScale = 6.0
		imageScrollView.delegate = self

		imageScrollView.snp.makeConstraints { make in
			make.edges.equalToSuperview()
		}
	}

	func addImageView() {
		imageScrollView.addSubview(imageView)
		imageView.backgroundColor = .black
		imageView.contentMode = .scaleAspectFit

		imageView.snp.makeConstraints { make in
			make.edges.equalToSuperview()
			make.center.equalToSuperview()
		}
	}

	func addTitleContainerView() {
		view.addSubview(titleContainerView)

		titleContainerView.snp.makeConstraints { make in
			make.leading.trailing.equalTo(scrollContainerView)
			make.top.equalTo(scrollContainerView)
			make.height.equalTo(50)
		}
	}

	func addTitleLabel() {
		titleContainerView.addSubview(titleLabel)
		titleLabel.numberOfLines = 2
		titleLabel.textColor = .white
		titleLabel.font = .boldSystemFont(ofSize: 18)
		titleLabel.textAlignment = .center
		titleLabel.setContentHuggingPriority(.required, for: .vertical)
		titleLabel.adjustsFontSizeToFitWidth = true
		titleLabel.minimumScaleFactor = 0.75
		titleLabel.text = photo.title

		titleLabel.snp.makeConstraints { make in
			make.leading.trailing.equalToSuperview()
			make.top.equalToSuperview()
			make.height.lessThanOrEqualTo(titleContainerView)
		}
	}

	func addActivityIndicator() {
		view.addSubview(activityIndicator)
		activityIndicator.style = .white

		activityIndicator.snp.makeConstraints { make in
			make.center.equalToSuperview()
		}
	}

	func addCloseButton() {
		view.addSubview(closeButton)
		closeButton.setTitle("Close", for: .normal)
		closeButton.setTitleColor(.white, for: .normal)
		closeButton.setContentHuggingPriority(.required, for: .horizontal)

		closeButton.snp.makeConstraints { make in
			make.leading.equalToSuperview().offset(20)
			make.top.equalTo(self.view.safeAreaInsets.top).offset(45)
			make.height.equalTo(44.0)
		}
	}
}

// MARK: - `InteractionResponder` -
extension FullScreenImageViewController: InteractionResponder {
	func addInteractionResponses() {
		closeButton.addTarget(self, action: #selector(close), for: .touchUpInside)

		let tapGesture = UITapGestureRecognizer(target: self, action: #selector(toggleTitle))
		scrollContainerView.addGestureRecognizer(tapGesture)
	}

	@objc func close() {
		dismiss(animated: true)
	}

	@objc func toggleTitle() {
		UIView.animate(withDuration: 0.25) {
			self.titleContainerView.alpha = self.titleContainerView.alpha > 0 ? 0 : 1
		}
	}
}

// MARK: - `UIScrollViewDelegate` -
extension FullScreenImageViewController: UIScrollViewDelegate {
	func viewForZooming(in scrollView: UIScrollView) -> UIView? {
		return imageView
	}
}
