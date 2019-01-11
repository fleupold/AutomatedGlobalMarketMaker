import Foundation

extension Array where Element == Outcome {
    func variableElements() -> Int {
        return self.filter {
            switch($0) {
            case .Fixed:
                return false
            case .Variable:
                return true
            }}.count
    }
    
    func toString() -> String {
        return String(self.map {
            switch $0 {
            case .Fixed(let value):
                return value ? "1" : "0"
            case .Variable:
                return "x"
            }
        })
    }
    
    func parentCombinations() -> [[Outcome]] {
        if self.variableElements() >= self.count - 1 {
            return []; // If there is only one non-variable element left, we have no parents
        }
        return self.enumerated().compactMap({ (arg0) -> [Outcome]? in
            let (offset, element) = arg0
            switch element {
            case .Fixed:
                var copy = self
                copy[offset] = Outcome.Variable
                return copy
            case .Variable:
                return nil
            }
        })
    }
}
