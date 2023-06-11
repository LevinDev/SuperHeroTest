//
//  DependencyInjection.swift
//  SuperHeroShowCase
//
//  Created by Levin Varghese on 11/06/2023.
//

import Foundation
import SwinjectStoryboard

extension SwinjectStoryboard {
    @objc class func setup() {
        let homeViewModel = HomeViewModel()
        defaultContainer.storyboardInitCompleted(ViewController.self) { r, c in
            c.viewModel = r.resolve(HomeViewModel.self)
        }
        defaultContainer.storyboardInitCompleted(HeroViewController.self) { r, c in
            c.viewModel = r.resolve(HomeViewModel.self)
        }
        defaultContainer.storyboardInitCompleted(MovieDetailViewController.self) { r, c in
            c.viewModel = r.resolve(HomeViewModel.self)
        }
        defaultContainer.register(HomeViewModel.self) { _ in homeViewModel }
    }
}
