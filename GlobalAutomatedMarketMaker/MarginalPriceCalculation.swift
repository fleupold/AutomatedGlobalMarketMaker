//
//  MarginalPriceCalculation.swift
//  GlobalAutomatedMarketMaker
//
//  Created by Felix Leupold on 27.12.18.
//

import Foundation

enum LMSRConstants {
    static let b = 10.0
}

func marginalPrice(outcome: OutcomeCount) -> Double {
    let numerator = outcome.pro.reduce(0) { $0 + pow(M_E, Double($1.value)/LMSRConstants.b) }
    let denominator = outcome.contra.reduce(0) { $0 + pow(M_E, Double($1.value)/LMSRConstants.b) }
    return numerator / (numerator + denominator)
}
