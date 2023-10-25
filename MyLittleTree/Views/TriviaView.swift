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
    @ObservedObject var leavesShow: LeavesView
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
            leavesShow.regenerateLeavesIfNeeded()
        } else {
            if let selectedAnswer = selectedAnswer, !selectedAnswer.isCorrect {
                // User selected a wrong answer, hide a leaf
                if let firstVisibleLeafIndex = leavesShow.leaves.firstIndex(where: { $0.show }) {
                    leavesShow.leaves[firstVisibleLeafIndex].show = false
                }
            }
            selectedAnswer = nil
        }
        
        currentQuestion = nq
        
        if gameStage > 5 || leavesShow.leaves.filter({ $0.show }).isEmpty {
            self.dismiss()
            timerViewModel.startTimer()
        }
    }
    
    
    var body: some View {
        NavigationStack {
            
            VStack{
                HStack{
                    Text("\(gameStage) of 5").foregroundStyle(Color.heavyGreen)
                    
                    Spacer()
                    ForEach(leavesShow.leaves) { leaf in
                        Image(systemName: leaf.show ? "leaf.fill" : "leaf")
                            .foregroundColor(.greenButton)
                    }
                }
                .padding()
                
                ZStack {
                    Image("cloud-watering-can")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 125)
                    Text(String(format: "00:%02d", viewModel.timeRemaining))
                        .bold()
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
                    .frame(width: 125)
                
                
                VStack(alignment:.center, spacing:10){
                    if let question = currentQuestion {
                        Text(question.text)
                        ForEach(question.Answers){ answer in
                            AnswerRow(answer: answer, selectedAnswer: $selectedAnswer)
                                .environmentObject(gameData)
                        }
                    }
                } .padding()
                
                
                Spacer()
                
                if selectedAnswer != nil {
                    
                    Button(action: {
                        nextQuestion()
                    }){
                        Text("Continue")
                            .bold()
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.green)
                            .foregroundColor(.white)
                            .cornerRadius(20)
                            .padding()
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
            leavesShow.regenerateLeavesIfNeeded()
            nextQuestion()
        }
        
        /* This make the modal dismiss itself
         when gameStage > 5 is reached
         
         This thing is supposed to be replaced
         with logic that makes your OopsView or your HoorayView
         display when the player finishes the minigame. */
        
        .onChange(of: gameStage, {
            if gameStage > 5 {
                self.dismiss()
            }
        })
    }
}


#Preview {
    TriviaView(leavesShow: LeavesView(leaves: [Leaf(show: true), Leaf(show: true), Leaf(show: true)], lastRegenerationTime: Date()), timerViewModel: TimerViewModel())
        .environmentObject(GameEngine())
}

