//
//  AppDelegate.swift
//  Weather
//
//  Created by Lydia Lu on 2025/3/14.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // 創建UIWindow實例
        window = UIWindow(frame: UIScreen.main.bounds)
        
        // 創建WeatherViewController實例
        let weatherViewController = WeatherViewController()
        
        // 如果需要導航控制器
        let navigationController = UINavigationController(rootViewController: weatherViewController)
        
        // 設定window的rootViewController為navigationController
        window?.rootViewController = navigationController
        
        // 使window可見
        window?.makeKeyAndVisible()
        
        return true
    }


    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

