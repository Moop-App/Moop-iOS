//
//  NativeAdCell.swift
//  Moop
//
//  Created by kor45cw on 2019/10/10.
//  Copyright © 2019 kor45cw. All rights reserved.
//

import UIKit
import GoogleMobileAds
import FBAudienceNetwork
import kor45cw_Extension

class NativeAdCell: UITableViewCell, NibLoadableView {
    
    @IBOutlet private weak var nativeAdView: GADUnifiedNativeAdView!
    
    @IBOutlet private weak var facebookNativeAd: UIView!
    @IBOutlet private weak var adIconImageView: UIImageView!
    @IBOutlet private weak var adCoverMediaView: FBMediaView!
    @IBOutlet private weak var adTitleLabel: UILabel!
    @IBOutlet private weak var adBodyLabel: UILabel!
    @IBOutlet private weak var adCallToActionButton: UIButton!
    @IBOutlet private weak var adSocialContextLabel: UILabel!
    @IBOutlet private weak var sponsoredLabel: UILabel!
    @IBOutlet private weak var adOptionsView: FBAdOptionsView!
    
    var isVisible: Bool = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        nativeAdView.elevate(elevation: 2)
    }
    
    func set(_ nativeAd: FBNativeAd?, viewController: UIViewController) {
        guard let nativeAd = nativeAd, nativeAd.isAdValid else { return }
        facebookNativeAd.isHidden = false
        nativeAdView.isHidden = true
        
        nativeAd.unregisterView()
        
        nativeAd.registerView(forInteraction: facebookNativeAd, mediaView: adCoverMediaView, iconImageView: adIconImageView, viewController: viewController, clickableViews: nil)
        // Render native ads onto UIView
        adTitleLabel.text = nativeAd.advertiserName
        adBodyLabel.text = nativeAd.bodyText
        adSocialContextLabel.text = nativeAd.socialContext
        sponsoredLabel.text = nativeAd.sponsoredTranslation
        adCallToActionButton.setTitle(nativeAd.callToAction, for: .normal)
        adOptionsView.nativeAd = nativeAd
    }
    
    func set(_ nativeAd: GADUnifiedNativeAd?) {
        guard let nativeAd = nativeAd else { return }
        facebookNativeAd.isHidden = true
        nativeAdView.isHidden = false
        
        nativeAdView.nativeAd = nativeAd
        nativeAdView.mediaView?.mediaContent = nativeAd.mediaContent
        // Populate the native ad view with the native ad assets.
        // The headline and mediaContent are guaranteed to be present in every native ad.
        (nativeAdView.headlineView as? UILabel)?.text = nativeAd.headline
        // This app uses a fixed width for the GADMediaView and changes its height to match the aspect
        // ratio of the media it displays.

        // These assets are not guaranteed to be present. Check that they are before
        // showing or hiding them.
        (nativeAdView.bodyView as? UILabel)?.text = nativeAd.body
        nativeAdView.bodyView?.isHidden = nativeAd.body == nil

        (nativeAdView.callToActionView as? UIButton)?.setTitle(nativeAd.callToAction, for: .normal)
        nativeAdView.callToActionView?.isHidden = nativeAd.callToAction == nil

        (nativeAdView.iconView as? UIImageView)?.image = nativeAd.icon?.image
        nativeAdView.iconView?.isHidden = nativeAd.icon == nil

        (nativeAdView.storeView as? UILabel)?.text = nativeAd.store
        nativeAdView.storeView?.isHidden = nativeAd.store == nil

        (nativeAdView.priceView as? UILabel)?.text = nativeAd.price
        nativeAdView.priceView?.isHidden = nativeAd.price == nil

        (nativeAdView.advertiserView as? UILabel)?.text = nativeAd.advertiser
        nativeAdView.advertiserView?.isHidden = nativeAd.advertiser == nil

        // In order for the SDK to process touch events properly, user interaction should be disabled.
        (nativeAdView.callToActionView as? UIButton)?.isUserInteractionEnabled = false

        self.isVisible = true
    }
}
