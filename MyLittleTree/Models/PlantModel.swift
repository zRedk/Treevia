//
//  PlantModel.swift
//  MyLittleTree
//
//  Created by Federica Mosca on 25/10/23.
//

import Foundation

class GameEngine: ObservableObject {
    @Published var plantSize: Int
    @Published var plantHealth: Int
    @Published var correctAnswersCount: Int
    @Published var remainingAttempts: Int
    @Published var leaves: [Leaf]
    @Published var lastRegenerationTime: Date
    var answersCount = 0
    
    init() {
        plantSize = 0
        plantHealth = 100
        correctAnswersCount = 0
        remainingAttempts = 3
        lastRegenerationTime = Date()
        leaves = [Leaf(show: true), Leaf(show: true), Leaf(show: true)]
        
        UserDefaults.standard.set(plantSize, forKey: "plantSize")
        UserDefaults.standard.set(plantHealth, forKey: "plantHealth")
    }
    
    func answerQuestion(isCorrect: Bool) {
        answersCount += 1
        if isCorrect {
            correctAnswersCount += 1
        } else {
            remainingAttempts -= 1
            if remainingAttempts < 0 {
                // Handle game over logic here
                resetPlant()
                return
            }
            // Hide a leaf for wrong answers
            if let firstVisibleLeafIndex = leaves.firstIndex(where: { $0.show }) {
                leaves[firstVisibleLeafIndex].show = false
            }
        }

        // Continue with your existing logic for correct answers and checking for game completion
        if answersCount == 5 && remainingAttempts > 0 {
            if plantHealth == 100 {
                plantSize += 50
                savePlantData()
            } else if plantHealth == 50 {
                plantHealth += 50
                savePlantData()
            }
        } else if answersCount == 5 && remainingAttempts < 0 {
            plantHealth -= 50
            savePlantData()
            if plantHealth <= 0 {
                resetPlant()
            }
        }
    }
    
    func resetPlant() {
        plantSize = 0
        plantHealth = 100
        savePlantData()
    }
    func savePlantData() {
        UserDefaults.standard.set(plantSize, forKey: "plantSize")
        UserDefaults.standard.set(plantHealth, forKey: "plantHealth")
        print(plantSize, plantHealth)
    }
    
    // Function to regenerate leaves if needed
    func regenerateLeavesIfNeeded() {
        let now = Date()
        let calendar = Calendar.current
        if calendar.dateComponents([.minute], from: lastRegenerationTime, to: now).minute ?? 0 >= 5 {
            // Regenerate the leaves (create a new array of leaves)
            leaves = [Leaf(show: true), Leaf(show: true), Leaf(show: true)]
            lastRegenerationTime = now
        }
    }

    // Function to check if all leaves are hidden
    func allLeavesHidden() -> Bool {
        return leaves.allSatisfy { !$0.show }
    }

    
}
