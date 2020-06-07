//
//  RealmManager.swift
//  Moop
//
//  Created by kor45cw on 2020/03/05.
//  Copyright © 2020 kor45cw. All rights reserved.
//

import RealmSwift

class RealmManager {
    private let realm: Realm
    
    static let shared = RealmManager()
    
    private init() {
        do {
            self.realm = try Realm()
        } catch {
            fatalError("REALM Manager Error \(error.localizedDescription)")
        }
    }
    
    func saveData(items: [Movie]) {
        try? realm.write {
            realm.add(items, update: .modified)
        }
    }
    
    func beginWrite() {
        realm.beginWrite()
    }
    
    func commitWrite() {
        try? realm.commitWrite()
    }
    
    func saveData(item: Movie?) {
        guard let item = item else { return }
        try? realm.write {
            realm.add(item, update: .modified)
        }
    }
    
    func deleteData(items: [Movie]) {
        try? realm.write {
            realm.delete(items)
        }
    }
    
    func fetchNotification(_ block: @escaping (RealmCollectionChange<Results<Movie>>) -> Void) -> NotificationToken {
        realm.objects(Movie.self).observe(block)
    }
    
    func fetchData<T: Object>(predicate: NSPredicate) -> T? {
        realm.objects(T.self).filter(predicate).first
    }
    
    func fetchDatas<T: Object>(predicate: NSPredicate) -> Results<T> {
        realm.objects(T.self).filter(predicate)
    }
}
