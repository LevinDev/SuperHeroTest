//
//  MovieDetailViewController.swift
//  SuperHeroShowCase
//
//  Created by Levin Varghese on 10/06/2023.
//

import UIKit
import RxSwift
import RxCocoa

class MovieDetailViewController: UIViewController {

    @IBOutlet private var posterImageView: UIImageView!
    @IBOutlet private var backdropImageView: UIImageView!
    @IBOutlet private var titlelabel: UILabel!
    @IBOutlet private var releaselabel: UILabel!
    @IBOutlet private var descriptionlabel: UILabel!
    @IBOutlet private var shuffleBtn: UIButton!
    
    var viewModel: MovieViewModel!
    let bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
    }
    
    private func bindViewModel() {
        viewModel.randomSelectedMovie
            .subscribe(onNext: { [weak self] movie in
                guard let selectedMovie = movie else {return}
                self?.loadMoview(movie: selectedMovie)
            }).disposed(by: bag)
        
        shuffleBtn.rx.tap
            .subscribe(onNext: { _ in
                if let newRandom =  self.viewModel.movies.value.randomElement() {
                    self.viewModel.randomSelectedMovie.accept(newRandom)
                }
            }).disposed(by: bag)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    private func loadMoview(movie: movie) {
        self.posterImageView.kf.setImage(with: movie.posterURL!) { reult in
            
        }
        if let background = movie.backgroundURL {
            self.backdropImageView.kf.setImage(with: background) { reult in
                
            }
        }
        titlelabel.text = movie.title
        descriptionlabel.text = movie.overview
        releaselabel.text = movie.releaseDate
    }

}
