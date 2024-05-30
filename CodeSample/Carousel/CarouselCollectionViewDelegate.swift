//
//  CarouselCollectionViewDelegate.swift
//  CodeSample
//
//  Created by AJ Fragoso on 2/9/18.
//  Copyright © 2018 AJ Fragoso. All rights reserved.
//

import Foundation
import UIKit

/// `CarouselCollectionViewDelegate` serves as the data source and delegate for a collection view, creating
/// the effect of an "infinitely" repeating carousel.
final class CarouselCollectionViewDelegate: NSObject {
    
    // MARK: interntal properties
    var didSelectPhoto: ((FlickrPhoto) -> Void)? = nil
    
    // MARK: private properties
	private var carouselCollectionView: UICollectionView?
	private var photoArray: [FlickrPhoto] = []
	private let multiplier: Int = 10
    
	// MARK: internal functions

	/// Updates the data source array of `FlickrPhotos`. The input is copied three times over to aid in the
	/// infinite carousel effect.
	///
	/// - Parameter newArray: An updated set of `FlickrPhoto` objects to display
	func updatePhotoArray(_ newArray: [FlickrPhoto]) {
		photoArray = newArray
		carouselCollectionView?.reloadData()
		centerCarousel()
	}

	func configureCollectionView(_ collectionView: UICollectionView) {
		if let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
			flowLayout.scrollDirection = .horizontal
		}
		collectionView.alwaysBounceHorizontal = false
		collectionView.showsHorizontalScrollIndicator = false
		collectionView.bounces = false
		collectionView.delegate = self
		collectionView.dataSource = self
		collectionView.registerClassForCellReuse(CarouselCollectionViewCell.self)
		carouselCollectionView = collectionView
	}

	// MARK: private functions
    
    /// Centers the carousel on a specified item in the collection. Defaults to 0, the middle of the array.
    /// - Parameter offset: The number of items away from the middle of the photo array that you wish to center on
	private func centerCarousel(offset: Int = 0) {
		let halfwayMultiplier: Int = multiplier / 2
		let centerIndex = IndexPath(item: (halfwayMultiplier * photoArray.count) + offset, section: 0)
		carouselCollectionView?.scrollToItem(at: centerIndex, at: .centeredHorizontally, animated: false)
	}

    /// As the collection view scroll settles, this function centers the carousel on the closest item to the middle.
	private func autoCenterCarousel() {
		guard let carouselCollectionView, let container = carouselCollectionView.superview else {
			return
		}

		let centerPoint = container.convert(carouselCollectionView.center, to: carouselCollectionView)
		if let centerIndexPath = carouselCollectionView.indexPathForItem(at: centerPoint) {
			centerCarousel(offset: centerIndexPath.item % photoArray.count)
		}
	}
}

// MARK: - `UICollectionViewDelegate` -
extension CarouselCollectionViewDelegate: UICollectionViewDelegate {
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedPhoto = photoArray[(indexPath.row % photoArray.count)]
        didSelectPhoto?(selectedPhoto)
	}
}

// MARK: - `UICollectionViewDataSource`
extension CarouselCollectionViewDelegate: UICollectionViewDataSource {
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return photoArray.count * multiplier
	}

	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell: CarouselCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
		cell.configure(with: photoArray[(indexPath.row % photoArray.count)])
		return cell
	}
}

// MARK: - `UICollectionViewDelegateFlowLayout` -
extension CarouselCollectionViewDelegate: UIScrollViewDelegate {
	func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
		autoCenterCarousel()
	}
}
