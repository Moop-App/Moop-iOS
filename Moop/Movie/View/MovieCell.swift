//
//  MovieCell.swift
//  Moop
//
//  Created by Chang Woo Son on 22/05/2019.
//  Copyright © 2019 kor45cw. All rights reserved.
//

import UIKit
import SDWebImage
import kor45cw_Extension

class MovieCell: UICollectionViewCell, NibLoadableView {
    
    @IBOutlet private weak var thumbnailImageView: UIImageView!
    @IBOutlet private weak var ageBadge: UIView!
    @IBOutlet private weak var bestView: UIView!
    @IBOutlet private weak var bestLabel: UILabel!
    
    func set(_ item: Movie?, isFavorite: Bool = false) {
        guard let item = item else { return }
        if isFavorite {
            let url = URL(string: item.posterURL)
            SDWebImageManager.shared.loadImage(with: url, options: .continueInBackground, progress: nil) { (image, _, error, _, _, _) in
                if error == nil, let image = image {
                    self.thumbnailImageView.image = item.getDay > 0 ? image.gray : image
                }
            }
        } else {
            thumbnailImageView.sd_setImage(with: URL(string: item.posterURL))
        }
        ageBadge.backgroundColor = item.ageColor
        bestView.isHidden = !item.isNew && !item.isBest && !item.isDDay
        
        if item.isNew {
            bestView.backgroundColor = .red
            bestLabel.text = "NEW"
        }
        if item.isBest {
            bestView.backgroundColor = .orange
            bestLabel.text = "BEST"
        }
        if item.isDDay {
            bestView.backgroundColor = .gray
            bestLabel.text = item.dDayText
        }
    }
}
