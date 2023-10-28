//  DeathPlant.swift

import SwiftUI

struct DeathPlant: View {
    @EnvironmentObject var gameData: GameEngine
    
    var body: some View {
        
        VStack {
            Text("Oh no! Your plant has died.")
                .padding()
                .bold()
            Image("DeathPlant")
                .resizable()
                .aspectRatio(contentMode:.fit)
                .frame(width: 200)
                .padding(.bottom, 20.0)
            Button("Start again") {
                // Logic to restart the game
                gameData.resetPlant()  // This function needs to be implemented in GameEngine
            }
            .padding(25.0)
            .background(.greenButton)
            .foregroundColor(.white)
            .cornerRadius(230)
        }
    }
}

#Preview {
    DeathPlant()
        .environmentObject(GameEngine())
}
