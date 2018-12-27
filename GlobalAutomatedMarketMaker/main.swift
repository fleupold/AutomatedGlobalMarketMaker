//
//  main.swift
//  GlobalAutomatedMarketMaker
//
//  Created by Felix Leupold on 27.12.18.
//

import Foundation

let priceCalculator = NaiveOutcomeCounter();

let combinationA = [Outcome.Fixed(false), Outcome.Fixed(true), Outcome.Variable, Outcome.Variable]
var result = priceCalculator.outcomeCount(combination: combinationA)

print(marginalPrice(outcome: result))

print("Done")
