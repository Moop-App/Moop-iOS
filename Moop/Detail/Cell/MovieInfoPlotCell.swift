//
//  MovieInfoPlotView.swift
//  Moop
//
//  Created by kor45cw on 2019/10/08.
//  Copyright © 2019 kor45cw. All rights reserved.
//

import UIKit

class MovieInfoPlotCell: UITableViewCell, ReusableView, NibLoadableView {
    
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var plotLabel: UILabel!
    @IBOutlet private weak var wrapperView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        titleLabel.text = "줄거리"
        wrapperView.elevate(elevation: 2)
    }
    
    func configure(_ plot: String?) {
        plotLabel.text = plot
    }
}
