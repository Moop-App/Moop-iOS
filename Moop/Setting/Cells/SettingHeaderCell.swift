//
//  SettingHeaderCell.swift
//  Moop
//
//  Created by kor45cw on 2020/04/11.
//  Copyright © 2020 kor45cw. All rights reserved.
//

import UIKit

class SettingHeaderCell: UITableViewCell {
    @IBOutlet private weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
    }
    
    func set(_ title: String) {
        titleLabel.text = title
    }
}
