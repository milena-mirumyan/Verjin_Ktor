//
//  HomeTabBarViewController.swift
//  Capstone
//
//  Created by Milena Mirumyan on 24.03.25.
//

import UIKit

final class HomeTabBarViewController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let home = storyboard.instantiateViewController(withIdentifier: "homeNav")
        home.tabBarItem = .init(title: "Home", image: .init(systemName: "house"), tag: 0)
        
        let favorites = storyboard.instantiateViewController(withIdentifier: "homeNav")
        let root = (favorites as? UINavigationController)?.viewControllers.first as? HomeViewController
        favorites.tabBarItem = .init(title: "Favorites", image: .init(systemName: "heart"), tag: 1)
        root?.isFavorites = true
        
        let profile = storyboard.instantiateViewController(withIdentifier: "accountNav")
        profile.tabBarItem = .init(title: "Account", image: .init(systemName: "person"), tag: 2)
        profile.tabBarItem.accessibilityLabel = "profile_tab"
        
        viewControllers = [
            home,
            favorites,
            profile
        ]
        
        tabBar.tintColor = UIColor.appDarkTeal
    }
}

