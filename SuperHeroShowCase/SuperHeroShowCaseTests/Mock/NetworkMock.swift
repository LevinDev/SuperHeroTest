//
//  NetworkMock.swift
//  SuperHeroShowCaseTests
//
//  Created by Levin Varghese on 12/06/2023.
//

import Foundation
import Moya
import RxSwift

class NetworkManager: Networkable {
    
    var provider: Moya.MoyaProvider<API>
    
    init(provider: MoyaProvider<API>) {
        self.provider = provider
    }
  
    func request<T: Codable>(target: API) -> Observable<T>{
        Observable.empty()
    }
}
