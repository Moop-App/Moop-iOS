//
//  String+Extension.swift
//  Moop
//
//  Created by kor45cw on 08/08/2019.
//  Copyright © 2019 kor45cw. All rights reserved.
//

import Foundation

extension String {
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }
    
    func localizedFormat(_ arguments: CVarArg...) -> String {
        return String(format: self.localized, arguments: arguments)
    }
}
