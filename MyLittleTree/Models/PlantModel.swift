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
    @Published var quizCompleted: Bool
    
    init() {
           plantSize = 0
           plantHealth = 100
           correctAnswersCount = 0
           remainingAttempts = 3
           quizCompleted = false
           plantSize = UserDefaults.standard.integer(forKey: "plantSize")
           plantHealth = UserDefaults.standard.integer(forKey: "plantHealth")
       }

    func answerQuestion(isCorrect: Bool) {
        if isCorrect == true {
            correctAnswersCount += 1
        } else if isCorrect == false{
            remainingAttempts -= 1
        }
        
        if correctAnswersCount == 5 || remainingAttempts > 0 {
            if plantHealth == 100 {
                plantSize += 50
                savePlantData()
            }else if plantHealth == 50 {
                plantHealth += 50
                savePlantData()
            }
        }
        else if remainingAttempts < 0 {
             plantHealth -= 50
            savePlantData()
            if plantHealth <= 0{
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
        }
        
    }
