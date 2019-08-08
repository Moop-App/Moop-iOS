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
        
        
        self.viewControllers = [currentMovieViewController(), futureMovieViewController(), settingViewController()]
    }
    
    private func currentMovieViewController() -> UINavigationController {
        let currentNavigationController = UINavigationController(rootViewController: CurrentMovieView.instance())
        currentNavigationController.navigationBar.prefersLargeTitles = true
        let currentTabBarItem = UITabBarItem(title: "현재상영".localized, image: UIImage(named: "movie"), tag: 0)
        currentTabBarItem.selectedImage = UIImage(named: "movie_selected")
        currentNavigationController.tabBarItem = currentTabBarItem
        return currentNavigationController
    }
    
    private func futureMovieViewController() -> UINavigationController {
        let futureNavigationController = UINavigationController(rootViewController: FutureMovieView.instance())
        futureNavigationController.navigationBar.prefersLargeTitles = true
        let futureTabBarItem = UITabBarItem(title: "개봉예정".localized, image: UIImage(named: "plan"), tag: 1)
        futureTabBarItem.selectedImage = UIImage(named: "plan_selected")
        futureNavigationController.tabBarItem = futureTabBarItem
        return futureNavigationController
    }
    
    private func settingViewController() -> UINavigationController {
        let settingNavigationController = UINavigationController(rootViewController: SettingViewController.instance())
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
