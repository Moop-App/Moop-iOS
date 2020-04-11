//
//  SettingCell.swift
//  Moop
//
//  Created by kor45cw on 2020/04/11.
//  Copyright © 2020 kor45cw. All rights reserved.
//

import UIKit
import SwiftyStoreKit

class SettingCell: UITableViewCell {
    
    @IBOutlet private weak var highlightView: UIView!
    @IBOutlet private weak var contentWrapperView: UIView!
    @IBOutlet private weak var dividerView: UIView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var iconImage: UIImageView!
    @IBOutlet private weak var adLabel: UILabel!
    
    var isFirst: Bool = false {
        didSet {
            if isFirst {
                contentWrapperView.clipsToBounds = true
                contentWrapperView.layer.cornerRadius = 8.0
                contentWrapperView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
            }
        }
    }
    
    var isLast: Bool = false {
        didSet {
            if isLast {
                dividerView.isHidden = true
                contentWrapperView.clipsToBounds = true
                contentWrapperView.layer.cornerRadius = 8.0
                contentWrapperView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
            }
        }
    }
    
    var isBoth: Bool = false {
        didSet {
            if isBoth {
                dividerView.isHidden = true
                contentWrapperView.clipsToBounds = true
                contentWrapperView.layer.cornerRadius = 8.0
                contentWrapperView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner, .layerMinXMinYCorner, .layerMaxXMinYCorner]
            }
        }
    }
    
    
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: true)
        highlightView.isHidden = !highlighted
    }
    
    func setAd(_ item: Section.Item) {
        iconImage.isHidden = true
        adLabel.isHidden = true
        descriptionLabel.isHidden = false
        titleLabel.text = item.title
        
        switch item {
        case .showAd:
            isFirst = true
            adLabel.isHidden = false
            descriptionLabel.text = "광고보기".localized
            isBoth = UserData.isAdFree
        case .inApp:
            fetchProductInfo(item.productId)
        case .restore:
            isLast = true
            descriptionLabel.isHidden = true
        default: return
        }
    }
    
    private func fetchProductInfo(_ item: String) {
        SwiftyStoreKit.retrieveProductsInfo([item]) { [weak self] result in
            if let product = result.retrievedProducts.first,
                let priceString = product.localizedPrice {
                self?.descriptionLabel.text = priceString
            }
        }
    }
    
    func setETC(_ item: Section.Item) {
        iconImage.isHidden = false
        descriptionLabel.isHidden = true
        titleLabel.text = item.title
        adLabel.isHidden = true
        switch item {
        case .showMap:
            isFirst = true
            
        case .version:
            isLast = true
            DispatchQueue.global(qos: .userInitiated).async {
                let currentAppstoreVersion = self.currentAppstoreVersion() ?? ""
                let currentAppVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
                self.isUpdatable = currentAppstoreVersion != currentAppVersion
                DispatchQueue.main.async {
                    self.descriptionLabel.isHidden = false
                    self.iconImage.isHidden = true
                    
                    self.descriptionLabel.text = "\("현재".localized) \(currentAppVersion) / \("최신".localized) \(currentAppstoreVersion)"
                }
            }
        default: return
        }
    }
    
    var isUpdatable: Bool = false
    
    private func currentAppstoreVersion() -> String? {
        guard let info = Bundle.main.infoDictionary,
            let identifier = info["CFBundleIdentifier"] as? String,
            let url = URL(string: "https://itunes.apple.com/lookup?bundleId=\(identifier)") else {
                return nil
        }
        do {
            let data = try Data(contentsOf: url)
            guard let json = try JSONSerialization.jsonObject(with: data, options: [.allowFragments]) as? [String: Any] else { return nil }
            guard let result = (json["results"] as? [Any])?.first as? [String: Any], let version = result["version"] as? String else { return nil }
            return version
        } catch {
            return nil
        }
    }
}

