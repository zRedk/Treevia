//
//  DataModels.swift
//  MyLittleTree
//
//  Created by Federica Mosca on 20/10/23.
//

import Foundation

class LeavesView: ObservableObject {
    @Published var leaves: [Leaf]
    @Published var lastRegenerationTime: Date

    init(leaves: [Leaf], lastRegenerationTime: Date) {
        self.leaves = leaves
        self.lastRegenerationTime = lastRegenerationTime
    }

    func regenerateLeavesIfNeeded() {
        let now = Date()
        let calendar = Calendar.current
        if calendar.dateComponents([.hour], from: lastRegenerationTime, to: now).minute ?? 0 >= 5 {
            // Regenerate the leaves (create a new array of leaves)
            let newLeaves = [Leaf(), Leaf(), Leaf()]
            self.leaves = newLeaves
            self.lastRegenerationTime = now
        }
    }
}

struct Leaf: Identifiable {
    var id = UUID()
    var show = true
}

struct Answer: Identifiable, Equatable {
    var id = UUID()
    var text: String
    var isCorrect: Bool = false
}

struct Question: Identifiable{
    var id = UUID()
    var text: String
    var Answers: [Answer]
}

struct GameStats{
    var correctAnswers: Int = 0
    var wrongAnswers: Int = 0
    
    mutating func incrementCorrectAnswer() {
        correctAnswers += 1
    }

    mutating func incrementWrongAnswer() {
        wrongAnswers += 1
    }
}
