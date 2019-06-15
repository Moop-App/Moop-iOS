//
//  TrailerFooterCell.swift
//  Moop
//
//  Created by Chang Woo Son on 2019/06/15.
//  Copyright © 2019 kor45cw. All rights reserved.
//

import UIKit

class TrailerFooterCell: UITableViewCell {

    @IBOutlet private weak var wrapperView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        self.wrapperView.elevate(elevation: 2)
        self.wrapperView.clipsToBounds = false
        self.wrapperView.layer.cornerRadius = 12
        self.wrapperView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
    }
}
