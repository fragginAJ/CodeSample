//
//  CarouselFlowLayout.swift
//  CodeSample
//
//  Created by AJ Fragoso on 2/10/18.
//  Copyright © 2018 AJ Fragoso. All rights reserved.
//

import Foundation
import UIKit

struct CarouselFlowLayoutConstants {
	struct Item {
		static let standardHeight: CGFloat = 105
		static let magnifiedHeight: CGFloat = 150
		static let standardWidth: CGFloat = 105
		static let magnifiedWidth: CGFloat = 150
	}
}

/// `CarouselFlowLayout` is a custom collection view layout that snaps to the nearest item and scales the size of the
/// item(s) closest to the center. Code is heavily borrowed from [UPCarouselFlowLayout](https://github.com/ink-spot/UPCarouselFlowLayout)
class CarouselFlowLayout: UICollectionViewFlowLayout {
	private struct LayoutState {
		var size: CGSize
		var direction: UICollectionView.ScrollDirection
		func isEqual(_ otherState: LayoutState) -> Bool {
			return size.equalTo(otherState.size) && direction == otherState.direction
		}
	}

	/// Value between 0 and 1. Shrinking ratio for collection items which are not in the center
	private var sideItemScale: CGFloat = CarouselFlowLayoutConstants.Item.standardHeight / CarouselFlowLayoutConstants.Item.magnifiedHeight
	/// Value represent number of points. Horizontal offset for the items not in the center
	private var sideItemShift: CGFloat = 0.0
	/// The fixed spaced between items
	private var spacing: CGFloat = 5
	private var state = LayoutState(size: CGSize.zero, direction: .horizontal)

	// MARK: initializers
	override init() {
		super.init()
		self.itemSize = CGSize(width: CarouselFlowLayoutConstants.Item.magnifiedWidth,
							   height: CarouselFlowLayoutConstants.Item.magnifiedHeight)
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	// MARK - `UICollectionViewLayout` -
	override func prepare() {
		super.prepare()

		let currentState = LayoutState(size: collectionView!.bounds.size, direction: scrollDirection)

		if !state.isEqual(currentState) {
			setupCollectionView()
			updateLayout()
			state = currentState
		}
	}

	override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
		return true
	}

	override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
		guard let superAttributes = super.layoutAttributesForElements(in: rect),
			let attributes = NSArray(array: superAttributes, copyItems: true) as? [UICollectionViewLayoutAttributes]
			else {
				return nil
		}

		return attributes.map({ transformLayoutAttributes($0) })
	}

	override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint,
									  withScrollingVelocity velocity: CGPoint) -> CGPoint {
		guard let collectionView = collectionView,
			!collectionView.isPagingEnabled,
			let layoutAttributes = layoutAttributesForElements(in: collectionView.bounds) else {
				return super.targetContentOffset(forProposedContentOffset: proposedContentOffset)
		}

		let midSide = collectionView.bounds.size.width / 2
		let proposedContentOffsetCenterOrigin = proposedContentOffset.x + midSide

		let closest = layoutAttributes.sorted {
			abs($0.center.x - proposedContentOffsetCenterOrigin) < abs($1.center.x - proposedContentOffsetCenterOrigin)
		}.first ?? UICollectionViewLayoutAttributes()

		let targetContentOffset = CGPoint(x: floor(closest.center.x - midSide), y: proposedContentOffset.y)

		return targetContentOffset
	}

	// MARK: private functions
	private func setupCollectionView() {
		guard let collectionView = collectionView else { return }

		if collectionView.decelerationRate != UIScrollView.DecelerationRate.fast {
			collectionView.decelerationRate = UIScrollView.DecelerationRate.fast
		}
	}

	private func updateLayout() {
		guard let collectionView = collectionView else { return }

		let collectionSize = collectionView.bounds.size

		let yInset = (collectionSize.height - itemSize.height) / 2
		let xInset = (collectionSize.width - itemSize.width) / 2
		sectionInset = UIEdgeInsets.init(top: yInset, left: xInset, bottom: yInset, right: xInset)

		let side = itemSize.width
		let scaledItemOffset = (side - side * sideItemScale) / 2
		minimumLineSpacing = spacing - scaledItemOffset
	}

	private func transformLayoutAttributes(_ attributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
		guard let collectionView = collectionView else { return attributes }

		let collectionCenter = collectionView.frame.size.width / 2
		let offset = collectionView.contentOffset.x
		let normalizedCenter = attributes.center.x - offset

		let maxDistance = itemSize.width + minimumLineSpacing
		let distance = min(abs(collectionCenter - normalizedCenter), maxDistance)
		let ratio = (maxDistance - distance) / maxDistance

		let scale = ratio * (1 - sideItemScale) + sideItemScale
		let shift = (1 - ratio) * sideItemShift
		attributes.transform3D = CATransform3DScale(CATransform3DIdentity, scale, scale, 1)
		if scale > sideItemScale {
			let magnifiedVerticalItemOffset = (attributes.frame.height - CarouselFlowLayoutConstants.Item.standardHeight) / 2
			attributes.center.y = attributes.center.y + shift - magnifiedVerticalItemOffset
		} else {
			attributes.center.y = attributes.center.y + shift
		}

		return attributes
	}
}
