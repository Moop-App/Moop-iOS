//
//  NaverInfoCell.swift
//  Moop
//
//  Created by Chang Woo Son on 2019/06/15.
//  Copyright © 2019 kor45cw. All rights reserved.
//

import UIKit
import kor45cw_Extension

class NaverInfoCell: UITableViewCell, NibLoadableView {

    @IBOutlet private weak var wrapperView: UIView!
    @IBOutlet private weak var rankLabel: UILabel!

    weak var delegate: DetailHeaderDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        self.wrapperView.elevate(elevation: 2)
    }
    
    func set(_ item: Theater?) {
        guard let item = item else { return }
        self.rankLabel.text = item.star
    }
    
    @IBAction private func more(_ sender: UIButton) {
        delegate?.wrapper(type: .naver)
    }
}
