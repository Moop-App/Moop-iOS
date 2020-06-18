//
//  TrailerHeaderCell.swift
//  Moop
//
//  Created by Chang Woo Son on 2019/06/15.
//  Copyright © 2019 kor45cw. All rights reserved.
//

import UIKit
import kor45cw_Extension

class TrailerHeaderCell: UITableViewCell, NibLoadableView {

    @IBOutlet private weak var wrapperView: UIView!
    @IBOutlet private weak var titleLabel: UILabel!

    weak var delegate: DetailHeaderDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        self.wrapperView.elevate(elevation: 2)
        self.wrapperView.clipsToBounds = false
        self.wrapperView.layer.cornerRadius = 12
        self.wrapperView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    }
    
    func set(_ title: String) {
        titleLabel.text = "'\(title) 예고편' 검색 결과"
    }
    
    @IBAction private func youtubePrivacy(_ sender: UIButton) {
        delegate?.privacy()
    }
}
