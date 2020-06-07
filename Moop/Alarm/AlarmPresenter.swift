//
//  AlarmPresenter.swift
//  Moop
//
//  Created by kor45cw on 2020/06/05.
//  Copyright © 2020 kor45cw. All rights reserved.
//

import Foundation
import RealmSwift

class AlarmPresenter {
    internal weak var view: AlarmViewDelegate!
    
    private var movies: [Movie] = []
    
    init(view: AlarmViewDelegate) {
        self.view = view
    }
}

extension AlarmPresenter: AlarmPresenterDelegate {
    var isEmpty: Bool {
        movies.isEmpty
    }
    
    func viewDidLoad() {
        let movies: Results<Movie> = RealmManager.shared.fetchDatas(predicate: NSPredicate(format: "isAlarm == true")).sorted(byKeyPath: "getDay")
        self.movies = movies.compactMap { $0 }
        view.loadFinished(self.movies)
    }
}
