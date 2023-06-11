//
//  MovieViewModel.swift
//  SuperHeroShowCase
//
//  Created by Levin Varghese on 11/06/2023.
//

import Foundation
import RxSwift
import RxRelay

class MovieViewModel {
    
    var movies = BehaviorRelay<[movie]>(value: [])
    var randomSelectedMovie = BehaviorRelay<movie?>(value: .none)
    var loader = PublishRelay<Bool>()
    
    func fetchSuperHeroMovies() {
        self.loader.accept(true)
      let pageOne = NetworkManager.shared.fetchPopularMovies(page: "1")
      let pageTwo = NetworkManager.shared.fetchPopularMovies(page: "2")
      let pageThree = NetworkManager.shared.fetchPopularMovies(page: "3")
      
    _ = Observable.zip(pageOne, pageTwo, pageThree){ ($0, $1, $2) }.subscribe { (one, two, three) in
          var allMovies = [movie]()
        self.loader.accept(false)
        allMovies.append(contentsOf: one.results)
        allMovies.append(contentsOf: two.results)
        allMovies.append(contentsOf: three.results)
        self.movies.accept(allMovies)
          } onError: { error in
              self.loader.accept(false)
          }
    }
    
    func generateRandomMovie(hero: HeroName) -> movie? {
        if let random = self.movies.value.filter({$0.title.localizedCaseInsensitiveContains(hero.name)}).randomElement() {
            return random
        }
        return nil
    }
}
