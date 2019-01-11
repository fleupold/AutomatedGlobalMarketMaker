//
//  GraphBasedOutcomeCounterTest.swift
//  GlobalAutomatedMarketMakerUnitTest
//
//  Created by Felix Leupold on 28.12.18.
//

import XCTest

class GraphBasedOutcomeCounterTest: XCTestCase {

    func testFourEvents() {
        let priceCalculator = GraphBasedOutcomeCounter();
        
        let combinationA = [Outcome.Fixed(false), Outcome.Fixed(true), Outcome.Variable, Outcome.Variable]
        var result = priceCalculator.conciseOutcomeCount(combination: combinationA)
        XCTAssert(result.pro == 0)
        XCTAssert(result.contra == 0)
        
        priceCalculator.buy(combination: combinationA, amount: 10)
        result = priceCalculator.conciseOutcomeCount(combination: combinationA)
        XCTAssert(result.pro == 10 )
        XCTAssert(result.contra == 0)
        
        let combinationB = [Outcome.Fixed(false), Outcome.Variable, Outcome.Fixed(true), Outcome.Variable]
        result = priceCalculator.conciseOutcomeCount(combination: combinationB)
        XCTAssert(result.pro == 5 )
        XCTAssert(result.contra == 5)
        
        priceCalculator.buy(combination: combinationB, amount: 5)
        result = priceCalculator.conciseOutcomeCount(combination: combinationB)
        XCTAssert(result.pro == 10 )
        XCTAssert(result.contra == 5)
    }
    
    func testThreeEvents() {
        let priceCalculator = GraphBasedOutcomeCounter();
        
        let combinationA = [Outcome.Fixed(true), Outcome.Variable, Outcome.Variable]
        priceCalculator.buy(combination: combinationA, amount: 10)

        let combinationB = [Outcome.Fixed(true), Outcome.Fixed(false), Outcome.Variable]
        var result = priceCalculator.conciseOutcomeCount(combination: combinationB)
        XCTAssert(result.pro == 5 )
        XCTAssert(result.contra == 5)
        priceCalculator.buy(combination: combinationB, amount: 5)
        
        let combinationC = [Outcome.Fixed(true), Outcome.Fixed(true), Outcome.Variable]
        result = priceCalculator.conciseOutcomeCount(combination: combinationC)
        XCTAssert(result.pro == 5)
        XCTAssert(result.contra == 10)
        priceCalculator.buy(combination: combinationC, amount: 3)
        
        let combinationD = [Outcome.Fixed(true), Outcome.Fixed(true), Outcome.Fixed(true)]
        result = priceCalculator.conciseOutcomeCount(combination: combinationD)
        XCTAssert(result.pro == 8)
        XCTAssert(result.contra == 10)
    }

}
