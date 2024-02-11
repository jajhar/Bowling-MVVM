//
//  CoordinatorTests.swift
//  BowlingGameTests
//
//  Created by Julia Ajhar on 2/9/24.
//

import Foundation
import XCTest
@testable import BowlingGame
import SwiftUI

final class CoordinatorTests: XCTestCase {
    func makeSUT(
        pathHandler: CoordinatorPathHandlerProtocol
    ) -> Coordinator {
        Coordinator(pathHandler: pathHandler)
    }
    
    func test_push_callCountIncreases() {
        let pathHandler = MockDataFactory.makeMockCoordinatorPathHandler()
        let sut = makeSUT(pathHandler: pathHandler)
        
        sut.push(.game)
        XCTAssertEqual(pathHandler.pushCallCount, 1)
    }
    
    func test_pop_callCountIncreases() {
        let pathHandler = MockDataFactory.makeMockCoordinatorPathHandler()
        let sut = makeSUT(pathHandler: pathHandler)
        
        sut.pop()
        XCTAssertEqual(pathHandler.popCallCount, 1)
    }
    
    func test_popToRoot_callCountIncreases() {
        let pathHandler = MockDataFactory.makeMockCoordinatorPathHandler()
        let sut = makeSUT(pathHandler: pathHandler)
        
        sut.popToRoot()
        XCTAssertEqual(pathHandler.popToRootCallCount, 1)
    }
}
