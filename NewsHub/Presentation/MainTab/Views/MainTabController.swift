//
//  MainTabController.swift
//  NewsHub
//
//  Created by Anton Petrov on 10.10.2023.
//

import UIKit

final class MainTabBarController: UITabBarController {
    // MARK: - Properties

    private let tabs = TabBarItem.allCases
    private let networkManager: NetworkManagerProtocol
    private let realmManager: RealmManagerProtocol

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewControllers()
        addBlur()
    }

    // MARK: - Initializer

    init(networkManager: NetworkManagerProtocol, realmManager: RealmManagerProtocol) {
        self.networkManager = networkManager
        self.realmManager = realmManager
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup

    private func setupViewControllers() {
        var tabViewControllers = [UIViewController]()
        tabs.forEach { tab in
            let viewController: UIViewController
            switch tab {
            case .search:
                let viewModel = SearchViewModel(networkManager: networkManager, realmManager: realmManager)
                let mainVC = SearchViewController(viewModel: viewModel)
                let navigationController = UINavigationController(rootViewController: mainVC)
                viewController = navigationController
            case .saved:
                let viewModel = SavedViewModel(realmManager: realmManager)
                let savedVC = SavedViewController(viewModel: viewModel)
                let navigationController = UINavigationController(rootViewController: savedVC)
                viewController = navigationController
            }
            viewController.tabBarItem = UITabBarItem(title: tab.title,
                                                     image: tab.image,
                                                     selectedImage: tab.selectedImage)
            tabViewControllers.append(viewController)
        }
        viewControllers = tabViewControllers
    }

    private func addBlur() {
        let blurEffect = UIBlurEffect(style: .regular)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurEffectView.frame = tabBar.bounds
        tabBar.insertSubview(blurEffectView, at: 0)
    }
}
