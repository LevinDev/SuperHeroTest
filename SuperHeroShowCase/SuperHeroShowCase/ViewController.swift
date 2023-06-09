//
//  ViewController.swift
//  SuperHeroShowCase
//
//  Created by Levin Varghese on 09/06/2023.
//

import UIKit
import RxSwift

class ViewController: UIViewController {
    
    let bag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        NetworkManager.shared.fetchPopularMovies(page: "1")
            .subscribe(onNext: { result in
                print(result.results.count)
            }).disposed(by: bag)
    }


}

