//
//  CarouselCollectionViewCell.swift
//  CodeSample
//
//  Created by AJ Fragoso on 2/9/18.
//  Copyright © 2018 AJ Fragoso. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
import AlamofireImage

/// `CarouselCollectionViewCell` loads and displays an image derived from a `FlickrPhoto`. Requests are canceled on reuse
/// and caching from `AlamofireImage` is used for optimal performance.
class CarouselCollectionViewCell: UICollectionViewCell {
	// MARK: properties
	private let imageView = UIImageView()

	// MARK: intializers
	override init(frame: CGRect) {
		super.init(frame: frame)

		styleView()
		addSubviews()
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	override func prepareForReuse() {
		super.prepareForReuse()

		imageView.af_cancelImageRequest()
		imageView.layer.removeAllAnimations()
		imageView.image = nil
	}

	// MARK: internal functions
	func configure(with flickrPhoto: FlickrPhoto) {
		imageView.af_setImage(withURL: URL(string: flickrPhoto.source(size: .largeSquare))!,
							  placeholderImage: UIImage(named: "default"),
							  imageTransition: UIImageView.ImageTransition.crossDissolve(0.15),
							  runImageTransitionIfCached: false)
	}
}

// MARK: - `ViewBuilder` -
extension CarouselCollectionViewCell: ViewBuilder {
	func styleView() {
		contentView.backgroundColor = .gray
	}

	func addSubviews() {
		addImageView()
	}

	func addImageView() {
		contentView.addSubview(imageView)
		imageView.contentMode = .scaleAspectFit

		imageView.snp.makeConstraints { make in
			make.edges.equalToSuperview()
		}
	}
}
