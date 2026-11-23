import Foundation

struct Question: Codable, Identifiable {
    let id = UUID()
    let question: String
    let A: String
    let B: String
    let C: String
    let D: String
    let answer: String

    enum CodingKeys: String, CodingKey {
        case question, A, B, C, D, answer
    }

    var choices: [(String, String)] {
        [("A", A), ("B", B), ("C", C), ("D", D)]
    }
}
