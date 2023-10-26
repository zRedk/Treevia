//
//  TriviaView.swift
//  MyLittleTree
//
//  Created by Emanuele Di Pietro on 17/10/23.
//

import SwiftUI
import Combine

struct TriviaView: View {
    @State var gameStage: Int = 0
    
    @State private var selectedAnswer: Answer? = nil
    @State var currentQuestion: Question?
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var gameData: GameEngine
    
    //@ObservedObject var timeRemaining: TimerTriviaView
    @ObservedObject var viewModel = TimerTriviaView.shared
    
    //here i'm creating the state var for the timer set to 60 and running set to false
    //@State var counter = 10
    //@State var timeIsRunning = true
    @State private var timeIsUp = false
    // @Binding var timeRemaining: Int
    //let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    @State private var deadLeaf = false
    @ObservedObject var timerViewModel: TimerViewModel
    //var leavesShow = LifeLeaf()
    
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
            timerViewModel.startTimer()
            viewModel.stopAndReset()
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
                    Text(String(format: "00:%02d", viewModel.timeRemaining))
                        .bold()
                        .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                        .padding([.leading, .trailing], 10)
                        .padding(.top, -20)
                        .foregroundStyle(.black)
                        .onReceive(viewModel.$timeRemaining) { newValue in
                            if newValue <= 0 {
                                // Use self.dismiss() to trigger dismissal
                                timerViewModel.startTimer()
                                timeIsUp = false
                                if timeIsUp == false {
                                    viewModel.stopAndReset()
                                    self.dismiss()
                                    
                                }
                                
                            }
                        }
                    Image("cloud-watering-can")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100)
                    
                    /*.alert(isPresented: $timeIsUp){
                     Alert(
                     title: Text("Time is up"),
                     message: Text("The timer has finished, you lost."),
                     dismissButton: .destructive(Text("Close")) {
                     dismiss()
                     
                     }
                     )
                     }*/
                    
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
                
                if selectedAnswer != nil {
                    
                    Button(action: {
                        nextQuestion()
                        viewModel.stopAndReset()
                        viewModel.startCountdown()
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
                                viewModel.stopAndReset()
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
        }
        
        /* This make the modal dismiss itself
         when gameStage > 5 is reached
         
         This thing is supposed to be replaced
         with logic that makes your OopsView or your HoorayView
         display when the player finishes the minigame. */
        
        .onChange(of: gameStage, {
            if gameStage > 5 {
                if gameStage > 5 || gameData.leaves.filter({ $0.show }).count > 0 {
                    self.dismiss()
                    timerViewModel.stopTimer()
                }
            }
        })
    }
}


#Preview {
    TriviaView(timerViewModel: TimerViewModel())
        .environmentObject(GameEngine())
}

