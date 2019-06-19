//
//  MainTabBarController.swift
//  Moop
//
//  Created by Chang Woo Son on 2019/06/19.
//  Copyright © 2019 kor45cw. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
    }
}

extension MainTabBarController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        guard let navi = viewController as? UINavigationController else { return }
        if let vc = navi.viewControllers.first as? CurrentMovieViewController {
            if vc.canScrollToTop {
                vc.scrollToTop()
            }
        }
        
        if let vc = navi.viewControllers.first as? FutureMovieViewController {
            if vc.canScrollToTop {
                vc.scrollToTop()
            }
        }
        
        if let vc = navi.viewControllers.first as? SettingViewController {
            if vc.canScrollToTop {
                vc.scrollToTop()
            }
        }
    }
}
