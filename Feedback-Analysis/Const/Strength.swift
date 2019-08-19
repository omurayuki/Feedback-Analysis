import Foundation

enum Strength: String, CaseIterable {
    case kyouka = "強化系"
    case henka = "変化形"
    case sousa = "操作系"
    case gugen = "具現化系"
    case tokusitu = "特質系"
}

extension Strength {
    static var residences: [String] {
        return allCases.compactMap { $0.rawValue }
    }
}
