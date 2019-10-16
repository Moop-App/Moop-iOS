//
//  MovieInfoLabelView.swift
//  Moop
//
//  Created by kor45cw on 07/10/2019.
//  Copyright © 2019 kor45cw. All rights reserved.
//

import UIKit

class MovieInfoLabelView: UIView {
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    
    func configure(_ type: MovieInfoType, item: MovieInfo) {
        switch type {
        case .openDate:
            titleLabel.text = "개봉".localized
            descriptionLabel.text = item.openDate
        case .rating:
            titleLabel.text = "등급".localized
            descriptionLabel.text = item.age
        case .genre:
            titleLabel.text = "장르".localized
            descriptionLabel.text = item.genreText
        case .nation:
            titleLabel.text = "국가".localized
            descriptionLabel.text = item.nation
        case .runningTime:
            titleLabel.text = "러닝타임".localized
            descriptionLabel.text = "분".localizedFormat(item.showTime ?? 0)
        case .provider:
            titleLabel.text = "배급".localized
            descriptionLabel.text = item.provider
        }
    }
}

enum MovieInfoType {
    case openDate
    case rating
    case genre
    case nation
    case runningTime
    case provider
}
