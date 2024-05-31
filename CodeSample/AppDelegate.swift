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

        do {
            FlickrConstants.shared.apiKey = try Configuration.value(for: .flickrApiKey)
        } catch Configuration.Error.missingKey {
            print("ERROR: Flickr API key is not set!")
        } catch Configuration.Error.invalidValue {
            print("ERROR: Unexpected value found for Flickr API key. Are you sure this is right?")
        } catch {
            print("ERROR: Failed to set Flickr API key for unknown reason.")
        }
        
		window?.rootViewController = LocatorViewController()
		window?.makeKeyAndVisible()

		return true
	}
}


