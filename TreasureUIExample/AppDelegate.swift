//
//  AppDelegate.swift
//  TreasureUIExample
//
//  Created by Tengqi Zhan on 2022-04-11.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
  var window: UIWindow?

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    // Override point for customization after application launch.
    window = UIWindow(frame: UIScreen.main.bounds)
    window?.rootViewController = PaymentFlowViewController()
    window?.makeKeyAndVisible()
    window?.backgroundColor = .white
    return true
  }
}

