//
//  UIView+Convenience.swift
//  CodeSample
//
//  Created by AJ Fragoso on 2/3/18.
//  Copyright © 2018 AJ Fragoso. All rights reserved.
//

import UIKit

/// Contains common, helpful functions to carry out with a `UIView`.
extension UIView {
	/// Round the view's corners.
	///
	/// - Parameter cornerRadius: The rounding corner radius.
	public func roundCorners(radius: CGFloat = 4.0) {
		layer.masksToBounds = true
		layer.cornerRadius = radius
	}
}
