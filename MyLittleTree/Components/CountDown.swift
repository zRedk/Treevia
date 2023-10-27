//
//  SwiftUIView.swift
//  MyLittleTree
//
//  Created by Emanuele Di Pietro on 23/10/23.
//

import SwiftUI

struct CountDown: View {
    @EnvironmentObject var gameData: GameEngine
    
    var body: some View {
        let timeRemaining = gameData.timeUntilNextPlayableMoment()
        let hours = timeRemaining / 3600
        let minutes = (timeRemaining % 3600) / 60
        let seconds = timeRemaining % 60
        
        return Group {
            if timeRemaining > 0 {
                HStack(spacing: 5) {
                    Image(systemName: "drop.fill")
                    Text(String(format: "%02d:%02d:%02d", hours, minutes, seconds)).bold()
                    Text("remaining til next watering")
                }
            } else {
                HStack(spacing: 5) {
                    Image(systemName: "tree.fill")
                    Text("Learn more about plants!").bold()
                }
            }
        }
    }
}
