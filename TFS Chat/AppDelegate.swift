//
//  AppDelegate.swift
//  TFS Chat
//
//  Created by dmitry on 11.09.2020.
//  Copyright © 2020 dmitry. All rights reserved.
//

import UIKit
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    private let rootAssembly = RootAssembly()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        printStateInfo(from: .notRunning, to: .inactive, methodName: #function)
        FirebaseApp.configure()
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        let controller = rootAssembly.presentationAssembly.rootController()
        window?.rootViewController = controller
        window?.makeKeyAndVisible()
        return true
    }
    
    
    /// Все эти методы можно заменить на обработку уведомлений NotificationCenter
    /// UIApplication.didBecomeActiveNotification
    /// Захламления AppDelegate стоит избегать, эта классическая проблема
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        printStateInfo(from: .inactive, to: .active, methodName: #function)
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        printStateInfo(from: .active, to: .inactive, methodName: #function)
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        printStateInfo(from: .inactive, to: .background, methodName: #function)
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        printStateInfo(from: .background, to: .inactive, methodName: #function)
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        printStateInfo(from: .background, to: .notRunning, methodName: #function)
    }
    
    private func printStateInfo(from: AppState, to: AppState, methodName: String) {
        LoggingUtil.debugPrint("Method \(methodName) of AppDelegate was called. Application moved from '\(from)' to '\(to)' state.")
    }
    
}

enum AppState {
    case notRunning, inactive, active, background, suspended
}
