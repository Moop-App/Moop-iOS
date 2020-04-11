//
//  SettingModel.swift
//  Moop
//
//  Created by kor45cw on 2020/03/09.
//  Copyright © 2020 kor45cw. All rights reserved.
//

import Foundation

// Section
enum Section: CaseIterable {
    case inApp // 광고 보기, 광고 제거, 구매복원
    case etc // 지도, 오픈소스, 버그신고, 버전
    
    var title: String {
        switch self {
        case .inApp: return "About InApp".localized
        case .etc: return "ETC".localized
        }
    }
    
    var footer: String {
        switch self {
        case .etc: return "앱에서 제공하는 정보 오류나 지연 혹은 그러한 정보를 토대로 한 행동에 대해 책임을 지지 않습니다.".localized
        default: return ""
        }
    }
    
    var contents: [Item] {
        switch self {
        case .inApp: return UserData.isAdFree ? [.header, .showAd] : [.header, .showAd, .inApp, .restore]
        case .etc: return [.header, .showMap, .openSource, .bugReport, .version, .footer]
        }
    }
    
    enum Item {
        case header
        case showAd
        case inApp, restore
        case showMap, openSource, bugReport, version
        case footer
        
        var productId: String {
            switch self {
            case .inApp: return AdConfig.adFreeKey
            default: return ""
            }
        }
        
        var title: String {
            switch self {
            case .showAd: return "🎬 개발자를 위한 인기앱 확인하기".localized
            case .inApp: return "🎊 광고제거 구매".localized
            case .restore: return "🧧 구매복원".localized
            case .showMap: return "🗺 극장위치 확인하기".localized
            case .openSource: return "💡오픈소스".localized
            case .bugReport: return "⚒ 버그 신고 및 문의".localized
            case .version: return "📱버전 정보".localized
            default: return ""
            }
        }
    }
}
