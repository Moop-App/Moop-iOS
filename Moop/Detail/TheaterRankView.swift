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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        rankLabel.text = "-"
        self.elevate(elevation: 2)
    }
    
    func set(_ info: CGVInfo?) {
        guard let info = info else { return }
        theaterNameLabel.text = "CGV"
        rankLabel.text = info.egg
    }
    
    func set(_ info: LotteInfo?) {
        guard let info = info else { return }
        theaterNameLabel.text = "롯데시네마"
        rankLabel.text = info.star
    }
    
    func set(_ info: MegaBoxInfo?) {
        guard let info = info else { return }
        theaterNameLabel.text = "메가박스"
        rankLabel.text = info.star
    }
}
