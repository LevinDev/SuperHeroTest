//
//  Network.swift
//  SuperHeroShowCase
//
//  Created by Levin Varghese on 09/06/2023.
//

import Foundation
import Moya
import RxSwift
import RxMoya

let authMyOrganizationPlugin = AccessTokenPlugin {_ in
    return ""
}
var endPointMyOrganizationClousre  = { (target: API) -> Endpoint in

    let url = URL(target: target).absoluteString.removingPercentEncoding
    return Endpoint(url: url!,
                    sampleResponseClosure: {.networkResponse(200, target.sampleData)},
                    method: target.method, task: target.task,
                    httpHeaderFields: target.headers)
   

}

protocol Networkable{
    var provider: MoyaProvider<API> { get }
    func request<T: Codable>(target: API) -> Observable<T>
}

class NetworkManager: Networkable {
    
    
    var provider = MoyaProvider<API>(
        endpointClosure: endPointMyOrganizationClousre,
        plugins: [authMyOrganizationPlugin, NetworkLoggerPlugin(configuration: .init(logOptions: .verbose))])
    static let shared  = NetworkManager()
    
    func fetchPopularMovies(page: String) -> Observable<SuperHeroMovieResponse> {
        request(target: .getSuperHeroMovies(page: page))
    }
   

    func request<T: Codable>(target: API) -> Observable<T>{
        provider.rx.request(target)
            .asObservable()
            .debug()
            .map{ (result) in
                print(String(data: result.data, encoding: .nonLossyASCII) )
                return try result.map ( T.self )
            }
            .catch { error in
                return Observable.error(error)
            }
    }
}
