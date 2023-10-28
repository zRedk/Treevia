//  GameResultView.swift

import SwiftUI

struct GameResultView: View {
    @EnvironmentObject var gameData: GameEngine
    
    var body: some View {
        if gameData.win {
            Hooray()
        } else {
            Oops()
        }
    }
}

#Preview {
    GameResultView()
        .environmentObject(GameEngine())
}
