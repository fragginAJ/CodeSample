//
//  LocatorViewController.swift
//  CodeSample
//
//  Created by AJ Fragoso on 2/3/18.
//  Copyright © 2018 AJ Fragoso. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation
import SnapKit

/// `LocatorViewController` is the main interface of the app. The `LocatorButton` is displayed here as well as the
/// carousel of nearby Flickr photos.
public class LocatorViewController: UIViewController {
	// MARK: properties
	private let viewModel = LocatorViewModel()
	private let locatorButton = LocatorButton()
	private let carouselCollectionView = UICollectionView.init(frame: .zero, collectionViewLayout: CarouselFlowLayout())
	private let carouselCollectionViewDelegate = CarouselCollectionViewDelegate()

	public override func viewDidLoad() {
		super.viewDidLoad()

		viewModel.controller = self

		styleView()
		addSubviews()

		addInteractionResponses()
	}

	// MARK: internal functions
	func updateLocationName(_ locationName: String?) {
		locatorButton.updateLocationName(locationName)
	}

	func didUpdatePhotos(_ photos: [FlickrPhoto]) {
		carouselCollectionViewDelegate.updatePhotoArray(photos)
	}

	func didSelectPhoto(_ photo: FlickrPhoto) {
		let imageViewer = FullScreenImageViewController(photo: photo)
		present(imageViewer, animated: true)
	}
}

// MARK: - `ViewBuilder` -
extension LocatorViewController: ViewBuilder {
	func styleView() {
		modalPresentationStyle = .overCurrentContext
	}

	func addSubviews() {
		addLocatorButton()
		addCarouselCollectionView()
	}

	func addLocatorButton() {
		view.addSubview(locatorButton)

		locatorButton.snp.makeConstraints { make in
			make.centerX.equalToSuperview()
			make.leading.greaterThanOrEqualToSuperview().offset(15).priority(999)
			make.trailing.greaterThanOrEqualToSuperview().inset(15).priority(999)
			make.bottom.equalTo(self.view.safeAreaInsets.bottom).inset(120)
		}
	}

	func addCarouselCollectionView() {
		view.addSubview(carouselCollectionView)
		view.sendSubviewToBack(carouselCollectionView)
		carouselCollectionView.backgroundColor = .white
		carouselCollectionViewDelegate.setupCollectionView(carouselCollectionView, inside: self)

		carouselCollectionView.snp.makeConstraints { make in
			make.leading.trailing.equalToSuperview()
			make.bottom.equalTo(locatorButton.snp.top)
			make.top.equalTo(self.view.safeAreaInsets.top).inset(50)
		}
	}
}

// MARK: - `InteractionResponder` -
extension LocatorViewController: InteractionResponder {
	func addInteractionResponses() {
		locatorButton.addTarget(self, action: #selector(geolocate), for: .touchUpInside)
	}

	@objc func geolocate() {
		locatorButton.startPulse()
		viewModel.geolocate()
	}
}
