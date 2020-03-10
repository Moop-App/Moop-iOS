//
//  FilterPresenter.swift
//  Moop
//
//  Created by kor45cw on 2020/03/09.
//  Copyright © 2020 kor45cw. All rights reserved.
//

import Foundation

class FilterPresenter {
    internal weak var view: FilterViewDelegate!
    
    let originTheaters = FilterData.theater
    let originAgeTypes = FilterData.age
    let originBoxOffice = FilterData.boxOffice
    let originNations = FilterData.nation
    
    var ageTypes: [AgeType] = [] {
        didSet {
            view.updateDataInfo()
        }
    }
    var theaters: [TheaterType] = [] {
        didSet {
            view.updateDataInfo()
        }
    }
    
    var boxOffice: Bool = false {
        didSet {
            view.updateDataInfo()
        }
    }
    
    var nations: [NationInfo] = [] {
        didSet {
            view.updateDataInfo()
        }
    }
    
    init(view: FilterViewDelegate) {
        self.view = view
    }
    
    var isModalInPresentation: Bool {
        let isEqualTheaters = originTheaters.sorted(by: { $0.rawValue > $1.rawValue }) == theaters.sorted(by: { $0.rawValue > $1.rawValue })
        let isEqualAges = originAgeTypes.sorted(by: { $0.rawValue > $1.rawValue }) == ageTypes.sorted(by: { $0.rawValue > $1.rawValue })
        let isEqualBoxOfffice = originBoxOffice == boxOffice
        return !(isEqualTheaters && isEqualAges && isEqualBoxOfffice)
    }
    
    var isDoneButtonEnable: Bool {
        !theaters.isEmpty && !ageTypes.isEmpty && !nations.isEmpty
    }
    
    subscript(indexPath: IndexPath) -> (title: String, isSelected: Bool)? {
        switch indexPath.section {
        case 0:
            guard let type = TheaterType(rawValue: indexPath.item) else { return nil }
            return (type.title, theaters.contains(type))
        case 1:
            guard let type = AgeType(rawValue: indexPath.item) else { return nil }
            return (type.text, ageTypes.contains(type))
        case 2:
            let title = "박스오피스 순으로 정렬하기".localized
            return (title, boxOffice)
        default:
            let type = NationInfo(isKorean: indexPath.item == 0)
            return (type.rawValue.localized, nations.contains(type))
        }
    }
}

extension FilterPresenter: FilterPresenterDelegate {
    func viewDidLoad() {
        theaters = originTheaters
        ageTypes = originAgeTypes
        boxOffice = originBoxOffice
        nations = originNations
    }
    
    func done() {
        FilterData.theater = theaters
        FilterData.age = ageTypes
        FilterData.boxOffice = boxOffice
        FilterData.nation = nations
    }
    
    func didSelect(with indexPath: IndexPath) -> Bool? {
        switch indexPath.section {
        case 0:
            guard let type = TheaterType(rawValue: indexPath.item) else { return nil }
            if let index = theaters.firstIndex(of: type) {
                theaters.remove(at: index)
                return false
            } else {
                theaters.append(type)
                return true
            }
        case 1:
            guard let type = AgeType(rawValue: indexPath.item) else { return nil }
            if let index = ageTypes.firstIndex(of: type) {
                ageTypes.remove(at: index)
                return false
            } else {
                ageTypes.append(type)
                return true
            }
        case 2:
            boxOffice.toggle()
            return boxOffice
        default:
            let type = NationInfo(isKorean: indexPath.item == 0)
            if let index = nations.firstIndex(of: type) {
                nations.remove(at: index)
                return false
            } else {
                nations.append(type)
                return true
            }
        }
    }
}
