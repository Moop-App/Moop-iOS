//
//  UIApplication+Extension.swift
//  Moop
//
//  Created by Chang Woo Son on 2019/06/22.
//  Copyright © 2019 kor45cw. All rights reserved.
//

import UIKit

extension UIApplication {
    var applicationName: String? {
        return Bundle.main.object(forInfoDictionaryKey: "CFBundleName") as? String
    }
    
    var versionString: String {
        let version = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String
        let build = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as? String
        #if DEBUG
        return "\(version ?? "1.0.0") (\(build ?? "1")) Debug"
        #else
        return "\(version ?? "1.0.0") (\(build ?? "1"))"
        #endif
    }
}
