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


final class ViewController: UIViewController {
    
    @IBOutlet private var moviesListContainer: UIView!
    @IBOutlet private var posterImageView: UIImageView!
    @IBOutlet private var posterBtn: UIButton!
    
    private var animationView: LottieAnimationView?
    let viewModel = HomeViewModel()
    let bag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Today's Flick Fix"
        
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
        
                self.tabBarController?.rx
            .didSelect.subscribe(onNext: { [weak self] item in
                if let hero = item as? HeroViewController {
                    hero.viewModel = self?.viewModel ?? HomeViewModel()
                }
            })
            .disposed(by: bag)
    
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
    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detail", let detailVc = segue.destination as? MovieDetailViewController {
            detailVc.viewModel = self.viewModel
        }
    }
  

}


class HomeViewModel {
    
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
    
    func generateRandomMovie(hero: HeroName) {
        if let random = self.movies.value.filter({$0.title.localizedCaseInsensitiveContains(hero.name)}).randomElement() {
            print(random)
        }
    }
}


extension UIView{

    func showLoader(backgroundColor: UIColor = .clear) {
        let backgroundView = UIView()
        backgroundView.frame = CGRect.init(x: 0, y: 0, width: self.bounds.width, height: self.bounds.height)
        backgroundView.backgroundColor = backgroundColor
        backgroundView.tag = 475647
        let animationView = LottieAnimationView.init(name: "BatmanWhite")
        animationView.frame = self.bounds
        // 3. Set animation content mode
        animationView.contentMode = .scaleAspectFit
        // 4. Set animation loop mode
        animationView.loopMode = .loop
        // 5. Adjust animation speed
        animationView.animationSpeed = 0.9
        backgroundView.addSubview(animationView)
        // 6. Play animation
        animationView.play()
        self.addSubview(backgroundView)
        self.bringSubviewToFront(backgroundView)
    }

    func hideLoader() {
        if let background = viewWithTag(475647){
            background.removeFromSuperview()
        }
        self.isUserInteractionEnabled = true
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

extension String {
    func contains(find: String) -> Bool{
        return self.range(of: find) != nil
    }
    func containsIgnoringCase(find: String) -> Bool{
        return self.range(of: find, options: .caseInsensitive) != nil
    }
}
