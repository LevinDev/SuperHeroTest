//
//  SuperHeroShowCaseTests.swift
//  SuperHeroShowCaseTests
//
//  Created by Levin Varghese on 09/06/2023.
//

import XCTest
import RxSwift
import RxCocoa
import Moya

@testable import SuperHeroShowCase

final class SuperHeroShowCaseTests: XCTestCase {
    let bag = DisposeBag()
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }
    
    func test_whenMockDataPassed_shouldReturnProperResponse() {
        //given
        let provider = MoyaProvider<API>(
            endpointClosure: endPointMyOrganizationClousre,
            plugins: [authMyOrganizationPlugin, NetworkLoggerPlugin(configuration: .init(logOptions: .verbose))])
        let networkManager = NetworkManagerMock(provider: provider)
        var completionCallsCount = 0
       
        //when
        let item: Observable<SuperHeroMovieResponse> = networkManager.request(target: .getSuperHeroMovies(page: "1"))
        item.subscribe { movie in
            completionCallsCount += 1
            XCTAssertNotNil(movie)
            
        }.disposed(by: bag)
        
        //then
        XCTAssertNotEqual(0, completionCallsCount)
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
