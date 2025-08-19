//
//  TabBarController.swift
//  Sesac250814
//
//  Created by 유태호 on 8/14/25.
//

import UIKit

final class TabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTabBar()
        setupViewControllers()
    }
    
    private func setupTabBar() {
        tabBar.backgroundColor = .white
        tabBar.tintColor = .systemBlue
        tabBar.unselectedItemTintColor = .systemGray
        tabBar.barTintColor = .white
        
        if #available(iOS 15.0, *) {
            let appearance = UITabBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = .white
            
            tabBar.standardAppearance = appearance
            tabBar.scrollEdgeAppearance = appearance
        }
    }
    
    private func setupViewControllers() {
        let topicVC = createTopicViewController()
        let searchVC = createSearchViewController()
        let likeVC = createLikeViewController()
        
        viewControllers = [topicVC, searchVC, likeVC]
    }
    
    private func createTopicViewController() -> UINavigationController {
        let topicVC = TopicViewController()
        let navController = UINavigationController(rootViewController: topicVC)
        
        navController.tabBarItem = UITabBarItem(
            title: "토픽",
            image: UIImage(systemName: "photo.on.rectangle"),
            selectedImage: UIImage(systemName: "photo.on.rectangle.fill")
        )
        
        setupNavigationController(navController)
        return navController
    }
    
    private func createSearchViewController() -> UINavigationController {
        let searchVC = SearchViewController()
        let navController = UINavigationController(rootViewController: searchVC)
        
        navController.tabBarItem = UITabBarItem(
            title: "검색",
            image: UIImage(systemName: "magnifyingglass"),
            selectedImage: UIImage(systemName: "magnifyingglass.circle.fill")
        )
        
        setupNavigationController(navController)
        return navController
    }
    
    private func createLikeViewController() -> UINavigationController {
        let likeVC = LikeViewController()
        let navController = UINavigationController(rootViewController: likeVC)
        
        navController.tabBarItem = UITabBarItem(
            title: "좋아요",
            image: UIImage(systemName: "heart"),
            selectedImage: UIImage(systemName: "heart.fill")
        )
        
        setupNavigationController(navController)
        return navController
    }
    
    private func setupNavigationController(_ navController: UINavigationController) {
        navController.navigationBar.tintColor = .black
        navController.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.black]
        navController.navigationBar.barTintColor = .white
        
        if #available(iOS 15.0, *) {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = .white
            appearance.titleTextAttributes = [.foregroundColor: UIColor.black]
            
            navController.navigationBar.standardAppearance = appearance
            navController.navigationBar.scrollEdgeAppearance = appearance
        }
    }
}
