//
//  ViewBuilder.swift
//  CodeSample
//
//  Created by AJ Fragoso on 2/3/18.
//  Copyright © 2018 AJ Fragoso. All rights reserved.
//

import Foundation

/// `ViewBuilder` promotes consistent styling and behavior of components with subviews in the project.
protocol ViewBuilder {
	/// Style the root view.
	func styleView()

	/// Add, style, and apply constraints to subviews.
	func addSubviews()
}
