//
//  TrailerCell.swift
//  Moop
//
//  Created by Chang Woo Son on 2019/06/15.
//  Copyright © 2019 kor45cw. All rights reserved.
//

import UIKit

class TrailerCell: UITableViewCell {

    @IBOutlet private weak var wrapperView: UIView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var authorLabel: UILabel!
    @IBOutlet private weak var thumbnailImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        self.wrapperView.elevate(elevation: 2)
    }
    
    func set(_ item: TrailerInfo?) {
        guard let item = item else { return }
        titleLabel.text = item.title
        authorLabel.text = item.author
        thumbnailImageView.sd_setImage(with: URL(string: item.thumbnailUrl))
    }
}
