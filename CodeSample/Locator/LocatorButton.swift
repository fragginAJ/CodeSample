//
//  LocatorButton.swift
//  CodeSample
//
//  Created by AJ Fragoso on 2/3/18.
//  Copyright © 2018 AJ Fragoso. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

/// `LocatorButton` is a rounded `UIButton`, featuring animations seen in the geolocation experience.
/// It bounces on highlight and can expand in an accordion fashion to display a longer title.
final class LocatorButton: UIButton {
    
    // MARK: internal properties
    
    override var isHighlighted: Bool {
        didSet {
            animateHighlight(highlighted: isHighlighted)
        }
    }
    
    // MARK: private properties

	/// Displays the current location if is known
	private let locationLabel = UILabel()
    
    /// Draws and animates the pulse effect
	private var pulseLayer: PulseLayer?

	// MARK: initializers
	init() {
		super.init(frame: .zero)

		styleView()
		addSubviews()
	}

	override func draw(_ rect: CGRect) {
		super.draw(rect)
		addPulseLayer()
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	// MARK: internal functions

	/// Updates the location displayed on the button. Passing nil will default back to "?".
	///
	/// - Parameter locationName: The location to appear on the button's location label
	func updateLocationName(_ locationName: String?) {
		// Include a deliberate delay to allow the pulse animation to appear, even if briefly
		DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
			if let locationName = locationName {
				self.locationLabel.text = locationName
				self.endPulse()
			} else {
				self.locationLabel.text = "?"
			}

			UIView.animate(withDuration: 0.5) {
				self.layoutIfNeeded()
			}
		}
	}

	/// Kicks off the pulse animation
	func startPulse() {
		pulseLayer?.startPulse()
	}

	/// Terminates the pulse animation
	func endPulse() {
		pulseLayer?.endPulse()
	}

	// MARK: private functions
	private func addPulseLayer() {
		guard let superview else {
			print("LocatorButton cannot draw pulse layer without a superview")
			return
		}

		pulseLayer = PulseLayer(centerPoint: center)
		superview.layer.insertSublayer(pulseLayer!, below:layer)
	}

	/// Apply a springy animation when toggling the highlighted state. Scale to 110% of the view's size when highlighted.
	/// Revert to identity when not highlighted
	///
	/// - Parameters:
	///   - highlighted: Whether the view is highlighted or not.
	///   - scale: The scale to animate the view, if applicable.
	private func animateHighlight(highlighted: Bool,
								  scale: CGFloat? = 1.1) {
		let transform = scale.map { highlighted ? CGAffineTransform(scaleX: $0, y: $0) : .identity }

		UIView.animate(
			withDuration: 0.35,
			delay: 0,
			usingSpringWithDamping: 0.55,
			initialSpringVelocity: 0.75,
			options: [.allowUserInteraction, .curveEaseInOut],
			animations: {
				if let transform = transform {
					self.transform = transform
				}
		},
			completion: nil
		)
	}
}

// MARK: - `ViewBuilder` -
extension LocatorButton: ViewBuilder {
    private enum Constants {
        static let buttonRadius: CGFloat = 44
        static let labelHorizontalPadding: CGFloat = 15
        static let labelVerticalPadding: CGFloat = 5
    }
    
	func styleView() {
        roundCorners(radius: Constants.buttonRadius)
		layer.backgroundColor = UIColor.black.cgColor
		layer.masksToBounds = false

		snp.makeConstraints { make in
            make.width.height.equalTo(Constants.buttonRadius * 2).priority(.high)
            make.width.height.greaterThanOrEqualTo(Constants.buttonRadius * 2).priority(.required)
		}
	}

	func addSubviews() {
		addLocationLabel()
	}

	func addLocationLabel() {
		addSubview(locationLabel)
		locationLabel.numberOfLines = 1
		locationLabel.font = .boldSystemFont(ofSize: 24)
		locationLabel.textColor = .white
		locationLabel.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        locationLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
		locationLabel.textAlignment = .center
		locationLabel.adjustsFontSizeToFitWidth = true
		locationLabel.minimumScaleFactor = 0.5
		locationLabel.text = "?"

		locationLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(Constants.labelHorizontalPadding).priority(.required)
			make.trailing.equalToSuperview().inset(Constants.labelHorizontalPadding).priority(.required)
			make.top.equalToSuperview().offset(Constants.labelVerticalPadding).priority(.required)
			make.bottom.equalToSuperview().inset(Constants.labelVerticalPadding).priority(.required)
		}
	}
}
