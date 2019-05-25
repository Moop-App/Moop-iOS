//
//  FutureMovieViewController.swift
//  Moop
//
//  Created by Chang Woo Son on 23/05/2019.
//  Copyright © 2019 kor45cw. All rights reserved.
//

import UIKit
import Alamofire

class FutureMovieViewController: UIViewController {

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
        
        let requestURL = URL(string: "\(Config.baseURL)/plan/list.json")!
        AF.request(requestURL)
            .validate(statusCode: [200])
            .responseDecodable { (response: DataResponse<[MovieInfo]>) in
                switch response.result {
                case .success(let result):
                    self.datas = result.sorted(by: { $0.getDay < $1.getDay })
                    self.collectionView.reloadData()
                case .failure(let error):
                    print(error.localizedDescription)
                }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier else { return }
        
        switch identifier {
        case "toDetails":
            guard let destination = segue.destination as? MovieDetailViewController,
                let indexPathItem = sender as? Int else { return }
            let item = datas[indexPathItem]
            destination.item = item
        default:
            break
        }
    }
}

extension FutureMovieViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return datas.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieCell", for: indexPath) as! MovieCell
        cell.set(datas[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "toDetails", sender: indexPath.item)
    }
}

extension FutureMovieViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth = (collectionView.bounds.width - 36) / 3
        return CGSize(width: cellWidth, height: cellWidth / 600.0 * 855)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
