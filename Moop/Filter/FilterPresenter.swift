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
    
    private let datas = FilterSection.allCases
    
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
    
    var numberOfSections: Int {
        datas.count
    }
    
    subscript(indexPath: IndexPath) -> (section: FilterSection, item: FilterSection.Item, isSelected: Bool)? {
        guard let section = datas[safe: indexPath.section],
            let item = section.contents[safe: indexPath.item] else { return nil }
        
        if item == .header {
            return (section, item, false)
        }
        switch section {
        case .theater:
            guard let type = TheaterType(rawValue: indexPath.item - 1) else { return nil }
            return (section, item, theaters.contains(type))
        case .age:
            guard let type = AgeType(rawValue: indexPath.item - 1) else { return nil }
            return (section, item, ageTypes.contains(type))
        case .boxOffice:
            return (section, item, boxOffice)
        case .nations:
            let type = NationInfo(isKorean: indexPath.item == 1)
            return (section, item, nations.contains(type))
        }
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
    
    func numberOfItemsInSection(_ section: Int) -> Int {
        datas[safe: section]?.contents.count ?? 0
    }
    
    func didSelect(with indexPath: IndexPath) -> Bool? {
        guard let section = datas[safe: indexPath.section],
            indexPath.item != 0 else { return nil }
        
        switch section {
        case .theater:
            guard let type = TheaterType(rawValue: indexPath.item - 1) else { return nil }
            if let index = theaters.firstIndex(of: type) {
                theaters.remove(at: index)
                return false
            } else {
                theaters.append(type)
                return true
            }
        case .age:
            guard let type = AgeType(rawValue: indexPath.item - 1) else { return nil }
            if let index = ageTypes.firstIndex(of: type) {
                ageTypes.remove(at: index)
                return false
            } else {
                ageTypes.append(type)
                return true
            }
        case .boxOffice:
            boxOffice.toggle()
            return boxOffice
        case .nations:
            let type = NationInfo(isKorean: indexPath.item == 1)
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
