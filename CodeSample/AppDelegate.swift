//
//  AppDelegate.swift
//  CodeSample
//
//  Created by AJ Fragoso on 2/3/18.
//  Copyright © 2018 AJ Fragoso. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

	var window: UIWindow?

	func application(_ application: UIApplication,
					 didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
		window = UIWindow(frame: UIScreen.main.bounds)
		window?.backgroundColor = .white

        FlickrConstants.shared.apiKey = try! Configuration.value(for: .flickrApiKey)
		window?.rootViewController = LocatorViewController()
		window?.makeKeyAndVisible()

		return true
	}
}


