//
//  OutcomeCounting.swift
//  GlobalAutomatedMarketMaker
//
//  Created by Felix Leupold on 27.12.18.
//

import Foundation

/**
 * E.g. for an outcome combination [true, variable], `pro` would contain keys "11", "10"
 * and `contra` would contain "00", "00".
 */
struct OutcomeCount {
    var pro: [String: Int] = [:]
    var contra: [String: Int] = [:]
    
    init() {}
    init(pro: [String: Int], contra: [String: Int]) {
        self.pro = pro
        self.contra = contra
    }
    init(_ conciseOutcome: ConciseOutcomeCount) {
        pro = ["win": conciseOutcome.pro]
        contra = conciseOutcome.contra
    }
}

/**
 * For a binary event the outcome can be true, false, or either (Variable)
 */
enum Outcome {
    case Fixed(Bool)
    case Variable
}

protocol OutcomeCounting {
    /**
     * Returns the outcome distribution for the given combination in the current state.
     */
    func outcomeCount(combination: [Outcome]) -> OutcomeCount
    
    /**
     * Applies the purchase of the given combination and amount to the current state.
     */
    func buy(combination: [Outcome], amount: Int) -> Void
}

/**
 * E.g. for an outcome combination [true, false, variable], `pro` would contain the sum of "101" and "100".
 * `contra` would contain "11" (sum of "110", "111"), "00" (sum of "000", "001") and "01" (sum of "010", "011").
 */
struct ConciseOutcomeCount {
    var pro = 0
    var contra: [String: Int] = [:]
}

protocol ConciseOutcomeCounting {
    func conciseOutcomeCount(combination: [Outcome]) -> ConciseOutcomeCount
}
