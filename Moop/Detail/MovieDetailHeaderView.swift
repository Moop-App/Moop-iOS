//
//  MovieDetailHeaderView.swift
//  Moop
//
//  Created by Chang Woo Son on 24/05/2019.
//  Copyright © 2019 kor45cw. All rights reserved.
//

import UIKit

enum TheaterType: Int, Codable {
    case cgv = 0
    case lotte
    case megabox
    case naver
    
    var title: String {
        switch self {
        case .cgv:
            return "CGV"
        case .lotte:
            return "LOTTE"
        case .megabox:
            return "MegaBox"
        case .naver:
            return "Naver"
        }
    }
    
    init(type: String) {
        switch type {
        case "C": self = .cgv
        case "L": self = .lotte
        case "M": self = .megabox
        default: self = .cgv
        }
    }
    
    static var allCases: [TheaterType] {
        return [.cgv, .lotte, .megabox]
    }
}

protocol DetailHeaderDelegate: class {
    func wrapper(type: TheaterType)
    func favorite(isAdd: Bool)
    func share()
    func poster(_ image: UIImage)
}

class MovieDetailHeaderView: UIView {
    @IBOutlet private weak var posterImageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var openDateLabel: UILabel!
    @IBOutlet private weak var cgvWraaper: TheaterRankView!
    @IBOutlet private weak var megaBoxWraaper: TheaterRankView!
    @IBOutlet private weak var lotteWraaper: TheaterRankView!
    @IBOutlet private weak var favoriteButton: UIButton!
    
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
        
        guard let ids = UserDefaults.standard.array(forKey: .favorites) as? [String] else { return }
        favoriteButton.isSelected = ids.contains(item.id)
    }
    
    @IBAction private func poster(_ sender: UIButton) {
        guard let image = posterImageView.image else { return }
        self.delegate?.poster(image)
    }
    
    @IBAction private func share(_ sender: UIButton) {
        self.delegate?.share()
    }
    
    @IBAction private func favorite(_ sender: UIButton) {
        sender.isSelected.toggle()
        self.delegate?.favorite(isAdd: sender.isSelected)
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
