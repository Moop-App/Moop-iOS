//
//  StoreKitManager.swift
//  Moop
//
//  Created by kor45cw on 2020/06/04.
//  Copyright © 2020 kor45cw. All rights reserved.
//

import SwiftyStoreKit

class StoreKitManager {
    static let shared = StoreKitManager()
    
    #if DEBUG
    private let appleValidator = AppleReceiptValidator(service: .sandbox, sharedSecret: AdConfig.sharedSecretKey)
    #else
    private let appleValidator = AppleReceiptValidator(service: .production, sharedSecret: AdConfig.sharedSecretKey)
    #endif
    
    private init() { }
    
    func setup() {
        completeTransactions()
        if UserData.isAdFree {
            DispatchQueue.global(qos: .userInitiated).async {
                self.checkNormalValid(with: AdConfig.adFreeKey)
            }
        }
    }
    
    func completeTransactions() {
        // see notes below for the meaning of Atomic / Non-Atomic
        SwiftyStoreKit.completeTransactions(atomically: true) { [weak self] purchases in
            for purchase in purchases {
                switch purchase.transaction.transactionState {
                case .purchased, .restored:
                    if purchase.needsFinishTransaction {
                        // Deliver content from server, then:
                        SwiftyStoreKit.finishTransaction(purchase.transaction)
                    }
                    // Unlock content
                    self?.checkNormalValid(with: purchase.productId)
                case .failed, .purchasing, .deferred:
                break // do nothing
                @unknown default:
                    break
                }
            }
        }
    }
    
    func checkNormalValid(with productId: String) {
        SwiftyStoreKit.verifyReceipt(using: appleValidator) { result in
            switch result {
            case .success(let receipt):
                // Verify the purchase of Consumable or NonConsumable
                let purchaseResult = SwiftyStoreKit.verifyPurchase(
                    productId: productId,
                    inReceipt: receipt)
                
                switch purchaseResult {
                case .purchased(let receiptItem):
                    let isCanceled = receiptItem.cancellationDate != nil
                    print("\(productId) is purchased: \(receiptItem)")
                    UserData.isAdFree = !isCanceled
                case .notPurchased:
                    print("The user has never purchased \(productId)")
                    UserData.isAdFree = false
                }
            case .error(let error):
                print("Receipt verification failed: \(error)")
            }
        }
    }
    
    func fetchProductInfo(completionHandler: @escaping (String) -> Void) {
        SwiftyStoreKit.retrieveProductsInfo([AdConfig.adFreeKey]) { result in
            if let product = result.retrievedProducts.first,
                let priceString = product.localizedPrice {
                completionHandler(priceString)
            }
        }
    }
    
    func restorePurchases(completionHandler: @escaping () -> Void) {
        SwiftyStoreKit.restorePurchases { results in
            UserData.isAdFree = !results.restoredPurchases.isEmpty
            completionHandler()
        }
    }
    
    func purchase(with productId: String, completionHandler: @escaping () -> Void) {
        SwiftyStoreKit.purchaseProduct(productId, quantity: 1, atomically: true) { [weak self] result in
            switch result {
            case .success:
                UserData.isAdFree = true
                completionHandler()
                self?.checkNormalValid(with: productId)
            case .error(let error):
                print((error as NSError).localizedDescription)
            }
        }
    }
}
