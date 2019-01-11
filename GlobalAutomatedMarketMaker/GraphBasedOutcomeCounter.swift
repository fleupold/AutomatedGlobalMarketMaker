//
//  GraphBasedOutcomeCounter.swift
//  GlobalAutomatedMarketMaker
//
//  Created by Felix Leupold on 28.12.18.
//

import Foundation

class Node: Hashable {
    static func == (lhs: Node, rhs: Node) -> Bool {
        return lhs.combination == rhs.combination
    }
    
    var purchased = 0
    var touched = 0
    var combination: [Outcome]
    var children: Set<Node> = []
    
    init (combination: [Outcome]) {
        self.combination = combination
    }
    
    var hashValue: Int {
        return combination.toString().hashValue
    }
    
    func buy(amount: Int, nodes: inout [String: Node]) {
        self.purchased += amount
        for parentCombination in self.combination.parentCombinations() {
            let parent = nodes[parentCombination.toString(), default: Node(combination: parentCombination)]
            parent.children.insert(self)
            parent.buy(amount: amount, nodes: &nodes)
            nodes[parentCombination.toString()] = parent
        }
    }
    
    func outcomeDistribution(combination: [Outcome], timestamp: Int) -> (ConciseOutcomeCount) {
        var result = ConciseOutcomeCount()
        var uncoveredProOutcomes = purchased
        
        let variableDelta = self.combination.variableElements() - combination.variableElements()
        if variableDelta > 0 {
            // We need to look at the children, since some variables in this layer might not match the given combination
            for node in self.children {
                assert(node.touched <= timestamp)
                uncoveredProOutcomes -= node.purchased
                if !node.match(combination: combination) {
                    result.contra += node.purchased //This is a contra outcome
                } else if node.touched < timestamp {
                    var nodeResult = node.outcomeDistribution(combination: combination, timestamp: timestamp)
                    if node.combination != combination {
                        nodeResult = nodeResult / 2;
                    }
                    result = result + nodeResult
                }
            }
        }
        let scalingFactor = Int(pow(Double(2), Double(variableDelta)))
        result.pro += uncoveredProOutcomes / scalingFactor;
        result.contra += uncoveredProOutcomes - (uncoveredProOutcomes / scalingFactor);
        self.touched = timestamp
        return result
    }
    
    /**
     * Returns true if this nodes combination is a subset of the given one. // TODO rephrase this
     */
    func match(combination: [Outcome]) -> Bool {
        for (thisOutcome, otherOutcome) in zip(self.combination, combination) {
            switch thisOutcome {
            case .Fixed(let thisValue):
                switch otherOutcome {
                case .Fixed(let otherValue):
                    if thisValue != otherValue {
                        return false // true doesn't match false & vice versa
                    }
                case .Variable:
                    continue; // x matches true/false
                }
            case .Variable:
                continue; // x matches true/false
            }
        }
        return true
    }
}

class GraphBasedOutcomeCounter: ConciseOutcomeCounting {
    var nodes: [String: Node] = [:]
    var timestamp = 0
    var totalBought = 0
    
    func conciseOutcomeCount(combination: [Outcome]) -> ConciseOutcomeCount {
        self.timestamp += 1
        
        var result = ConciseOutcomeCount();
        for (index, outcome) in combination.enumerated() {
            switch outcome {
            case .Fixed:
                var entryCombination = Array(repeating: Outcome.Variable, count: combination.count)
                entryCombination[index] = outcome
                if let node = nodes[entryCombination.toString()] {
                    result = result + node.outcomeDistribution(combination: combination, timestamp: timestamp)
                }
            case .Variable:
                continue
            }
        }
        result.pro /= Int(exp2(Double(combination.count-1)))
        result.contra = self.totalBought - result.pro
        return result
    }
    
    func buy(combination: [Outcome], amount: Int) {
        let scalingFactor = Int(pow(Double(2), Double(combination.variableElements())))
        let node = nodes[combination.toString(), default: Node(combination: combination)]
        node.buy(amount: amount*scalingFactor, nodes: &self.nodes)
        nodes[combination.toString()] = node
        totalBought += amount
    }
}
