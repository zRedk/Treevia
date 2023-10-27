//  ContentView.swift

import SwiftUI
import Combine

struct ContentView: View {
    
    @State private var showTriviaModal: Bool = false
    @State private var showDetailsModal: Bool = false
    @EnvironmentObject var gameData: GameEngine
    @State private var showAlert: Bool = false

    init () {
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor.init(Color.black)]
    }
    
    func getPlantImage() -> String {
        if  gameData.plantSize == 0 {
            return (gameData.plantHealth == 100) ? "Bud" : "SickBud"
        } else if gameData.plantSize == 50 {
            return (gameData.plantHealth == 100) ? "Spruce" : "SickSpruce"
        } else if gameData.plantSize == 100 {
            return (gameData.plantHealth == 100) ? "Tree" : "SickTree"
        } else {
            return "placeholder"
        }
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.accentColor
                    .ignoresSafeArea()
                
                VStack{
                    HStack{
                        CountDown()
                            .foregroundColor(.timeDropMW) //here timeDropMW is the color for the text with the tear drop
                    }
                    Button(action: {
                        self.showDetailsModal = true
                    }) {
                        Image(getPlantImage())
                            .resizable()
                            .aspectRatio(contentMode:.fit)
                            .frame(width: 200)
                            .padding(.bottom, 20.0)
                    }

                    
                    Button("Water your plant!") {
                        if gameData.canPlayToday() {
                            // If the user can play today, then present the trivia view.
                            self.showTriviaModal = true
                            gameData.startGame()
                        } else {
                            // If not, show the alert.
                            showAlert = true
                        }
                    }
                    .padding(25.0)
                    .background(.greenButton)
                    .foregroundColor(.white)
                    .cornerRadius(230)
                }
                .padding(.bottom, 50.0)
            }
            .navigationTitle("Treevia")
        }
        .environment(\.colorScheme, .dark)
        
        .fullScreenCover(isPresented: self.$showTriviaModal) {
            TriviaView()
        }
        
        .sheet(isPresented: self.$showDetailsModal, content: {
            DetailsView()
        })
        
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Wait a Moment!"),
                  message: Text("You've already played today. Please wait for the next watering time."),
                  dismissButton: .default(Text("Got it!")))
        }
        .onAppear {
            gameData.startCountdown() // Start the countdown
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(GameEngine())
}
