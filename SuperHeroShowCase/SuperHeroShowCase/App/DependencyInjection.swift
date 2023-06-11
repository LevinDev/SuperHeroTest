//
//  DependencyInjection.swift
//  SuperHeroShowCase
//
//  Created by Levin Varghese on 11/06/2023.
//

import Foundation
import SwinjectStoryboard
import Moya

extension SwinjectStoryboard {
    @objc class func setup() {
        let provider = MoyaProvider<API>(
            endpointClosure: endPointMyOrganizationClousre,
            plugins: [authMyOrganizationPlugin, NetworkLoggerPlugin(configuration: .init(logOptions: .verbose))])
        let networkService = NetworkManager(provider: provider)
        let homeViewModel = MovieViewModel(service: MovieService(network: networkService))
        defaultContainer.storyboardInitCompleted(ViewController.self) { r, c in
            c.viewModel = r.resolve(MovieViewModel.self)
        }
        defaultContainer.storyboardInitCompleted(HeroViewController.self) { r, c in
            c.viewModel = r.resolve(MovieViewModel.self)
        }
        defaultContainer.storyboardInitCompleted(MovieDetailViewController.self) { r, c in
            c.viewModel = r.resolve(MovieViewModel.self)
        }
        defaultContainer.register(MovieViewModel.self) { _ in homeViewModel }
    }
}
