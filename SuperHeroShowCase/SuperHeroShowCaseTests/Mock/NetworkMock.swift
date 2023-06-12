//
//  NetworkMock.swift
//  SuperHeroShowCaseTests
//
//  Created by Levin Varghese on 12/06/2023.
//

import Foundation
import Moya
import RxSwift
import RxCocoaRuntime

class NetworkManagerMock: Networkable {
    
    var provider: Moya.MoyaProvider<API>
    
    init(provider: MoyaProvider<API>) {
        self.provider = provider
    }
  
    func request<T: Codable>(target: API) -> Observable<T>{
        Observable.just(SuperHeroMovieResponse(page: 1, results: [], totalPages: 2, totalResults: 5) as! T)
    }
}
