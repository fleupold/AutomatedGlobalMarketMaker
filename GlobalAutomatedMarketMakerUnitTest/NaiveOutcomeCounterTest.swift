//
//  NaiveOutcomeCounterTest.swift
//  GlobalAutomatedMarketMaker
//
//  Created by Felix Leupold on 27.12.18.
//

import XCTest

class NaiveOutcomeCounterTest: XCTestCase {

    func testOutcomeCount() {
        let priceCalculator = NaiveOutcomeCounter();
        
        let combinationA = [Outcome.Fixed(false), Outcome.Fixed(true), Outcome.Variable, Outcome.Variable]
        var result = priceCalculator.outcomeCount(combination: combinationA)
        XCTAssert(Array(result.pro.values) == Array(repeating: 0, count: 4) )
        XCTAssert(Array(result.contra.values) == Array(repeating: 0, count: 12) )
        
        priceCalculator.buy(combination: combinationA, amount: 10)
        result = priceCalculator.outcomeCount(combination: combinationA)
        XCTAssert(Array(result.pro.values) == Array(repeating: 10, count: 4) )
        XCTAssert(Array(result.contra.values) == Array(repeating: 0, count: 12) )
        
        let combinationB = [Outcome.Fixed(false), Outcome.Variable, Outcome.Fixed(true), Outcome.Variable]
        result = priceCalculator.outcomeCount(combination: combinationB)
        XCTAssert(Array(result.pro.values).sorted() == [0, 0, 10, 10] )
        XCTAssert(Array(result.contra.values).sorted() == (Array(repeating: 0, count: 10) + [10, 10]) )
        
        priceCalculator.buy(combination: combinationB, amount: 5)
        result = priceCalculator.outcomeCount(combination: combinationB)
        XCTAssert(Array(result.pro.values).sorted() == [5, 5, 15, 15] )
        XCTAssert(Array(result.contra.values).sorted() == (Array(repeating: 0, count: 10) + [10, 10]) )
    }
    
    func testConciseOutcomeCount() {
        let priceCalculator = NaiveOutcomeCounter();
        
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

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
