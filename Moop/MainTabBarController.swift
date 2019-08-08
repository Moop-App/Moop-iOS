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
        
        self.addCurrentMovieViewController()
        self.addFutureMovieViewController()
    }
    
    private func addCurrentMovieViewController() {
        let currentNavigationController = UINavigationController(rootViewController: CurrentMovieView.instance())
        currentNavigationController.navigationBar.prefersLargeTitles = true
        let currentTabBarItem = UITabBarItem(title: "현재상영".localized, image: UIImage(named: "movie"), tag: 0)
        currentTabBarItem.selectedImage = UIImage(named: "movie_selected")
        currentNavigationController.tabBarItem = currentTabBarItem
        self.viewControllers?[0] = currentNavigationController
    }
    
    private func addFutureMovieViewController() {
        let currentNavigationController = UINavigationController(rootViewController: FutureMovieView.instance())
        currentNavigationController.navigationBar.prefersLargeTitles = true
        let currentTabBarItem = UITabBarItem(title: "개봉예정".localized, image: UIImage(named: "plan"), tag: 1)
        currentTabBarItem.selectedImage = UIImage(named: "plan_selected")
        currentNavigationController.tabBarItem = currentTabBarItem
        self.viewControllers?[1] = currentNavigationController
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
