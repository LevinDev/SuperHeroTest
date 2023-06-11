//
//  MovieModels.swift
//  SuperHeroShowCase
//
//  Created by Levin Varghese on 09/06/2023.
//

import Foundation

struct SuperHeroMovieResponse: Codable {
    let page: Int
    let results: [movie]
    let totalPages, totalResults: Int

    enum CodingKeys: String, CodingKey {
        case page, results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}

// MARK: - Result
struct movie: Codable {
    let adult: Bool
    let backdropPath: String?
    let genreIDS: [Int]
    let id: Int
    var originalLanguage: OriginalLanguage?
    let originalTitle, overview: String
    let popularity: Double
    let posterPath, releaseDate, title: String
    let video: Bool
    let voteAverage: Double
    let voteCount: Int

    enum CodingKeys: String, CodingKey {
        case adult
        case backdropPath = "backdrop_path"
        case genreIDS = "genre_ids"
        case id
        case originalLanguage = "original_language"
        case originalTitle = "original_title"
        case overview, popularity
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case title, video
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
    }
}

enum OriginalLanguage: String, Codable {
    case en = "en"
    case ja = "ja"
}

struct HeroName {
    let name: String
    let imageName: String
    
    static func getHeros() -> [HeroName] {
        return [HeroName(name: "Spider-Man", imageName: "SpiderMan"),
                HeroName(name: "SuperMan", imageName: "superMan"),
                HeroName(name: "Batman", imageName: "Batman"),
                HeroName(name: "Wonder Woman", imageName: "WonderWoman"),
                HeroName(name: "Iron Man", imageName: "IronMan"),
                HeroName(name: "Captain America", imageName: "CaptainAmerica"),
                HeroName(name: "Thor", imageName: "Thor"),
                HeroName(name: "Shazam", imageName: "Shazam"),
                HeroName(name: "Deadpool", imageName: "DeadPool"),
                HeroName(name: "Venom", imageName: "Venom")]
    }
}
