//
//  GameStats.swift
//  MyLittleTree
//
//  Created by Federica Mosca on 19/10/23.
//

import Foundation

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
