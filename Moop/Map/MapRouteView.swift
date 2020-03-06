//
//  MapRouteView.swift
//  Moop
//
//  Created by kor45cw on 07/08/2019.
//  Copyright © 2019 kor45cw. All rights reserved.
//

import UIKit
import MapKit

enum RouteType: Int {
    case kakao = 0
    case naver
    case google
    case apple
}

protocol RouteDelegate: class {
    func route(type: RouteType)
}

class MapRouteView: UIView {
    @IBOutlet private weak var titleLabel: UILabel!
    
    weak var delegate: RouteDelegate?
    var annotation: MKAnnotation? {
        didSet {
            guard let annotation = annotation as? TheaterMapInfo else {
                clear()
                return
            }
            configure(annotation)
        }
    }
    
    private func clear() {
        self.titleLabel.text = nil
    }
    
    private func configure(_ annotation: TheaterMapInfo) {
        self.titleLabel.text = annotation.title
    }
    
    @IBAction private func route(_ sender: UIButton) {
        delegate?.route(type: RouteType(rawValue: sender.tag) ?? .apple)
    }
}
