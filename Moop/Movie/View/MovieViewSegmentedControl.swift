//
//  MovieViewSegmentedControl.swift
//  Moop
//
//  Created by kor45cw on 2019/10/12.
//  Copyright © 2019 kor45cw. All rights reserved.
//

import UIKit

protocol MovieViewSegmentedControlChangeDelegate: class {
    func trackSelected(index: Int)
}

class MovieViewSegmentedControl: UICollectionReusableView {
    
    private let segmentedControl: UISegmentedControl = {
        let segmentedControl = UISegmentedControl(items: ["현재상영".localized, "개봉예정".localized])
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.addTarget(self, action: #selector(selectedIndex(_:)), for: .valueChanged)
        return segmentedControl
    }()
    
    weak var delegate: MovieViewSegmentedControlChangeDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupAnchors()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc private func selectedIndex(_ sender: UISegmentedControl) {
        let index = sender.selectedSegmentIndex
        delegate?.trackSelected(index: index)
    }

    private func setupAnchors() {
        addSubview(segmentedControl)

        segmentedControl.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8).isActive = true
        segmentedControl.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -8).isActive = true
        segmentedControl.topAnchor.constraint(equalTo: self.topAnchor, constant: 8).isActive = true
        segmentedControl.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0).isActive = true
    }
}
