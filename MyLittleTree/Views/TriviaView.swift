//
//  TriviaView.swift
//  MyLittleTree
//
//  Created by Emanuele Di Pietro on 17/10/23.
//

import SwiftUI

struct TriviaView: View {
    @State var gameStage: Int = 0
    
    @State private var selectedAnswer: Answer? = nil
    @State var currentQuestion: Question?
    @Environment(\.dismiss) var dismiss
    
    //here i'm creating the state var for the timer set to 60 and running set to false
        @State var counter = 10
        @State var timeIsRunning = true
        @State private var timeIsUp = false
        let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    @State private var deadLeaf = false
    var leavesShow = LifeLeaf()
    
    @State private var showingAlert = false
    
    func nextQuestion() {

        gameStage += 1
        
        guard let nq = hcQuestions.popLast() else {
            currentQuestion = nil
            return
        }
        
        currentQuestion = nq
        selectedAnswer = nil
    }
    
    var body: some View {
        NavigationStack {
            
            VStack{
                HStack{
                    Text("\(gameStage) of 5").foregroundStyle(Color.heavyGreen)
                    
                    Spacer()
                    ForEach(leavesShow.Leaves) { leaf in
                        HStack {
                            LeafDeath(deadLeaf: $deadLeaf)
                            }
                        }
                    }
                    .padding()
                
                ZStack {
                    Image("cloud-watering-can")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 150)
                    Text(String(format: "00:%02d", counter))
                        .onReceive(timer) { _ in
                            if counter > 0 && timeIsRunning {
                                counter -= 1
                            } else {
                                timeIsUp = true
                                deadLeaf = true
                            }
                        }
                        .bold()
                        .alert(isPresented: $timeIsUp){
                            Alert(
                                title: Text("Time is up"),
                                message: Text("The timer has finished, you lost."),
                                dismissButton: .destructive(Text("Close")) {
                                    dismiss()
                                }
                            )
                        }
                }
                        
                Image("water-can")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 150)
                
                
                VStack(alignment:.center, spacing:15){
                    if let question = currentQuestion {
                        Text(question.text)
                        ForEach(question.Answers){ answer in
                            AnswerRow(answer: answer, selectedAnswer: $selectedAnswer)
                        }
                    }
                } .padding(50)
                
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
                    } .padding()
                }
            }
            .background(Color.accentColor)
            .toolbar {
                ToolbarItem(placement: .cancellationAction, content: {
                    Button(action: {
                        showingAlert = true
                    }) {
                        Text("Exit")
                    }
                    .alert(isPresented: $showingAlert) {
                        Alert(
                            title: Text("Confirm Close"),
                            message: Text("Are you sure you want to close this view?"),
                            primaryButton: .destructive(Text("Close")) {
                                dismiss()
                            },
                            secondaryButton: .cancel()
                        )
                    }
                    .foregroundColor(Color.heavyGreen)
                })
            }
        }
        .onAppear{
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
    TriviaView()
}

