//
//  FilterCell.swift
//  Moop
//
//  Created by kor45cw on 2020/05/01.
//  Copyright © 2020 kor45cw. All rights reserved.
//

import UIKit

class FilterCell: UITableViewCell {
    @IBOutlet private weak var highlightView: UIView!
    @IBOutlet private weak var contentWrapperView: UIView!
    @IBOutlet private weak var dividerView: UIView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet weak var checkButton: UIButton!
    
    var isFirst: Bool = false {
        didSet {
            if isFirst {
                contentWrapperView.clipsToBounds = true
                contentWrapperView.layer.cornerRadius = 8.0
                contentWrapperView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
            }
        }
    }
    
    var isLast: Bool = false {
        didSet {
            if isLast {
                dividerView.isHidden = true
                contentWrapperView.clipsToBounds = true
                contentWrapperView.layer.cornerRadius = 8.0
                contentWrapperView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
            }
        }
    }
    
    var isBoth: Bool = false {
        didSet {
            if isBoth {
                dividerView.isHidden = true
                contentWrapperView.clipsToBounds = true
                contentWrapperView.layer.cornerRadius = 8.0
                contentWrapperView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner, .layerMinXMinYCorner, .layerMaxXMinYCorner]
            }
        }
    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: true)
        highlightView.isHidden = !highlighted
    }
}

extension FilterCell {
    func configure(_ item: FilterSection.Item, isSelected: Bool) {
        checkButton.isHidden = !isSelected
        titleLabel.text = item.title
        
        switch item {
        case .cgv, .over19, .korean:
            isFirst = true
        case .megabox, .notDetermined, .etc:
            isLast = true
        case .boxOffice:
            isBoth = true
        default: break
        }
    }
}
