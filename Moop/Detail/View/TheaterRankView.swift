//
//  TheaterRankView.swift
//  Moop
//
//  Created by Chang Woo Son on 24/05/2019.
//  Copyright © 2019 kor45cw. All rights reserved.
//

import UIKit

class TheaterRankView: UIView {
    @IBOutlet private weak var rankLabel: UILabel!
    @IBOutlet private weak var theaterNameLabel: UILabel!
    
    enum ViewType: String {
        case cgv = "CGV"
        case lotte = "롯데시네마"
        case megabox = "메가박스"
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        rankLabel.text = "-"
        self.elevate(elevation: 2)
    }
    
    func set(_ info: Theater?, type: ViewType) {
        guard let info = info else { return }
        theaterNameLabel.text = type.rawValue
        rankLabel.text = info.star
    }
}
