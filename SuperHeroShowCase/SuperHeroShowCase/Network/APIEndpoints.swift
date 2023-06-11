//
//  APIEndpoints.swift
//  SuperHeroShowCase
//
//  Created by Levin Varghese on 09/06/2023.
//

import Moya
import UIKit

enum API {
    case getSuperHeroMovies(page: String)
    case popular
    case top_rated
    case upcoming
}

extension API: TargetType {
    var baseURL: URL {
        guard let url = URL(string: AppConfig.baseURLPath) else { fatalError() }
        return url
    }
    
    var path: String {
        switch self {
        case .popular:
            return "popular"
        case .top_rated:
            return "top_rated"
        case .upcoming:
            return "upcoming"
        case .getSuperHeroMovies(page: let page):
            return "/discover/movie?include_adult=false&include_video=false&language=en-US&page=\(page)&sort_by=popularity.desc&with_keywords=9715&with_original_language=en"
        }
    }
    
    var method: Moya.Method {
        return .get
    }
    
    var parameterEncoding: ParameterEncoding {
            switch self {
                case .getSuperHeroMovies(page: _):
                    return URLEncoding.queryString
                default:
                    return JSONEncoding.default
            }
}
    
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        switch self {
        case .getSuperHeroMovies(page: _):
            return .requestPlain
        case .popular,.top_rated, .upcoming:
            return .requestParameters(parameters: ["api_key": AppConfig.apiKey], encoding: URLEncoding.queryString)
        }
    }
    
    var headers: [String : String]? {
        return ["Authorization":  AppConfig.accessToken]
    }
}
