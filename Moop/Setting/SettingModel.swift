//
//  SettingModel.swift
//  Moop
//
//  Created by kor45cw on 2020/03/09.
//  Copyright © 2020 kor45cw. All rights reserved.
//

import Foundation

enum SettingSection: CaseIterable {
    case theme
    case map
    case version
    case opensource
    case feedback
    case inapp
    
    var title: String {
        switch self {
        case .theme:
            return "테마".localized
        case .map:
            return "지도".localized
        case .version:
            return "버전".localized
        case .opensource:
            return "오픈소스".localized
        case .feedback:
            return "피드백".localized
        case .inapp:
            return "인앱구매".localized
        }
    }
    
    var description: String {
        switch self {
        case .theme:
            return "준비중입니다".localized
        case .map:
            return "지도확인하기".localized
        case .version:
            guard let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String else { return "" }
            return "\("현재".localized) \(appVersion)"
        case .opensource:
            return "자세히보기".localized
        case .feedback:
            return "개발자에게버그신고하기".localized
        case .inapp:
            return "광고제거 구매하기".localized
        }
    }
}
