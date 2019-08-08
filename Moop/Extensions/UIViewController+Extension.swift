//
//  UIViewController+Extension.swift
//  Moop
//
//  Created by kor45cw on 31/07/2019.
//  Copyright © 2019 kor45cw. All rights reserved.
//

import UIKit

enum StoryboardName: String {
    case main = "Main"
    case currentMovie = "CurrentMovie"
    case futureMovie = "FutureMovie"
}

extension UIViewController {
    class func instance<T>(storyboardName: StoryboardName = .main, identifier: String? = nil) -> T where T: UIViewController {
        var identifier = identifier
        let storyboard = UIStoryboard(name: storyboardName.rawValue, bundle: nil)
        
        if identifier == nil {
            identifier = String(describing: T.self)
        }
        guard let viewController = storyboard.instantiateViewController(withIdentifier: identifier ?? "") as? T else {
            fatalError("Couldn't instantiate view controller with identifier \(String(describing: identifier))")
        }
        return viewController
    }
}
