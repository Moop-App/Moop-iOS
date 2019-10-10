//
//  PosterWithInfoCell.swift
//  Moop
//
//  Created by kor45cw on 2019/10/09.
//  Copyright © 2019 kor45cw. All rights reserved.
//

import UIKit

class PosterWithInfoCell: UITableViewCell, ReusableView, NibLoadableView {
    
    @IBOutlet private weak var posterImageView: UIImageView!
    
    @IBOutlet private weak var ageBadge: UIView!
    @IBOutlet private weak var ageLabel: UILabel!
    @IBOutlet private weak var newBadge: UIView!
    @IBOutlet private weak var bestBadge: UIView!
    @IBOutlet private weak var dDayBadge: UIView!
    @IBOutlet private weak var dDayLabel: UILabel!
    
    @IBOutlet private weak var openDateView: MovieInfoLabelView!
    @IBOutlet private weak var ratingView: MovieInfoLabelView!
    @IBOutlet private weak var genreView: MovieInfoLabelView!
    @IBOutlet private weak var nationView: MovieInfoLabelView!
    @IBOutlet private weak var runningTimeView: MovieInfoLabelView!
    @IBOutlet private weak var providerView: MovieInfoLabelView!
    
    weak var delegate: DetailHeaderDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        newBadge.backgroundColor = .red
        bestBadge.backgroundColor = .orange
        dDayBadge.backgroundColor = .gray
    }
    
    func set(_ item: MovieInfo?) {
        guard let item = item else { return }
        posterImageView.sd_setImage(with: URL(string: item.posterUrl))
        
        ageBadge.backgroundColor = item.ageColor
        newBadge.isHidden = !item.isNew
        bestBadge.isHidden = !item.isBest
        dDayBadge.isHidden = !item.isDDay
        
        ageLabel.text = item.ageBadgeText
        dDayLabel.text = item.dDayText
        
        openDateView.isHidden = item.openDate.isEmpty
        ratingView.isHidden = item.age.isEmpty
        genreView.isHidden = item.genreText == nil
        nationView.isHidden = item.nation == nil
        runningTimeView.isHidden = item.showTime == nil
        providerView.isHidden = item.provider == nil
        
        openDateView.configure(.openDate, item: item)
        ratingView.configure(.rating, item: item)
        genreView.configure(.genre, item: item)
        nationView.configure(.nation, item: item)
        runningTimeView.configure(.runningTime, item: item)
        providerView.configure(.provider, item: item)
    }
    
    @IBAction private func poster(_ sender: UIButton) {
        guard let image = posterImageView.image else { return }
        self.delegate?.poster(image)
    }
}
