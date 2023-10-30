//  TriviaView.swift

import SwiftUI
import Combine

struct TriviaView: View {
    @State private var showingRewardAlert = false
    @State private var timeIsUp = false
    @State private var showingAlert = false
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var gameData: GameEngine
    @State private var showFirstImage: Bool = true
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    var body: some View {
        NavigationStack {
            VStack{
                HStack{
                    Text("\(gameData.questionNumber) of 5")
                    
                    Spacer()
                    ForEach(gameData.leaves) { leaf in
                        Image(systemName: leaf.show ? "leaf.fill" : "leaf")
                    }
                }
                .foregroundStyle(Color.heavyGreen)
                .padding()
                
                if (gameData.triviaActive == true){
                    VStack(spacing: 3) {
                        Text(String(format: "00:%02d", gameData.timeRemainingForTrivia))
                            .bold()
                            .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                            .padding([.leading, .trailing], 10)
                            .padding(.top, -20)
                            .foregroundStyle(.black)
                            .onReceive(gameData.$timeRemainingForTrivia) { newValue in
                                if newValue <= 0 {
                                    gameData.loseLeaf()
                                }
                            }
                        Image("cloud-watering-can")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100)
                        ZStack {
                            Image(showFirstImage ? "rainFrame1" : "rainFrame2")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 50, height: 50) // Adjust size as required
                                .onReceive(timer) { _ in
                                    withAnimation(.easeInOut(duration: 0.2)) {
                                        showFirstImage.toggle()
                                    }
                                }
                        }
                        .onDisappear {
                            timer.upstream.connect().cancel()
                        }
                        Image("water-can")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100)
                    }
                    
                    VStack(alignment:.leading, spacing:8){
                        if let question = gameData.currentQuestion{
                            Text(question.text)
                                .foregroundStyle(.black)
                                .padding([.leading, .trailing], 10)
                                .bold()
                            Spacer()
                            
                            ForEach(question.Answers){ answer in
                                AnswerRow(answer: answer)
                                    .environmentObject(gameData)
                            }
                        }
                    }
                    .padding()
                } else {
                    GameResultView()
                }
                
                
                Spacer()
                
                if gameData.selectedAnswer != nil || gameData.timeRemainingForTrivia<=0 {
                    Button(action: {
                        gameData.nextQuestion()
                        gameData.resetTimer()
                        gameData.startTimer()
                    }){
                        Text("Continue")
                            .bold()
                            .frame(maxWidth: .infinity)
                            .foregroundColor(.white)
                    }
                    .padding()
                    .background(Color.green)
                    .cornerRadius(20)
                    .padding([.leading, .trailing], 10)
                } else {
                    HStack{
                        Button(action: {
                            gameData.useSunshineRay()
                        }){
                            Image(systemName: "sun.horizon.fill")
                                .foregroundColor(.white)
                            Text("Sunshine")
                                .bold()
                                .frame(maxWidth: .infinity)
                                .foregroundColor(.white)
                        }
                        .padding()
                        .background(Color.yellow)
                        .cornerRadius(20)
                        .padding([.leading, .trailing], 10)
                        .opacity(0.8)

                        Button(action: {
                            gameData.useFlowerBloom()
                        }){
                            HStack {
                                Image(systemName: "camera.macro")
                                    .foregroundColor(.white)
                                Text("Blossom")
                                    .bold()
                                    .frame(maxWidth: .infinity)
                                    .foregroundColor(.white)
                            }
                        }
                        .padding()
                        .background(Color.pink)
                        .cornerRadius(20)
                        .padding([.leading, .trailing], 10)
                        .opacity(0.8)
                    }
                }
            }
            .background(Color("backgroundColor"))
            .toolbar {
                ToolbarItem(placement: .destructiveAction, content: {
                    Button(action: {
                        showingAlert = true
                    }) {
                        Image(systemName: "multiply.circle")
                            .foregroundStyle(.red)
                    }
                    .alert(isPresented: $showingAlert) {
                        Alert(
                            title: Text("Confirm Close"),
                            message: Text("Are you sure you want to close this view?"),
                            primaryButton: .destructive(Text("Close")) {
                                dismiss()
                                gameData.stopTimer()
                                gameData.startCountdown()
                            },
                            secondaryButton: .cancel()
                        )
                    }
                    .foregroundColor(Color.heavyGreen)
                })
            }
        }
        .alert(isPresented: $showingRewardAlert) {
            if gameData.sunRay > UserDefaults.standard.integer(forKey: "sunRay") {
                return Alert(title: Text("Congratulations!"), message: Text("You've earned a Sunshine Ray!"), dismissButton: .default(Text("OK")))
            } else {
                return Alert(title: Text("Congratulations!"), message: Text("You've earned a Flower Bloom!"), dismissButton: .default(Text("OK")))
            }
        }
        
        .onChange(of: gameData.triviaActive, {
            if gameData.correctAnswersCount == 5 {
                self.showingRewardAlert = true
            }
        })

        .onAppear {
            gameData.nextQuestion()
            gameData.startTimer()
        }
        
        .onChange(of: gameData.allLeavesHidden(), {
            if (gameData.allLeavesHidden()){
                gameData.triviaActive = false
            }
        })
        
        .onChange(of: gameData.questionNumber, {
            if gameData.questionNumber > 5 || gameData.leaves.filter({ $0.show }).count <= 0 || gameData.triviaActive == false {
                dismiss()
                gameData.stopTimer()
                gameData.startCountdown()
            }
        })
    }
}


#Preview {
    TriviaView()
        .environmentObject(GameEngine())
}

