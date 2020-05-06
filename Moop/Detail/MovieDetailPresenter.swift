//
//  MovieDetailPresenter.swift
//  Moop
//
//  Created by kor45cw on 2020/03/01.
//  Copyright © 2020 kor45cw. All rights reserved.
//

import Foundation
import RealmSwift
import Networking

enum MovieDetailCellType {
    case header
    case boxOffice
    case imdb
    case cgv
    case plot
    case naver
    case trailer(Trailer)
    case trailerHeader
    case trailerFooter
    case ad
}

class MovieDetailPresenter {
    internal weak var view: MovieDetailViewDelegate!

    private let moopId: String
    private(set) var movieInfo: Movie?
    private var totalCell: [MovieDetailCellType] = []
    
    init(view: MovieDetailViewDelegate, moopId: String) {
        self.view = view
        self.moopId = moopId
        movieInfo = RealmManager.shared.fetchData(predicate: NSPredicate(format: "id = %@", moopId))
    }
    
    private func calculateCell() -> [MovieDetailCellType] {
        guard let info = movieInfo else { return [] }
        
        var result = [MovieDetailCellType.header]
        if info.boxOffice != nil {
            result.append(.boxOffice)
        }
        if info.imdb != nil {
            result.append(.imdb)
        }
        result.append(.cgv)
        if info.boxOffice == nil && info.naverInfo != nil {
            result.append(.naver)
        }
        if info.plot != nil {
            result.append(.plot)
        }
        result.append(.trailerHeader)
        info.trailers.forEach { result.append(.trailer($0)) }
        result.append(.trailerFooter)
        return result
    }
    
    var numberOfItemsInSection: Int {
        totalCell.count
    }
    
    var title: String {
        movieInfo?.title ?? ""
    }
    
    subscript(indexPath: IndexPath) -> MovieDetailCellType? {
        totalCell[safe: indexPath.item]
    }
    
    var adIndex: Array<Int>.Index? {
        if totalCell.contains(where: { cellType in
            switch cellType {
            case .ad: return true
            default: return false
            }
        }) { return nil }
        
        guard let index = totalCell.firstIndex(where: { cellType in
            switch cellType {
            case .trailerHeader: return true
            default: return false
            }
        }) else { return nil }
        totalCell.insert(.ad, at: index + 1)
        return index + 1
    }
}

extension MovieDetailPresenter: MovieDetailPresenterDelegate {
    func viewDidLoad() {
        if movieInfo == nil || !(movieInfo?.isUpdatedDetailInfo ?? false) {
            fetchData()
        } else {
            totalCell = calculateCell()
            view.loadFinished()
        }
    }
    
    private func fetchData() {
        API.shared.requestDetail(id: moopId) { [weak self] (result: Result<MovieDetailResponse, Error>) in
            guard let self = self else { return }
            switch result {
            case .success(let item):
                self.saveDetailInfo(with: item)
            case .failure(let error):
                print("Error requestDetail", error.localizedDescription)
                self.view.loadFailed()
            }
        }
    }
    
    private func saveDetailInfo(with response: MovieDetailResponse) {
        if let movieInfo = movieInfo {
            RealmManager.shared.beginWrite()
            movieInfo.set(detailResponse: response)
            RealmManager.shared.commitWrite()
        } else {
            let movieDetail = Movie(response: response)
            RealmManager.shared.saveData(item: movieDetail)
            movieInfo = movieDetail
        }
        
        totalCell = calculateCell()
        view.loadFinished()
    }
    
    func webURL(with type: TheaterType) -> URL? {
        switch type {
        case .cgv:
            return movieInfo?.cgvURL
        case .lotte:
            return movieInfo?.lotteURL
        case .megabox:
            return movieInfo?.megaboxURL
        case .naver:
            return movieInfo?.naverURL
        }
    }
}
