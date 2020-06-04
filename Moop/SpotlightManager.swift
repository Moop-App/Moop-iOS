//
//  SpotlightManager.swift
//  Moop
//
//  Created by kor45cw on 2020/06/04.
//  Copyright © 2020 kor45cw. All rights reserved.
//

import SDWebImage
import CoreSpotlight
import MobileCoreServices

class SpotlightManager {
    static let shared = SpotlightManager()
    
    private init() {}
    
    
    
    func application(continue userActivity: NSUserActivity,
                     rootViewController: UIViewController?) {
        guard userActivity.activityType == CSSearchableItemActionType,
        let identifier = userActivity.userInfo?[CSSearchableItemActivityIdentifier] as? String,
        let rootViewController = rootViewController as? MainTabBarController else { return }
        
        guard let navi = rootViewController.selectedViewController as? UINavigationController else { return }
        
        let targetView = MovieDetailView.instance(id: identifier)
        navi.pushViewController(targetView, animated: true)
    }
    
    func addIndexes(items: [Movie]) {
        items.forEach { movie in
            self.fetchThumbnail(with: movie.posterURL) { [weak self] imageData in
                self?.indexItem(with: movie, image: imageData)
            }
        }
    }
    
    private func fetchThumbnail(with url: String, completionHandler: @escaping (Data?) -> Void) {
        SDWebImageManager.shared.loadImage(with: URL(string: url),
                                           options: [],
                                           progress: nil) { (image, data, error, cacheType, isFinished, imageUrl) in
                                            completionHandler(image?.pngData())
        }
    }
    
    private func indexItem(with item: Movie, image: Data?) {
        let attributeSet = CSSearchableItemAttributeSet(itemContentType: kUTTypeText as String)
        attributeSet.displayName = item.title
        attributeSet.contentDescription = "개봉".localized + " \(item.openDate)\n\(item.actors.joined(separator: ", "))"
        attributeSet.keywords = Array(item.genres) + Array(item.nations) + Array(item.directors) + Array(item.actors) + Array(item.companies)
        attributeSet.thumbnailData = image
        
        let item = CSSearchableItem(uniqueIdentifier: item.id, domainIdentifier: "com.kor45cw.Moop", attributeSet: attributeSet)
        CSSearchableIndex.default().indexSearchableItems([item]) { error in
            if let error = error {
                print("Indexing error: \(error.localizedDescription)")
            } else {
                print("Search item successfully indexed!")
            }
        }
    }
    
    func removeIndexes(with ids: [String]) {
        CSSearchableIndex.default().deleteSearchableItems(withIdentifiers: ids) { error in
            if let error = error {
                print("Indexing error: \(error.localizedDescription)")
            } else {
                print("Search item successfully deleted!")
            }
        }
    }
}
