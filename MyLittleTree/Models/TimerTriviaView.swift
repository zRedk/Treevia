//
//  TimerTriviaView.swift
//  MyLittleTree
//
//  Created by Emanuele Di Pietro on 24/10/23.
//

import SwiftUI

class TimerTriviaView: ObservableObject {
    
    static let shared = TimerTriviaView()
    
    @Published var timeRemaining: Int = 20

    private var timer: Timer?

    func startCountdown() {
        //timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            self.timeRemaining -= 1
            if self.timeRemaining <= 0 {
                self.timer?.invalidate()
            }
        }
    }
    
    func stopAndReset() {
            timer?.invalidate()
            timeRemaining = 20 // Reset to the initial value
    }
}


