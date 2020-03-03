//
//  TheaterCell.swift
//  Moop
//
//  Created by kor45cw on 2019/10/09.
//  Copyright © 2019 kor45cw. All rights reserved.
//

import UIKit
import kor45cw_Extension

class TheaterCell: UITableViewCell, NibLoadableView {
    
    @IBOutlet private weak var cgvWraaper: TheaterRankView!
    @IBOutlet private weak var megaBoxWraaper: TheaterRankView!
    @IBOutlet private weak var lotteWraaper: TheaterRankView!
    
    weak var delegate: DetailHeaderDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }
    
    func set(_ item: Movie?) {
        guard let item = item else { return }
        cgvWraaper.set(item.cgvInfo, type: .cgv)
        megaBoxWraaper.set(item.megaboxInfo, type: .megabox)
        lotteWraaper.set(item.lotteInfo, type: .lotte)
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
