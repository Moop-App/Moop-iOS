//
//  API.swift
//  Networking
//
//  Created by kor45cw on 17/08/2019.
//  Copyright © 2019 kor45cw. All rights reserved.
//

import Alamofire

public final class API {
    public static let shared: API = API()
    
    private var reachability: NetworkReachabilityManager!
    private var reachabilityStatus: NetworkReachabilityManager.NetworkReachabilityStatus = .unknown {
        didSet {
            guard oldValue != reachabilityStatus,
                ![.notReachable, .unknown].contains(reachabilityStatus), oldValue != .unknown else { return }
            self.requestRepeated()
        }
    }
    
    public static let notificationName = Notification.Name("didReceiveData")
    private var requestURL: String = ""
    
    
    private init() {
        monitorReachability()
    }
    
    private func monitorReachability() {
        NetworkReachabilityManager.default?.startListening { [weak self] status in
            guard let self = self else { return }
            self.reachabilityStatus = status
        }
    }
    
    private func requestRepeated() {
        AF.request(requestURL)
            .validate(statusCode: [200])
            .response { [weak self] response in
                guard let self = self else { return }
                switch response.result {
                case .success(let data):
                    let userInfo: [AnyHashable : Any] =  ["data": data ?? Data(),
                                                          "isCurrent": self.requestURL == APISetupManager.currentRequestURL]
                    NotificationCenter.default.post(name: API.notificationName, object: nil, userInfo: userInfo)
                case .failure(let error):
                    print("Error", error.localizedDescription)
                }
        }
    }
    
    public func requestCurrent<T: Decodable>(completionHandler: @escaping (Result<[T], Error>) -> Void) {
        self.requestURL = APISetupManager.currentRequestURL
        AF.request(requestURL)
            .validate(statusCode: [200])
            .responseDecodable { (response: AFDataResponse<[T]>) in
                switch response.result {
                case .success(let items):
                    completionHandler(.success(items))
                case .failure(let error):
                    completionHandler(.failure(error))
                }
        }
    }
    
    public func requestFuture<T: Decodable>(completionHandler: @escaping (Result<[T], Error>) -> Void) {
        self.requestURL = APISetupManager.futureRequestURL
        AF.request(requestURL)
            .validate(statusCode: [200])
            .responseDecodable { (response: AFDataResponse<[T]>) in
                switch response.result {
                case .success(let items):
                    completionHandler(.success(items))
                case .failure(let error):
                    completionHandler(.failure(error))
                }
        }
        
    }
    
    public func requestMapData<T: Decodable>(completionHandler: @escaping (Result<T, Error>) -> Void) {
        self.requestURL = APISetupManager.locationRequestURL
        AF.request(requestURL)
            .validate(statusCode: [200])
            .responseDecodable { (response: AFDataResponse<T>) in
                switch response.result {
                case .success(let item):
                    completionHandler(.success(item))
                case .failure(let error):
                    completionHandler(.failure(error))
                }
        }
    }
}
