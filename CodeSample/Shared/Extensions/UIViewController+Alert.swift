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
