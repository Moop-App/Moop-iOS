//
//  BoxOfficeCell.swift
//  Moop
//
//  Created by kor45cw on 2019/10/09.
//  Copyright © 2019 kor45cw. All rights reserved.
//

import UIKit
import kor45cw_Extension

class BoxOfficeCell: UITableViewCell, NibLoadableView {
    
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
        rankLabel.text = (info.kobis?.boxOffice?.rank ?? 0).ordinal
        rankReferenceDateLabel.text = "기준".localizedFormat(Date.yesterday.MM_dd)
        audienceCountLabel.text = "명".localizedFormat(info.kobis?.boxOffice?.audiAcc.withCommas() ?? "0")
        audienceReferenceDateLabel.text = "개봉%d일차".localizedFormat(-info.getDay)
        naverStarLabel.text = info.naver?.userRating ?? "-"
    }
}
