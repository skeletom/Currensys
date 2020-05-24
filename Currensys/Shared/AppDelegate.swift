//
//  AppDelegate.swift
//  Currensys
//
//  Created by Tomas Jelinek on 23/05/2020.
//  Copyright © 2020 Tomas Jelinek. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?
  
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    
    window = UIWindow()
    window?.makeKeyAndVisible()
    window?.rootViewController = MainViewController()
    
    return true
  }
}

