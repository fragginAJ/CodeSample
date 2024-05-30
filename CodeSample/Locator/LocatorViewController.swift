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
public final class LocatorViewController: UIViewController {
	// MARK: properties
    private let viewModel: LocatorViewModel
	private let locatorButton = LocatorButton()
	private let carouselCollectionView = UICollectionView.init(frame: .zero, collectionViewLayout: CarouselFlowLayout())
	private let carouselCollectionViewDelegate = CarouselCollectionViewDelegate()

    // MARK: initializers
    init(viewModel: LocatorViewModel = LocatorViewModel()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        viewModel.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: view lifecycle
	public override func viewDidLoad() {
		super.viewDidLoad()
		styleView()
		addSubviews()
		addInteractionResponses()
	}

	// MARK: internal functions
	func didSelectPhoto(_ photo: FlickrPhoto) {
		let imageViewer = FullScreenImageViewController(photo: photo)
		present(imageViewer, animated: true)
	}
    
    // MARK: private functions
    private func loadPhotos() {
        viewModel.requestPhotos { [weak self] error in
            guard let self else { return }
            
            if let error {
                self.handleError(error)
            }
            
            self.handleUpdatedPhotos()
        }
    }
    
    private func handleUpdatedPhotos() {
        carouselCollectionViewDelegate.updatePhotoArray(viewModel.photos)
    }
    
    private func handleUpdatedLocation() {
        locatorButton.updateLocationName(viewModel.locationName)
        loadPhotos()
    }
    
    private func handleError(_ error: Error) {
        showAlert(title: "Uh oh. Something's wrong",
                  message: error.localizedDescription,
                  acknowledgement: "OK")
    }
}

// MARK: - `ViewBuilder` -
extension LocatorViewController: ViewBuilder {
    private enum Constants {
        static let locatorButtonHorizontalPadding: CGFloat = 15
        static let locatorButtonBottomPadding: CGFloat = 120
        static let carouselTopPadding: CGFloat = 50
    }
    
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
            make.leading.greaterThanOrEqualToSuperview().offset(Constants.locatorButtonHorizontalPadding).priority(.high)
            make.trailing.greaterThanOrEqualToSuperview().inset(Constants.locatorButtonHorizontalPadding).priority(.high)
			make.bottom.equalTo(self.view.safeAreaInsets.bottom).inset(Constants.locatorButtonBottomPadding)
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
            make.top.equalTo(self.view.safeAreaInsets.top).inset(Constants.carouselTopPadding)
		}
	}
}

// MARK: - `InteractionResponder` -
extension LocatorViewController: InteractionResponder {
	func addInteractionResponses() {
		locatorButton.addTarget(self, action: #selector(didTapLocatorButton), for: .touchUpInside)
	}

	@objc func didTapLocatorButton() {
		locatorButton.startPulse()
		viewModel.geolocate()
	}
}

// MARK: - 'LocatorViewModelDelegate' -
extension LocatorViewController: LocatorViewModelDelegate {
    func foundNewLocationName() {
        handleUpdatedLocation()
    }
    
    func failedToFindLocation(_ error: Error) {
        handleError(error)
    }
}
