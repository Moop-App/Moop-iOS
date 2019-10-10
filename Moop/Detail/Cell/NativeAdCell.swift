//
//  NativeAdCell.swift
//  Moop
//
//  Created by kor45cw on 2019/10/10.
//  Copyright © 2019 kor45cw. All rights reserved.
//

import UIKit
import GoogleMobileAds

class NativeAdCell: UITableViewCell, ReusableView, NibLoadableView {
    
    @IBOutlet private weak var nativeAdView: GADUnifiedNativeAdView!
    
    var isVisible: Bool = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        nativeAdView.elevate(elevation: 2)
    }
    
    func set(_ nativeAd: GADUnifiedNativeAd?) {
        guard let nativeAd = nativeAd else { return }
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
        (nativeAdView.callToActionView as! UIButton).isUserInteractionEnabled = false

        self.isVisible = true
    }
}
