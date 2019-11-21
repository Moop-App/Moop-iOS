//
//  SettingItemCell.swift
//  Moop
//
//  Created by Chang Woo Son on 25/05/2019.
//  Copyright © 2019 kor45cw. All rights reserved.
//

import UIKit
import SwiftyStoreKit
import kor45cw_Extension

class SettingItemCell: UITableViewCell, NibLoadableView {

    @IBOutlet weak var descriptionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
    }
    
    func requestInAppInfo() {
        SwiftyStoreKit.retrieveProductsInfo([AdConfig.adFreeKey]) { [weak self] result in
            guard let self = self else { return }
            if let product = result.retrievedProducts.first {
                let priceString = product.localizedPrice!
                self.descriptionLabel.text = "\("광고제거 구매하기".localized) \(priceString)"
                print("Product: \(product.localizedDescription), price: \(priceString)")
            } else if let invalidProductId = result.invalidProductIDs.first {
                print("Invalid product identifier: \(invalidProductId)")
            } else {
                print("Error: \(result.error?.localizedDescription ?? "")")
            }
        }
    }
}
