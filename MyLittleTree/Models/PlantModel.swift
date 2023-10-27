//
//  PlantModel.swift
//  MyLittleTree
//
//  Created by Federica Mosca on 25/10/23.
//

import Foundation
import UIKit

class GameEngine: ObservableObject {
    @Published var plantSize: Int
    @Published var plantHealth: Int
    @Published var correctAnswersCount: Int
    @Published var remainingAttempts: Int
    @Published var leaves: [Leaf]
    @Published var lastRegenerationTime: Date
    @Published var timeRemaining: Int = 20
    var answersCount = 0
    private var timer: Timer?
    static let shared = GameEngine()
    
    //Var to check if player has played more than once for today
    var lastPlayedDate: Date? {
        get {
            UserDefaults.standard.object(forKey: "lastPlayedDate") as? Date
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "lastPlayedDate")
        }
    }
    
    init() {
        plantSize = 0
        plantHealth = 100
        correctAnswersCount = 0
        remainingAttempts = 3
        lastRegenerationTime = Date()
        leaves = [Leaf(show: true), Leaf(show: true), Leaf(show: true)]
        
        UserDefaults.standard.set(plantSize, forKey: "plantSize")
        UserDefaults.standard.set(plantHealth, forKey: "plantHealth")
        
        NotificationCenter.default.addObserver(self, selector: #selector(applicationWillEnterForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
        lastPlayedDate = nil
    }
    
    @objc func applicationWillEnterForeground() {
        startCountdown()
    }

    func timeUntilNextPlayableMoment() -> Int {
        // If the user hasn't played before, they can play immediately.
        if lastPlayedDate == nil {
            return 0  // Can play immediately
        }

        if let lastDate = lastPlayedDate, Calendar.current.isDateInToday(lastDate) {
            let startOfNextDay = Calendar.current.startOfDay(for: Date()).addingTimeInterval(24*3600)
            return Int(startOfNextDay.timeIntervalSince(Date()))
        } else {
            return 0
        }
    }

    func startGame() {
        // Reset all game-related variables
        plantSize = UserDefaults.standard.integer(forKey: "plantSize")
        plantHealth = UserDefaults.standard.integer(forKey: "plantHealth")
        correctAnswersCount = 0
        remainingAttempts = 3
        answersCount = 0
        timeRemaining = 20
        
        // Set the last played date to today
        lastPlayedDate = Date()

        // Reset leaves to their initial state
        leaves = [Leaf(show: true), Leaf(show: true), Leaf(show: true)]
        
        // Start the countdown
        startCountdown()
    }

    // Check if the user can play today
    func canPlayToday() -> Bool {
        // If there's no recorded play date, they can play today.
        if lastPlayedDate == nil {
            return true
        }

        // Check if the last played date is not today.
        return !Calendar.current.isDateInToday(lastPlayedDate!)
    }

    func startCountdown() {
        // Invalidate any previous timer
        timer?.invalidate()
        
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            self.timeRemaining -= 1
            if self.timeRemaining <= 0 {
                self.timer?.invalidate()
            }
        }
    }

    func stopTimer() {
        timer?.invalidate()
    }

    func resetTimer() {
        timeRemaining = 20 // Reset to the initial value
    }
    
    func stopAndReset() {
        stopTimer()
        resetTimer()
    }

    func loseLeaf(){
        // Hide a leaf for wrong answers
        if let firstVisibleLeafIndex = leaves.firstIndex(where: { $0.show }) {
            leaves[firstVisibleLeafIndex].show = false
        }
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
            loseLeaf()
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
        } else if answersCount == 5 && remainingAttempts <= 0 {
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
