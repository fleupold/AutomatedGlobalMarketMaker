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
        contra = ["win": conciseOutcome.contra]
    }
}

/**
 * For a binary event the outcome can be true, false, or either (Variable)
 */
enum Outcome: Equatable {
    case Fixed(Bool)
    case Variable
}

protocol OutcomeCounting {
    /**
     * Returns the outcome distribution for the given combination in the current state.
     */
    func outcomeCount(combination: [Outcome]) -> OutcomeCount
}

/**
 * E.g. for an outcome combination [true, false, variable], `pro` would contain the sum of "101" and "100".
 * `contra` would contain "11" (sum of "110", "111"), "00" (sum of "000", "001") and "01" (sum of "010", "011").
 */
struct ConciseOutcomeCount {
    static func +(lhs: ConciseOutcomeCount, rhs: ConciseOutcomeCount) -> ConciseOutcomeCount {
        return ConciseOutcomeCount(pro: lhs.pro+rhs.pro, contra: lhs.contra+rhs.contra)
    }
    
    static func /(lhs: ConciseOutcomeCount, rhs: Int) -> ConciseOutcomeCount {
        return ConciseOutcomeCount(pro: lhs.pro/rhs, contra: lhs.contra/rhs)
    }
    
    var pro = 0
    var contra = 0
}

protocol ConciseOutcomeCounting {
    /**
     * Returns the outcome distribution for the given combination in the current state.
     */
    func conciseOutcomeCount(combination: [Outcome]) -> ConciseOutcomeCount
    
    /**
     * Applies the purchase of the given combination and amount to the current state.
     */
    func buy(combination: [Outcome], amount: Int) -> Void
}
