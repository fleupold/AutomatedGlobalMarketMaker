//
//  MarginalPriceCalculationTest.swift
//  GlobalAutomatedMarketMakerUnitTest
//
//  Created by Felix Leupold on 27.12.18.
//

import XCTest

class MarginalPriceCalculationTest: XCTestCase {
    
    func testSimple() {
        // Example from http://augur.strikingly.com/blog/what-is-an-automated-market-maker
        var outcome = OutcomeCount(pro: ["1": 5], contra:["0": 3])
        XCTAssertLessThan(fabs(marginalPrice(outcome: outcome) - 0.55), 0.01)
        
        outcome = OutcomeCount(pro: ["1": 6], contra:["0": 3])
        XCTAssertLessThan(fabs(marginalPrice(outcome: outcome) - 0.574), 0.01)
    }
    
    func testConciseVsNonConciseOutcomeCount() {
        let priceCalculator = NaiveOutcomeCounter();
        let combinationA = [Outcome.Fixed(false), Outcome.Fixed(true), Outcome.Variable, Outcome.Variable]
        let combinationB = [Outcome.Fixed(false), Outcome.Variable, Outcome.Fixed(true), Outcome.Variable]
        
        priceCalculator.buy(combination: combinationA, amount: 10);
        
        let outcome = priceCalculator.outcomeCount(combination: combinationB)
        let conciseOutcome = priceCalculator.conciseOutcomeCount(combination: combinationB)
        
        XCTAssertNotEqual(marginalPrice(outcome: outcome), marginalPrice(outcome: OutcomeCount(conciseOutcome)))
    }

}
