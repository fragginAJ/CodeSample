//
//  UIViewController+Alert.swift
//  CodeSample
//
//  Created by AJ Fragoso on 2/10/18.
//  Copyright © 2018 AJ Fragoso. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    
    /// Helper for showing an alert from any `UIViewController` with a title, message, and single confirmation button that dismisses the alert.
    /// - Parameters:
    ///   - title: Header string for the alert
    ///   - message: Detailed description regarding the purpose of the alert
    ///   - acknowledgement: Title for the confirmation button that will dismiss the alert
	func showAlert(title: String, message: String, acknowledgement: String) {
		let alertVC = UIAlertController(title: title,
										message: message,
										preferredStyle: .alert)
		
		let acknowledgeAction = UIAlertAction(title: acknowledgement,
											  style: .default,
											  handler: nil)

		alertVC.addAction(acknowledgeAction)
		present(alertVC, animated: true, completion: nil)
	}
}
