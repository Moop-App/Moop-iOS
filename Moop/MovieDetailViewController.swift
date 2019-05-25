//
//  MovieDetailViewController.swift
//  Moop
//
//  Created by Chang Woo Son on 23/05/2019.
//  Copyright © 2019 kor45cw. All rights reserved.
//

import UIKit

class MovieDetailViewController: UIViewController {
    
    @IBOutlet private weak var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
        }
    }
    @IBOutlet private weak var headerView: MovieDetailHeaderView!

    var item: MovieInfo?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = item?.title
        headerView.set(item)
    }

}

extension MovieDetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var numberOfRows = 0
        numberOfRows += item?.naver != nil ? 1 : 0
        numberOfRows += (item?.trailers?.isEmpty ?? true) ? 0 : 2
        numberOfRows += item?.trailers?.count ?? 0
        return numberOfRows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NaverInfoCell", for: indexPath)
        return cell
    }
}

extension MovieDetailViewController: UITableViewDelegate {
    
}
