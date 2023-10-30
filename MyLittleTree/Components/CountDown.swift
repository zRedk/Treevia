//  CountDown.swift

import SwiftUI
import Combine  // Import Combine for Publishers and Subscribers

struct CountDown: View {
    @EnvironmentObject var gameData: GameEngine
    
    // Create a publisher that emits an output every second
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    // A state variable to trigger the view update
    @State private var lastUpdate = Date()
    
    var body: some View {
        let timeUntilNextPlayableMoment = gameData.timeUntilNextPlayableMoment()
        let hours = timeUntilNextPlayableMoment / 3600
        let minutes = (timeUntilNextPlayableMoment % 3600) / 60
        let seconds = timeUntilNextPlayableMoment % 60
        
        return Group {
            if timeUntilNextPlayableMoment > 0 {
                HStack(spacing: 5) {
                    Image(systemName: "drop.fill")
                    Text(String(format: "%02d:%02d:%02d", hours, minutes, seconds)).bold()
                    Text("remaining til next watering")
                }
                .foregroundColor(.timeDropMW)

            } else {
                HStack(spacing: 5) {
                    Image(systemName: "tree.fill")
                    Text("Learn more about biology!").bold()
                }
                .foregroundColor(.timeDropMW)
            }
        }
        .onReceive(timer) { _ in
            // Update the state variable every second to trigger a view update
            self.lastUpdate = Date()
        }
    }
}

#Preview {
    CountDown()
        .environmentObject(GameEngine()) // Provide a GameEngine instance here
}
