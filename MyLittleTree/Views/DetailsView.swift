//
//  DetailsView.swift
//  MyLittleTree
//
//  Created by Gustavo Isaac Lopez Nunez on 27/10/23.
//

import SwiftUI

struct DetailsView: View {
    @EnvironmentObject var gameData: GameEngine
    
    var body: some View {
        ZStack {
            Color.accentColor // Background color for the entire DetailsView
                .ignoresSafeArea()

            VStack {
                List {
                    Section(header: Text("Stats").bold()) {
                        HStack{
                            Text("Age:")
                            Spacer()
                            Text("\(gameData.daysSinceLastRegeneration) days")
                        }
                        HStack{
                            Text("Height:")
                            Spacer()
                            Text("\(gameData.plantSize) feet")
                        }
                        HStack{
                            Text("Health:")
                            Spacer()
                            Text("\(gameData.plantHealth)%")
                        }
                    }
                    .listRowBackground(Color.accentColor)
                    Section(header: Text("Rewards").bold()) {
                        HStack{
                            Image(systemName: "sun.horizon.fill")
                                .foregroundStyle(.yellow)
                            Text("Sunshine Ray:")
                            Spacer()
                            Text("3")
                        }
                        HStack{
                            Image(systemName: "camera.macro")
                                .foregroundStyle(.pink)
                            Text("Flower Blossom:")
                            Spacer()
                            Text("2")
                        }
                    }.listRowBackground(Color.accentColor)
                }
                .scrollContentBackground(.hidden)
            }
        }
        .presentationDetents([.medium])
        .presentationDragIndicator(.visible)
    }
}

#Preview {
    DetailsView()
        .environmentObject(GameEngine()) // Provide a GameEngine instance here
}
