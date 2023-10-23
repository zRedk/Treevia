//
//  TimerViewModal.swift
//  MyLittleTree
//
//  Created by Emanuele Di Pietro on 23/10/23.
//

import SwiftUI

class TimerViewModel: ObservableObject {
    @Published var remainingTime: TimeInterval = 0
    var timer: Timer?

    func startTimer() {
        self.remainingTime = 8 * 3600 // 8 hours in seconds
        self.timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            if self.remainingTime > 0 {
                self.remainingTime -= 1
            }
        }
    }

    func stopTimer() {
        self.timer?.invalidate()
        self.timer = nil
    }
}

