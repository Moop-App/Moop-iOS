//
//  SettingDividerCell.swift
//  Moop
//
//  Created by Chang Woo Son on 25/05/2019.
//  Copyright © 2019 kor45cw. All rights reserved.
//

import UIKit
import kor45cw_Extension

class SettingDividerCell: UITableViewCell, NibLoadableView {
    @IBOutlet weak var dividerView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
    }
}
