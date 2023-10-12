//
//  AppDelegate.swift
//  NewsHub
//
//  Created by Anton Petrov on 10.10.2023.
//

import UIKit

@main
final class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    private let networkManager: NetworkManagerProtocol = NetworkManager()
    private let realmManager: RealmManagerProtocol = RealmManager()

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.backgroundColor = .systemBackground
        window?.tintColor = .label
        window?.makeKeyAndVisible()
        window?.rootViewController = MainTabBarController(networkManager: networkManager,
                                                          realmManager: realmManager)
        return true
    }
}
