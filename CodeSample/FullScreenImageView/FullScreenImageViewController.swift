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
final class FullScreenImageViewController: UIViewController {
	private let blurEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
	private let scrollContainerView = UIView()
	private let imageScrollView = UIScrollView()
	private let imageView = UIImageView()
	private let titleContainerView = UIView()
	private let titleLabel = UILabel()
	private let closeButton = UIButton()
	private let activityIndicator = UIActivityIndicatorView()
    private let viewModel: FullScreenImageViewModel

	// MARK: initializers
	init(viewModel: FullScreenImageViewModel) {
		self.viewModel = viewModel
		super.init(nibName: nil, bundle: nil)
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

    // MARK: view lifecycle
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

    // MARK: private functions
	private func loadHighQualityPhoto() {
        guard let photoURL = viewModel.highQualityPhotoURL else {
			return
		}

		activityIndicator.startAnimating()

		imageView.af_setImage(
            withURL: photoURL,
            imageTransition: .crossDissolve(0.25),
            runImageTransitionIfCached: false
        ) { [weak self] (response) in
            guard let self else { return }
            if response.error != nil {
                self.loadDefaultPhoto()
            } else {
                self.activityIndicator.stopAnimating()
            }
		}
	}

	private func loadDefaultPhoto() {
        guard let photoURL = viewModel.standardQualityPhotoURL else {
			return
        }
        
        imageView.af_setImage(
            withURL: photoURL,
            imageTransition: .crossDissolve(0.25),
            runImageTransitionIfCached: false
        ) { [weak self] (response) in
            guard let self else { return }
            self.activityIndicator.stopAnimating()
            if let error = response.error {
                self.showAlert(title: "Failed to load the photo",
                               message: error.localizedDescription,
                               acknowledgement: "OK")
            }
        }
    }

	private func drawTitleGradientLayer() {
		let gradient = CAGradientLayer()
		gradient.frame = titleContainerView.bounds
		gradient.colors = [UIColor.black.cgColor, UIColor.clear.cgColor]
		titleContainerView.layer.insertSublayer(gradient, at: 0)
	}
}

// MARK: - `ViewBuilder`
extension FullScreenImageViewController: ViewBuilder {
    private enum Constants {
        static let containerViewVerticalPadding: CFloat = 100
        static let titleContainerHeight: CGFloat = 50
        static let imageMinimumZoom: CGFloat = 1
        static let imageMaximumZoom: CGFloat = 6
        static let closeButtonLeadingPadding: CGFloat = 20
        static let closeButtonTopPadding: CGFloat = 45
        static let closeButtonHeight: CGFloat = 44
    }
    
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

	private func addBlurEffectView() {
		view.addSubview(blurEffectView)

		blurEffectView.snp.makeConstraints { make in
			make.edges.equalToSuperview()
		}
	}

    private func addScrollContainerView() {
		view.addSubview(scrollContainerView)
		scrollContainerView.backgroundColor = .black

		scrollContainerView.snp.makeConstraints { make in
			make.leading.trailing.equalToSuperview()
            make.top.equalTo(self.view.safeAreaInsets.top).offset(Constants.containerViewVerticalPadding)
			make.bottom.equalTo(self.view.safeAreaInsets.bottom).inset(Constants.containerViewVerticalPadding)
		}
	}

    private func addImageScrollView() {
		scrollContainerView.addSubview(imageScrollView)
        imageScrollView.minimumZoomScale = Constants.imageMinimumZoom
        imageScrollView.maximumZoomScale = Constants.imageMaximumZoom
		imageScrollView.delegate = self

		imageScrollView.snp.makeConstraints { make in
			make.edges.equalToSuperview()
		}
	}

    private func addImageView() {
		imageScrollView.addSubview(imageView)
		imageView.backgroundColor = .black
		imageView.contentMode = .scaleAspectFit

		imageView.snp.makeConstraints { make in
			make.edges.equalToSuperview()
			make.center.equalToSuperview()
		}
	}

    private func addTitleContainerView() {
		view.addSubview(titleContainerView)

		titleContainerView.snp.makeConstraints { make in
			make.leading.trailing.equalTo(scrollContainerView)
			make.top.equalTo(scrollContainerView)
            make.height.equalTo(Constants.titleContainerHeight)
		}
	}

    private func addTitleLabel() {
		titleContainerView.addSubview(titleLabel)
		titleLabel.numberOfLines = 2
		titleLabel.textColor = .white
		titleLabel.font = .boldSystemFont(ofSize: 18)
		titleLabel.textAlignment = .center
		titleLabel.setContentHuggingPriority(.required, for: .vertical)
		titleLabel.adjustsFontSizeToFitWidth = true
		titleLabel.minimumScaleFactor = 0.75
        titleLabel.text = viewModel.photoTitle

		titleLabel.snp.makeConstraints { make in
			make.leading.trailing.equalToSuperview()
			make.top.equalToSuperview()
			make.height.lessThanOrEqualTo(titleContainerView)
		}
	}

    private func addActivityIndicator() {
		view.addSubview(activityIndicator)
		activityIndicator.style = .white

		activityIndicator.snp.makeConstraints { make in
			make.center.equalToSuperview()
		}
	}

    private func addCloseButton() {
		view.addSubview(closeButton)
		closeButton.setTitle("Close", for: .normal)
		closeButton.setTitleColor(.white, for: .normal)
		closeButton.setContentHuggingPriority(.required, for: .horizontal)

		closeButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(Constants.closeButtonLeadingPadding)
            make.top.equalTo(self.view.safeAreaInsets.top).offset(Constants.closeButtonTopPadding)
            make.height.equalTo(Constants.closeButtonHeight)
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
