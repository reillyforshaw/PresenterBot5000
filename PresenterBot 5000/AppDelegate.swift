//
//  AppDelegate.swift
//  PresenterBot 5000
//
//  Created by Reilly Forshaw on 2018-02-05.
//  Copyright © 2018 Reilly Forshaw. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  var window: UIWindow?

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    window = UIWindow(frame: UIScreen.main.bounds)
    window?.makeKeyAndVisible()

    let navigationController = UINavigationController(rootViewController: SlideViewController(slides: [
    ]))
    navigationController.isNavigationBarHidden = true

    window?.rootViewController = navigationController

    return true
  }
}
