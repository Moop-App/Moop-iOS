//
//  BoxOfficeCell.swift
//  Moop
//
//  Created by kor45cw on 2019/10/09.
//  Copyright © 2019 kor45cw. All rights reserved.
//

import UIKit

class BoxOfficeCell: UITableViewCell, ReusableView, NibLoadableView {
    
    @IBOutlet private weak var rankLabel: UILabel!
    @IBOutlet private weak var rankReferenceDateLabel: UILabel!
    @IBOutlet private weak var audienceCountLabel: UILabel!
    @IBOutlet private weak var audienceReferenceDateLabel: UILabel!
    @IBOutlet private weak var naverStarLabel: UILabel!
    @IBOutlet private weak var wrapperView: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        wrapperView.elevate(elevation: 2.0)
    }

    func set(_ info: MovieInfo?) {
        guard let info = info else { return }
        rankLabel.text = "\(info.kobis?.boxOffice?.rank ?? 0)위"
        rankReferenceDateLabel.text = "\(Date.yesterday.MM_dd) 기준"
        audienceCountLabel.text = "\(info.kobis?.boxOffice?.audiAcc.withCommas() ?? "0")명"
        audienceReferenceDateLabel.text = "개봉 \(-info.getDay)일차"
        naverStarLabel.text = info.naver?.userRating ?? "-"
    }
}
