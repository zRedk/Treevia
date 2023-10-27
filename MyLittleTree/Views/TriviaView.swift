//  TriviaView.swift

import SwiftUI
import Combine

struct TriviaView: View {
    @State var gameStage: Int = 0
    
    @State private var selectedAnswer: Answer? = nil
    @State var currentQuestion: Question?
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var gameData: GameEngine
        
    @State private var timeIsUp = false
    @State private var showingAlert = false
    
    func nextQuestion() {
        gameStage += 1

        guard let nq = hcQuestions.popLast() else {
            currentQuestion = nil
            return
        }

        if selectedAnswer == nil {
            gameData.regenerateLeavesIfNeeded()
        } else {
            selectedAnswer = nil
        }

        currentQuestion = nq

        if gameStage > 5 || gameData.allLeavesHidden() || gameData.remainingAttempts <= 0 {
            self.dismiss()
            gameData.stopAndReset()
        }
    }

    var body: some View {
        NavigationStack {
            
            VStack{
                HStack{
                    Text("\(gameStage) of 5").foregroundStyle(Color.heavyGreen)
                    
                    Spacer()
                    ForEach(gameData.leaves) { leaf in
                        Image(systemName: leaf.show ? "leaf.fill" : "leaf")
                            .foregroundColor(.greenButton)
                    }
                }
                .padding()
                
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
                }
                Image("water-can")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 150)
                
                VStack(alignment:.leading, spacing:8){
                    if let question = currentQuestion {
                        Text(question.text)
                            .foregroundStyle(.black)
                            .padding([.leading, .trailing], 10)
                            .bold()
                        ForEach(question.Answers){ answer in
                            AnswerRow(answer: answer, selectedAnswer: $selectedAnswer)
                                .environmentObject(gameData)
                        }
                    }
                    Spacer()
                }
                .padding()
                
                
                Spacer()
                
                if selectedAnswer != nil || gameData.timeRemainingForTrivia<=0 {
                    Button(action: {
                        nextQuestion()
                        gameData.resetTimer()
                        gameData.startTimer()
                    }){
                        Text("Continue")
                            .bold()
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.green)
                            .foregroundColor(.white)
                            .cornerRadius(20)
                            .padding([.leading, .trailing], 10)
                    }
                }
            }
            .background(Color.accentColor)
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
        .onAppear {
            nextQuestion()
            gameData.startTimer() // Start the countdown
        }
        
        .onChange(of: gameStage, {
            if gameStage > 5 || gameData.leaves.filter({ $0.show }).count <= 0{
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

