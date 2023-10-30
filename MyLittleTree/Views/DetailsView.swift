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
            Color("backgroundColor")
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
                    .listRowBackground(Color("backgroundColor"))
                    Section(header: Text("Power-Ups").bold()) {
                        HStack{
                            Image(systemName: "sun.horizon.fill")
                                .foregroundStyle(.yellow)
                            Text("Sunshine:")
                            Spacer()
                            Text("\(gameData.sunRay)")
                        }
                        HStack{
                            Image(systemName: "camera.macro")
                                .foregroundStyle(.pink)
                            Text("Blossom:")
                            Spacer()
                            Text("\(gameData.flowerBloom)")
                        }
                    }.listRowBackground(Color("backgroundColor"))
                }
                .scrollContentBackground(.hidden)
            }
        }
        .environment(\.colorScheme, .light)
        .presentationDetents([.medium])
        .presentationDragIndicator(.visible)
    }
}

#Preview {
    DetailsView()
        .environmentObject(GameEngine()) 
}
