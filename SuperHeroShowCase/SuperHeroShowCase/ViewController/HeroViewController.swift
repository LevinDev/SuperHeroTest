//
//  HeroViewController.swift
//  SuperHeroShowCase
//
//  Created by Levin Varghese on 09/06/2023.
//

import UIKit
import RxSwift

class HeroViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var viewModel = HomeViewModel()
    var bag = DisposeBag()
    
    fileprivate var cardSize: CGSize {
        let layout = collectionView.collectionViewLayout as! ScrollCardCollectionViewLayout
        var cardSize = layout.itemSize
        cardSize.width =  cardSize.width + layout.minimumLineSpacing
        return cardSize
    }
       
    override func viewDidLoad() {
        if let nav = self.tabBarController?.viewControllers?.first as? UINavigationController, let vc =  nav.topViewController as? ViewController {
            self.viewModel = vc.viewModel
        }

        super.viewDidLoad()
        self.navigationItem.title = "Choose Your Hero"
        collectionView.register(UINib(nibName: "ScrollCardCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ScrollCardCollectionViewCellIdentifier")
        collectionView.clipsToBounds = false
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationController?.navigationItem.largeTitleDisplayMode = .always
    }
    

}

extension HeroViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ScrollCardCollectionViewCellIdentifier", for: indexPath) as! ScrollCardCollectionViewCell
        cell.movieImage.image = UIImage(named: HeroName.getHeros()[indexPath.row].imageName)
        cell.contentView.layer.cornerRadius = 15.0
        cell.contentView.layer.masksToBounds = true
        
        cell.movieImage.layer.shadowColor = UIColor.lightGray.cgColor
        cell.movieImage.layer.shadowOffset = CGSize(width: 10, height: 10)
        cell.movieImage.layer.shadowRadius = 20
        cell.movieImage.layer.shadowOpacity = 0.2
        cell.movieImage.layer.masksToBounds = false
        cell.movieImage.layer.shadowPath = UIBezierPath(roundedRect: cell.movieImage.layer.bounds, cornerRadius: cell.movieImage.layer.cornerRadius).cgPath
        
        return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return HeroName.getHeros().count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedHero = HeroName.getHeros()[indexPath.row]
        self.viewModel.generateRandomMovie(hero: selectedHero)
    }
}
