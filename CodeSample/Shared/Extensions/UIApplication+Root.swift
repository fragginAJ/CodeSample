//
//  UIApplication+Root.swift
//  CodeSample
//
//  Created by AJ Fragoso on 2/3/18.
//  Copyright © 2018 AJ Fragoso. All rights reserved.
//

import UIKit

extension UIApplication {
	/// Set the rootViewController after a transition.
	///
	/// - Parameters:
	///   - viewController: The view controller to transition to, then make the root view controller.
	///   - duration: The animation duration. By default, 1.0s.
	///   - animation: The animation type. By default, .transitionCrossDissolve.
	///   - completion: The closure to execute on animation completion.
	public func rootTransition(to viewController: UIViewController,
							   duration: TimeInterval = 1.0,
							   animation: UIView.AnimationOptions = .transitionCrossDissolve,
							   completion: ((Bool) -> Void)? = nil) {
		guard case .some(.some(let window)) = delegate?.window else {
			debugPrint("Transition failed: could not unwrap the application window.")
			return
		}

		UIView.transition(
			with: window,
			duration: duration,
			options: animation,
			animations: {
				window.rootViewController = viewController
		},
			completion: {
				completion?($0)
		}
		)
	}
}
