//
//  ImdbCell.swift
//  Moop
//
//  Created by kor45cw on 2019/10/09.
//  Copyright © 2019 kor45cw. All rights reserved.
//

import UIKit
import kor45cw_Extension

class ImdbCell: UITableViewCell, NibLoadableView {
    @IBOutlet private weak var wrapperView: UIView!
    @IBOutlet private weak var imdbLabel: UILabel!
    @IBOutlet private weak var rtLabel: UILabel!
    @IBOutlet private weak var mcLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        wrapperView.elevate(elevation: 2.0)
    }
    
    func set(_ movie: Movie?) {
        guard let movie = movie else { return }
        imdbLabel.text = movie.imdb?.star
        rtLabel.text = movie.rt?.star ?? "-"
        mcLabel.text = movie.mc?.star ?? "-"
    }
}
