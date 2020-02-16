//
//  PulseLayer.swift
//  CodeSample
//
//  Created by AJ Fragoso on 2/3/18.
//  Copyright © 2018 AJ Fragoso. All rights reserved.
//

import UIKit

/// `PulseLayer` draws and animates a circular pulse animation.
final class PulseLayer: CALayer {
	// MARK: properties
	private let midwayKeyTime: NSNumber = 0.2
	private let pulseDuration: TimeInterval = 1.5
	private let pulseDelay: TimeInterval = 0.25
	private let startRadius: Float = 0.0
	private let startAlpha: Float = 0.5
	private let midwayAlpha: Float = 0.8
	private let endAlpha: Float = 0
	private let pulseColor = UIColor.red.cgColor

	private var radius: CGFloat = 200.0
	private var animationGroup: CAAnimationGroup = CAAnimationGroup()
	private(set) var isPulsing = false

	// MARK: computed properties
	private var opacityAnimation: CAKeyframeAnimation {
		let opacityAnimation = CAKeyframeAnimation(keyPath: "opacity")

		opacityAnimation.values = [startAlpha, midwayAlpha, endAlpha]
		opacityAnimation.keyTimes = [0, midwayKeyTime, 1]
		opacityAnimation.isRemovedOnCompletion = false
		opacityAnimation.duration = pulseDuration

		return opacityAnimation
	}

	private var scaleAnimation: CABasicAnimation {
		let scaleAnimation = CABasicAnimation(keyPath: "transform.scale.xy")
		scaleAnimation.fromValue = startRadius
		scaleAnimation.toValue = NSNumber(value: 1.0)
		scaleAnimation.duration = pulseDuration

		return scaleAnimation
	}

	// MARK: initializers
	init(centerPoint: CGPoint, radius: CGFloat = 200.0) {
		super.init()
		self.contentsScale = UIScreen.main.scale
		self.opacity = 0.0
		self.backgroundColor = pulseColor
		self.position = centerPoint
		self.radius = radius
	}

	// Must implement or we will crash
	override init(layer: Any) {
		super.init(layer: layer)
	}

	required init(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	// MARK: private functions
	private func setPulseRadius(_ radius: CGFloat) {
		self.radius = radius
		let tempPos = position
		let diameter = radius * 2

		bounds = CGRect(x: 0.0, y: 0.0, width: diameter, height: diameter)
		cornerRadius = radius
		position = tempPos
	}

	private func configureAnimationGroup() {
		animationGroup = CAAnimationGroup()
		animationGroup.duration = pulseDuration + pulseDelay
		animationGroup.repeatCount = .infinity
		animationGroup.isRemovedOnCompletion = false

		let defaultTimingCurve = CAMediaTimingFunction(name: CAMediaTimingFunctionName.default)
		animationGroup.timingFunction = defaultTimingCurve

		animationGroup.animations = [scaleAnimation, opacityAnimation]
	}

	// MARK: internal functions
	func startPulse() {
		guard !isPulsing else { return }

		isPulsing = true
		DispatchQueue.global(qos: .background).async {
			self.configureAnimationGroup()
			self.setPulseRadius(self.radius)

			if (self.pulseDelay != Double.infinity) {
				DispatchQueue.main.async {
					self.add(self.animationGroup, forKey: "pulse")
				}
			}
		}
	}

	func endPulse() {
		removeAllAnimations()
		isPulsing = false
	}
}
