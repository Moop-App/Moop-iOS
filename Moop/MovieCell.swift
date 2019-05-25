//
//  MovieCell.swift
//  Moop
//
//  Created by Chang Woo Son on 22/05/2019.
//  Copyright © 2019 kor45cw. All rights reserved.
//

import UIKit

class MovieCell: UICollectionViewCell {
    
    @IBOutlet private weak var thumbnailImageView: UIImageView!
    @IBOutlet private weak var ageBadge: UIView!
    @IBOutlet private weak var bestView: UIView!
    @IBOutlet private weak var bestLabel: UILabel!
    
    func set(_ item: MovieInfo?) {
        guard let item = item else { return }
        thumbnailImageView.sd_setImage(with: URL(string: item.posterUrl))
        ageBadge.backgroundColor = item.ageColor
        bestView.isHidden = !item.isNew && !item.isBest
        
        if item.isNew {
            bestView.backgroundColor = .red
            bestLabel.text = "NEW"
        }
        if item.isBest {
            bestView.backgroundColor = .orange
            bestLabel.text = "BEST"
        }
    }
}
