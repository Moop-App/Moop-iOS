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

    private var request: DataRequest? {
        didSet {
            oldValue?.cancel()
        }
    }
    
    private var reachability: NetworkReachabilityManager!

    private init() {
        monitorReachability()
    }
    
    private func monitorReachability() {
        reachability = NetworkReachabilityManager(host: "www.apple.com")
        reachability.startListening()
    }
    
    public func requestCurrent<T: Decodable>(completionHandler: @escaping (Result<[T], Error>) -> Void) {
        if [.notReachable, .unknown].contains(reachability.networkReachabilityStatus) {
            completionHandler(.failure(APIError.notReachable))
            return
        }
        self.request = AF.request(APISetupManager.currentRequestURL)
        self.request?
            .validate(statusCode: [200])
            .responseDecodable { (response: DataResponse<[T]>) in
                switch response.result {
                case .success(let items):
                    completionHandler(.success(items))
                case .failure(let error):
                    completionHandler(.failure(error))
                }
            }
    }
    
    public func requestFuture<T: Decodable>(completionHandler: @escaping (Result<[T], Error>) -> Void) {
        if [.notReachable, .unknown].contains(reachability.networkReachabilityStatus) {
            completionHandler(.failure(APIError.notReachable))
            return
        }
        self.request = AF.request(APISetupManager.futureRequestURL)
        self.request?
            .validate(statusCode: [200])
            .responseDecodable { (response: DataResponse<[T]>) in
                switch response.result {
                case .success(let items):
                    completionHandler(.success(items))
                case .failure(let error):
                    completionHandler(.failure(error))
                }
            }
    }
}
