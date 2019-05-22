//
//  CurrentMovieViewController.swift
//  Moop
//
//  Created by Chang Woo Son on 22/05/2019.
//  Copyright © 2019 kor45cw. All rights reserved.
//

import UIKit
import Alamofire
import SDWebImage

class CurrentMovieViewController: UIViewController {

    @IBOutlet private weak var collectionView: UICollectionView! {
        didSet {
            collectionView.delegate = self
            collectionView.dataSource = self
            let nib = UINib(nibName: "MovieCell", bundle: nil)
            collectionView.register(nib, forCellWithReuseIdentifier: "MovieCell")
        }
    }
    
    private var datas: [MovieInfo] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let requestURL = URL(string: "\(Config.baseURL)/now/list.json")!
        AF.request(requestURL).validate(statusCode: [200]).responseDecodable { (response: DataResponse<[MovieInfo]>) in
            switch response.result {
            case .success(let result):
                self.datas = result
                self.collectionView.reloadData()
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}

extension CurrentMovieViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return datas.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieCell", for: indexPath) as! MovieCell
        cell.thumbnailImageView.sd_setImage(with: URL(string: datas[indexPath.item].posterUrl))
        return cell
    }
}

extension CurrentMovieViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth = (collectionView.bounds.width - 36) / 3
        return CGSize(width: cellWidth, height: cellWidth * 2)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
