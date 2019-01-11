import Foundation

class NaiveOutcomeCounter: OutcomeCounting, ConciseOutcomeCounting {
    var counts: [String: Int] = [:]
    
    func outcomeCount(combination: [Outcome]) -> OutcomeCount {
        var proVector = [""];
        var contraVector: [String] = [];
        for option in combination {
            switch option {
            case Outcome.Fixed(let outcome):
                // All previous contra combinations concatenated with either outcome + all previous pro combinations concatenated with the losing outcome
                contraVector = contraVector.map { $0 + "0" } + contraVector.map { $0 + "1" } + proVector.map { $0 + (outcome ? "0" : "1")}
                // All previous pro combinations concatenated with the winning outcome
                proVector = proVector.map { $0 + (outcome ? "1" : "0") }
            case Outcome.Variable:
                // All previous pro combinations concatenated with either outcome
                proVector = proVector.map { $0 + "1" } + proVector.map { $0 + "0" }
                // All previous contra combinations concatenated with either outcome
                contraVector = contraVector.map { $0 + "1" } + contraVector.map { $0 + "0" }
            }
        }
        var result = OutcomeCount()
        proVector.forEach { result.pro[$0] = counts[$0, default: 0] }
        contraVector.forEach{ result.contra[$0] = counts[$0, default: 0] }
        return result
    }
    
    func buy(combination: [Outcome], amount: Int) -> Void {
        var buyVector = [""];
        for option in combination {
            switch option {
            case Outcome.Fixed(let outcome):
                // Buy the correct outcome
                buyVector = buyVector.map { $0 + (outcome ? "1" : "0") }
            case Outcome.Variable:
                // Buy either outcome
                buyVector = buyVector.map { $0 + "1" } + buyVector.map { $0 + "0" }
            }
        }
        for buy in buyVector {
            counts[buy] = counts[buy, default:0] + amount
        }
    }
    
    func conciseOutcomeCount(combination: [Outcome]) -> ConciseOutcomeCount {
        let outcomeCount = self.outcomeCount(combination: combination);
        let scalingFactor = outcomeCount.pro.count;
        var result = ConciseOutcomeCount();
        result.pro = outcomeCount.pro.map{$1}.reduce(0, +) / scalingFactor
        result.contra = outcomeCount.contra.map{$1}.reduce(0, +) / scalingFactor
        return result;
    }
}
