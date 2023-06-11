//
//  ViewController.swift
//  SuperHeroShowCase
//
//  Created by Levin Varghese on 09/06/2023.
//

import UIKit
import RxSwift
import Lottie
import RxRelay
import Kingfisher
import RxCocoa
import Hero


final class ViewController: UIViewController {
    
    @IBOutlet private var moviesListContainer: UIView!
    @IBOutlet private var posterImageView: UIImageView!
    @IBOutlet private var posterBtn: UIButton!
    
 
    var viewModel:MovieViewModel!
    let bag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.heroNavigationAnimationType = .fade
        self.navigationItem.title = "Today's Flick Fix"
        bindViewModel()
    }
    
    private func bindViewModel() {
        viewModel.movies
            .map({$0.randomElement()})
            .subscribe(onNext: { result in
                if let movie = result {
                    self.viewModel.randomSelectedMovie.accept(movie)
                }
            }).disposed(by: bag)
        
        viewModel.randomSelectedMovie
            .subscribe(onNext: { [weak self] movie in
                guard let selectedMovie = movie else {return}
                self?.loadMovieInfo(movie: selectedMovie)
            }).disposed(by: bag)
        
        viewModel.loader
            .subscribe(onNext: { val in
                if val {
                    self.view.showLoader()
                } else {
                    self.view.hideLoader()
                }
            }).disposed(by: bag)
        
        viewModel.fetchSuperHeroMovies()
        
        self.posterBtn.rx.tap.subscribe(onNext: { _ in
            self.performSegue(withIdentifier: "detail", sender: nil)
        }).disposed(by: bag)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationController?.navigationItem.largeTitleDisplayMode = .always
    }

    private func loadMovieInfo(movie: movie) {
        self.moviesListContainer.showLoader()
        self.posterImageView.kf.setImage(with: movie.posterURL!) { reult in
            self.moviesListContainer.hideLoader()
        }
    }

}

extension movie {
    public var posterURL: URL? {
        if !self.posterPath.isEmpty {
            return URL(string: "https://image.tmdb.org/t/p/w500\(self.posterPath)")
        }
        return nil
    }
    
    public var backgroundURL: URL? {
        if !(self.backdropPath?.isEmpty ?? true) {
            return URL(string: "https://image.tmdb.org/t/p/w500\(self.backdropPath!)")
        }
        return nil
    }
}
