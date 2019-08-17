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
    private var reachabilityStatus: NetworkReachabilityManager.NetworkReachabilityStatus = .unknown {
        didSet {
            guard oldValue != reachabilityStatus,
                ![.notReachable, .unknown].contains(reachabilityStatus) else { return }
            // TODO: RETRY
            self.requestRepeated()
            
        }
    }

    public static let notificationName = Notification.Name("didReceiveData")
    private var requestURL: String = ""
    
    
    private init() {
        monitorReachability()
    }
    
    private func monitorReachability() {
        reachability = NetworkReachabilityManager(host: "www.apple.com")
        
        reachability.listener = { [weak self] status in
            guard let self = self else { return }
            self.reachabilityStatus = status
        }
        
        reachability.startListening()
    }
    
    private func requestRepeated() {
        self.request = AF.request(requestURL)
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
        self.request = AF.request(requestURL)
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
        self.requestURL = APISetupManager.futureRequestURL
        self.request = AF.request(requestURL)
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
