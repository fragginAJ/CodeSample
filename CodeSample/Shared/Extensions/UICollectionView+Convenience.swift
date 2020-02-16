//
//  UICollectionView+Convenience.swift
//  CodeSample
//
//  Created by AJ Fragoso on 2/9/18.
//  Copyright © 2018 AJ Fragoso. All rights reserved.
//

import Foundation
import UIKit

extension UICollectionView {
	/// Register a UICollectionViewCell for reuse with the class name as the reuse identifier
	///
	/// - Parameter _: The class to be registered
	public func registerClassForCellReuse<T: UICollectionViewCell>(_: T.Type) {
		register(T.self, forCellWithReuseIdentifier: String(describing: T.self))
	}

	/// Dequeue a reusable cell with the class name as the reuse identifier
	///
	/// - Parameter indexPath: The `indexPath` to dequeue the cell for
	/// - Returns: The dequeued cell
	public func dequeueReusableCell<T: UICollectionViewCell>(for indexPath: IndexPath) -> T {
		guard let cell = dequeueReusableCell(withReuseIdentifier: String(describing: T.self), for: indexPath) as? T
			else {
				fatalError("Could not dequeue cell with identifier: \(String(describing: T.self))")
		}

		return cell
	}
}
