//
//  AdManager.swift
//  Moop
//
//  Created by kor45cw on 2020/03/08.
//  Copyright © 2020 kor45cw. All rights reserved.
//

import Firebase
import FBAudienceNetwork
import AdSupport
import UIKit

protocol AdManagerDelegate: class {
    func 전면광고끝()
    func 네이티브광고Loaded()
}

extension AdManagerDelegate {
    func 전면광고끝() { }
    func 네이티브광고Loaded() { }
}

class AdManager: NSObject {
    enum 배너광고타입 {
        case 상세화면
        
        var 구글광고ID: String {
            switch self {
            case .상세화면:
                return AdConfig.bannderKey
            }
        }
        
        var 페이스북광고ID: String {
            switch self {
            case .상세화면:
                return AdConfig.fbBannderKey
            }
        }
    }
    
    enum 네이티브광고타입 {
        case 상세화면
        
        var 구글광고ID: String {
            switch self {
            case .상세화면:
                return AdConfig.nativeAdKey
            }
        }
        
        var 페이스북광고ID: String {
            switch self {
            case .상세화면:
                return AdConfig.fbNativeAdKey
            }
        }
    }
    
    private let 광고뷰: GADBannerView
    private let 페이스북광고뷰: FBAdView
    private let 광고포장뷰: UIView
    
    private let 구글광고로더: GADAdLoader
    private(set) var 구글네이티브광고: GADUnifiedNativeAd?
    private(set) var 페이스북네이티브광고: FBNativeAd?

    
    weak var delegate: AdManagerDelegate?
    private let 타겟ViewController: UIViewController

    static func librarySetup() {
        GADMobileAds.sharedInstance().start(completionHandler: nil)
    }
    
    init(배너광고타입: 배너광고타입,
         네이티브광고타입: 네이티브광고타입,
         viewController: UIViewController,
         wrapperView: UIView) {
        self.광고뷰 = GADBannerView(adSize: kGADAdSizeBanner)
        self.페이스북광고뷰 = FBAdView(placementID: 배너광고타입.페이스북광고ID,
                                              adSize: kFBAdSizeHeight50Banner,
                                              rootViewController: viewController)
        self.광고포장뷰 = wrapperView
        self.타겟ViewController = viewController
        
        구글광고로더 = GADAdLoader(adUnitID: 네이티브광고타입.구글광고ID,
                                               rootViewController: viewController,
                               adTypes: [.unifiedNative],
                               options: nil)
        구글광고로더.load(GADRequest())
        
        페이스북네이티브광고 = FBNativeAd(placementID: 네이티브광고타입.페이스북광고ID)
        
        super.init()
        
        광고뷰.adUnitID = 배너광고타입.구글광고ID
        광고뷰.delegate = self
        광고뷰.rootViewController = viewController
        페이스북광고뷰.delegate = self
        구글광고로더.delegate = self
        페이스북네이티브광고?.delegate = self
        
        구글광고_추가()
    }
    
    private func 구글광고_추가() {
        guard !UserDefaults.standard.bool(forKey: .adFree) else { return }
        페이스북광고뷰.removeFromSuperview()
        광고뷰.translatesAutoresizingMaskIntoConstraints = false
        광고포장뷰.addSubview(광고뷰)
        광고뷰.centerYAnchor.constraint(equalTo: 광고포장뷰.centerYAnchor).isActive = true
        광고뷰.centerXAnchor.constraint(equalTo: 광고포장뷰.centerXAnchor).isActive = true
    }
    
    private func 페이스북광고_추가() {
        광고뷰.removeFromSuperview()
        페이스북광고뷰.translatesAutoresizingMaskIntoConstraints = false
        광고포장뷰.addSubview(페이스북광고뷰)
        페이스북광고뷰.trailingAnchor.constraint(equalTo: 광고포장뷰.trailingAnchor).isActive = true
        페이스북광고뷰.leadingAnchor.constraint(equalTo: 광고포장뷰.leadingAnchor).isActive = true
        페이스북광고뷰.topAnchor.constraint(equalTo: 광고포장뷰.topAnchor).isActive = true
        페이스북광고뷰.bottomAnchor.constraint(equalTo: 광고포장뷰.bottomAnchor).isActive = true
        페이스북광고뷰.loadAd()
    }
    
    func resize_구글광고(width: CGFloat) -> CGFloat {
        광고뷰.adSize = GADCurrentOrientationAnchoredAdaptiveBannerAdSizeWithWidth(width)
        광고뷰.load(GADRequest())
        
        return 광고뷰.adSize.size.height
    }
}

extension AdManager: GADBannerViewDelegate {
    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
        // Add banner to view and add constraints as above.
        bannerView.alpha = 0
        UIView.animate(withDuration: 1, animations: {
            bannerView.alpha = 1
        })
    }
    
    // 광고 요청에 실패했음을 의미
    func adView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: GADRequestError) {
        페이스북광고_추가()
    }
    
    /// 델리게이트가 사용자가 클릭하면 전체 화면보기가 표시된다고 알려줍니다.
    /// 광고. 대리인은 애니메이션과 시간에 민감한 상호 작용을 일시 중지하려고 할 수 있습니다.
    func adViewWillPresentScreen(_ bannerView: GADBannerView) {
        
    }
    
    /// 대리인에게 전체 화면보기가 닫히도록 지시합니다.
    func adViewWillDismissScreen(_ bannerView: GADBannerView) {
        
    }
    
    /// 대리인에게 전체 화면보기가 해제되었음을 알립니다. 대리인이 다시 시작해야합니다
    /// adViewWillPresentScreen :을 처리하는 동안 일시 중지 된 항목
    func adViewDidDismissScreen(_ bannerView: GADBannerView) {
        
    }
    
    /// 델리게이트는 사용자가 클릭하면 다른 앱이 열리고
    /// 신청. applicationDidEnterBackground :와 같은 표준 UIApplicationDelegate 메소드
    ///이 메소드가 호출되기 직전에 호출됩니다.
    func adViewWillLeaveApplication(_ bannerView: GADBannerView) {
        
    }
}

extension AdManager: GADUnifiedNativeAdLoaderDelegate {
    func adLoader(_ adLoader: GADAdLoader, didReceive nativeAd: GADUnifiedNativeAd) {
        self.구글네이티브광고 = nativeAd
        self.구글네이티브광고?.rootViewController = 타겟ViewController
        delegate?.네이티브광고Loaded()
    }
    
    func adLoader(_ adLoader: GADAdLoader, didFailToReceiveAdWithError error: GADRequestError) {
        페이스북네이티브광고?.loadAd()
    }
}

extension AdManager: FBAdViewDelegate {
    //사람이 광고를 클릭 한 후에 보냄
    func adViewDidClick(_ adView: FBAdView) {
        
    }
    
    //  광고를 클릭하면 모달보기가 표시됩니다. 그리고 사용자가 완료되면 모달보기와 상호 작용하고 무시하면이 메시지가 전송되어 제어를 반환합니다.
    func adViewDidFinishHandlingClick(_ adView: FBAdView) {
        
    }
    
    // 광고가 성공적으로로드되면 전송됩니다.
    func adViewDidLoad(_ adView: FBAdView) {
        adView.alpha = 0
        UIView.animate(withDuration: 1, animations: {
            adView.alpha = 1
        })
    }
    
    // FBAdView가 광고를로드하지 못한 후 전송됩니다.
    func adView(_ adView: FBAdView, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
    
    //  FBAdView 개체의 인상이 기록되기 직전에 전송됩니다.
    func adViewWillLogImpression(_ adView: FBAdView) {
        
    }
}

extension AdManager: FBNativeAdDelegate {
    func nativeAdDidLoad(_ nativeAd: FBNativeAd) {
        self.페이스북네이티브광고 = nativeAd
        delegate?.네이티브광고Loaded()
    }
    
    func nativeAd(_ nativeAd: FBNativeAd, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
}
