//
//  MovieDetailViewController.swift
//  Moop
//
//  Created by Chang Woo Son on 23/05/2019.
//  Copyright © 2019 kor45cw. All rights reserved.
//

import UIKit
import SafariServices

class MovieDetailViewController: UIViewController {
    
    @IBOutlet private weak var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
        }
    }
    @IBOutlet private weak var headerView: MovieDetailHeaderView!

    var item: MovieInfo?
    var totalCount = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = item?.title
        headerView.set(item)
        headerView.delegate = self
    }
}

extension MovieDetailViewController: DetailHeaderDelegate {
    func wrapper(type: TheaterType) {
        let webURL: URL?
        switch type {
        case .cgv:
            webURL = URL(string: "http://m.cgv.co.kr/WebApp/MovieV4/movieDetail.aspx?MovieIdx=\(item?.cgv?.id ?? "")")
        case .lotte:
            webURL = URL(string: "http://www.lottecinema.co.kr/LCMW/Contents/Movie/Movie-Detail-View.aspx?movie=\(item?.lotte?.id ?? "")")
        case .megabox:
            webURL = URL(string: "http://m.megabox.co.kr/?menuId=movie-detail&movieCode=\(item?.megabox?.id ?? "")")
        }
        
        guard let url = webURL else { return }
        let safariViewController = SFSafariViewController(url: url)
        present(safariViewController, animated: true, completion: nil)
    }
    
    func share() {
        let shareText = "제목: \(item?.title ?? "")\n개봉일: \(item?.openDate ?? "")\n\(item?.ageBadgeText ?? "")"
        let viewController = UIActivityViewController(activityItems: [shareText], applicationActivities: [])
        present(viewController, animated: true, completion: nil)
    }
}

extension MovieDetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var numberOfRows = 0
        numberOfRows += item?.naver != nil ? 1 : 0
        numberOfRows += (item?.trailers?.isEmpty ?? true) ? 0 : 2
        numberOfRows += item?.trailers?.count ?? 0
        totalCount = numberOfRows
        return numberOfRows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.item == 0 && item?.naver != nil {
            let cell = tableView.dequeueReusableCell(withIdentifier: "NaverInfoCell", for: indexPath) as! NaverInfoCell
            cell.set(item?.naver)
            return cell
        }
        if (indexPath.item == 1 && item?.naver != nil) || (indexPath.item == 0 && item?.naver == nil) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TrailerHeaderCell", for: indexPath) as! TrailerHeaderCell
            cell.set(item?.title ?? "")
            return cell
        }
        if totalCount - 1 == indexPath.item {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TrailerFooterCell", for: indexPath)
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "TrailerCell", for: indexPath) as! TrailerCell
        let targetIndex = item?.naver != nil ? 2 : 1
        cell.set(item?.trailers?[indexPath.item - targetIndex])
        return cell
    }
}

extension MovieDetailViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView.cellForRow(at: indexPath) is NaverInfoCell {
            guard let url = URL(string: item?.naver?.link ?? "") else { return }
            let safariViewController = SFSafariViewController(url: url)
            present(safariViewController, animated: true, completion: nil)
        }
        
        if let cell = tableView.cellForRow(at: indexPath) as? TrailerCell {
            guard let httpURL = URL(string: "http://www.youtube.com/watch?v=\(cell.youtubeId ?? "")"),
                let youtubeURL = URL(string: "youtube://\(cell.youtubeId ?? "")") else { return }
            if UIApplication.shared.canOpenURL(youtubeURL) {
                UIApplication.shared.open(youtubeURL, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.open(httpURL, options: [:], completionHandler: nil)
            }
        }
        
        if tableView.cellForRow(at: indexPath) is TrailerFooterCell {
            let title = item?.title.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
            guard let httpURL = URL(string: "https://www.youtube.com/results?search_query=\(title ?? "")"),
                let youtubeURL = URL(string: "youtube://www.youtube.com/results?search_query=\(title ?? "")") else { return }
            if UIApplication.shared.canOpenURL(youtubeURL) {
                UIApplication.shared.open(youtubeURL, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.open(httpURL, options: [:], completionHandler: nil)
            }
        }
        
    }
}
