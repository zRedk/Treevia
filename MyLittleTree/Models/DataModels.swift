//
//  DataModels.swift
//  MyLittleTree
//
//  Created by Federica Mosca on 20/10/23.
//

import Foundation

class LifeLeaf {
    var Leaves: [Leaf] = [
        Leaf(),
        Leaf(),
        Leaf()
    ]
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
