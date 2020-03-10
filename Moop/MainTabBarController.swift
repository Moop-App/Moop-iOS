//
//  MainTabBarController.swift
//  Moop
//
//  Created by Chang Woo Son on 2019/06/19.
//  Copyright © 2019 kor45cw. All rights reserved.
//

import UIKit

protocol ScrollToTopDelegate: class {
    var canScrollToTop: Bool { get set }
    func scrollToTop()
}

class MainTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        
        self.viewControllers = [movieViewController(),
//                                favoriteViewController(),
                                settingViewController()]
    }
    
    private func movieViewController() -> UINavigationController {
        let currentNavigationController = UINavigationController(rootViewController: MovieView.instance())
        currentNavigationController.navigationBar.prefersLargeTitles = true
        let currentTabBarItem = UITabBarItem(title: "영화".localized, image: UIImage(named: "movie"), tag: 0)
        currentTabBarItem.selectedImage = UIImage(named: "movie_selected")
        currentNavigationController.tabBarItem = currentTabBarItem
        return currentNavigationController
    }
    
//    private func favoriteViewController() -> UINavigationController {
//        let favoriteNavigationController = UINavigationController(rootViewController: FavoriteViewController.instance())
//        favoriteNavigationController.navigationBar.prefersLargeTitles = true
//        let favoriteTabBarItem = UITabBarItem(title: "즐겨찾기".localized, image: UIImage(named: "heart"), tag: 2)
//        favoriteTabBarItem.selectedImage = UIImage(named: "heart_fill")
//        favoriteNavigationController.tabBarItem = favoriteTabBarItem
//        return favoriteNavigationController
//    }
    
    private func settingViewController() -> UINavigationController {
        let settingNavigationController = UINavigationController(rootViewController: SettingView.instance())
        settingNavigationController.navigationBar.prefersLargeTitles = true
        let settingTabBarItem = UITabBarItem(title: "설정".localized, image: UIImage(named: "setting"), tag: 3)
        settingTabBarItem.selectedImage = UIImage(named: "setting_selected")
        settingNavigationController.tabBarItem = settingTabBarItem
        return settingNavigationController
    }
}

extension MainTabBarController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        guard let navi = viewController as? UINavigationController else { return }
        if let viewController = navi.viewControllers.first as? ScrollToTopDelegate, viewController.canScrollToTop {
            viewController.scrollToTop()
        }
    }
}
