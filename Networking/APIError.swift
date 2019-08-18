//
//  APIError.swift
//  Networking
//
//  Created by kor45cw on 17/08/2019.
//  Copyright © 2019 kor45cw. All rights reserved.
//

import Foundation

public enum APIError: Error {
    case notReachable
}

extension APIError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .notReachable:
            return "Network now have some problem"
        }
    }
}
