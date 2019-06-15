//
//  MovieDetailHeaderView.swift
//  Moop
//
//  Created by Chang Woo Son on 24/05/2019.
//  Copyright © 2019 kor45cw. All rights reserved.
//

import UIKit

enum TheaterType {
    case cgv
    case lotte
    case megabox
}

protocol DetailHeaderDelegate: class {
    func wrapper(type: TheaterType)
    func share()
}

class MovieDetailHeaderView: UIView {
    @IBOutlet private weak var posterImageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var openDateLabel: UILabel!
    @IBOutlet private weak var cgvWraaper: TheaterRankView!
    @IBOutlet private weak var megaBoxWraaper: TheaterRankView!
    @IBOutlet private weak var lotteWraaper: TheaterRankView!
    
    @IBOutlet private weak var ageBadge: UIView!
    @IBOutlet private weak var ageLabel: UILabel!
    @IBOutlet private weak var newBadge: UIView!
    @IBOutlet private weak var bestBadge: UIView!
    @IBOutlet private weak var dDayBadge: UIView!
    @IBOutlet private weak var dDayLabel: UILabel!
    
    weak var delegate: DetailHeaderDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        newBadge.backgroundColor = .red
        bestBadge.backgroundColor = .orange
        dDayBadge.backgroundColor = .gray
    }
    
    func set(_ item: MovieInfo?) {
        guard let item = item else { return }
        posterImageView.sd_setImage(with: URL(string: item.posterUrl))
        titleLabel.text = item.title
        openDateLabel.text = item.openDate
        
        cgvWraaper.set(item.cgv)
        megaBoxWraaper.set(item.megabox)
        lotteWraaper.set(item.lotte)
        
        ageBadge.backgroundColor = item.ageColor
        newBadge.isHidden = !item.isNew
        bestBadge.isHidden = !item.isBest
        dDayBadge.isHidden = !item.isDDay
        
        ageLabel.text = item.ageBadgeText
        dDayLabel.text = item.dDayText
    }
    
    @IBAction private func share(_ sender: UIButton) {
        self.delegate?.share()
    }
    
    @IBAction private func cgvClick(_ sender: UIButton) {
        self.delegate?.wrapper(type: .cgv)
    }
    
    @IBAction private func lotteClick(_ sender: UIButton) {
        self.delegate?.wrapper(type: .lotte)
    }
    
    @IBAction private func megaBoxClick(_ sender: UIButton) {
        self.delegate?.wrapper(type: .megabox)
    }
}
