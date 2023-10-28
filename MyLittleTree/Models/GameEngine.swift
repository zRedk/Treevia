//  GameEngine.swift

import Foundation
import UIKit

class GameEngine: ObservableObject {
    @Published var plantSize: Int
    @Published var plantHealth: Int
    @Published var correctAnswersCount: Int
    @Published var remainingAttempts: Int
    @Published var leaves: [Leaf]
    @Published var timeRemainingForTrivia: Int = 20
    @Published var timeRemainingForNextPlay: Int = 0
    @Published var win: Bool = false
    @Published var triviaActive: Bool = false

    var answersCount = 0
    private var timerTrivia: Timer?
    private var countdown: Timer?
    
    var lastRegenerationTime: Date {
        get {
            if let storedDate = UserDefaults.standard.object(forKey: "lastRegenerationTime") as? Date {
                return storedDate
            }
            
            // If it's the first time the app is running, set the time.
            let firstLaunchDate = Date()
            UserDefaults.standard.set(firstLaunchDate, forKey: "lastRegenerationTime")
            return firstLaunchDate
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "lastRegenerationTime")
        }
    }

    //Var to check if player has played more than once for today
    var lastPlayedDate: Date? {
        get {
            UserDefaults.standard.object(forKey: "lastPlayedDate") as? Date
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "lastPlayedDate")
        }
    }
    
    var daysSinceLastRegeneration: Int {
        let now = Date()
        let calendar = Calendar.current
        let components = calendar.dateComponents([.day], from: lastRegenerationTime, to: now)
        return components.day ?? 0
    }
    
    init() {
        plantSize = UserDefaults.standard.integer(forKey: "plantSize")
        plantHealth = UserDefaults.standard.integer(forKey: "plantHealth")
        correctAnswersCount = 0
        remainingAttempts = 3
        leaves = [Leaf(show: true), Leaf(show: true), Leaf(show: true)]
        triviaActive = true
        if UserDefaults.standard.object(forKey: "plantSize") == nil {
            plantSize = 0 // Set your default value here
            UserDefaults.standard.set(plantSize, forKey: "plantSize")
        } else {
            plantSize = UserDefaults.standard.integer(forKey: "plantSize")
        }

        if UserDefaults.standard.object(forKey: "plantHealth") == nil {
            plantHealth = 100 // Set your default value here
            UserDefaults.standard.set(plantHealth, forKey: "plantHealth")
        } else {
            plantHealth = UserDefaults.standard.integer(forKey: "plantHealth")
        }

        NotificationCenter.default.addObserver(self, selector: #selector(applicationWillEnterForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
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
        win = false
        triviaActive = true
        resetTimer()
        
        // Reset leaves to their initial state
        leaves = [Leaf(show: true), Leaf(show: true), Leaf(show: true)]
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

    func startTimer() {
        // Invalidate any previous timer
        timerTrivia?.invalidate()
        
        timerTrivia = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            if self.timeRemainingForTrivia > 0 {
                self.timeRemainingForTrivia -= 1
            } else {
                self.timerTrivia?.invalidate()
                // Logic to be executed when timer reaches 0, if any
            }
        }
    }

    func startCountdown() {
        // Invalidate any previous timer
        countdown?.invalidate()
        
        // Start a new timer that ticks every second
        countdown = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            let timeUntilPlayable = self.timeUntilNextPlayableMoment()
            
            if timeUntilPlayable > 0 {
                self.timeRemainingForNextPlay = timeUntilPlayable - 1
            } else {
                self.countdown?.invalidate()
                self.timeRemainingForNextPlay = 0
            }
        }
    }

    func stopTimer() {
        timerTrivia?.invalidate()
    }

    func resetTimer() {
        timeRemainingForTrivia = 20 // Reset to the initial value
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
            loseLeaf()
            if remainingAttempts < 0 {
                resetPlant()
                return
            }
        }

        // Continue with your existing logic for correct answers and checking for game completion
        if answersCount == 5 && remainingAttempts > 0 {
            triviaActive = false
            win = true
            if plantHealth == 100 {
                plantSize += 50
                savePlantData()
            } else if plantHealth == 50 {
                plantHealth += 50
                savePlantData()
            }
        } else if answersCount == 5 && remainingAttempts <= 0 {
            triviaActive = false
            win = false

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
