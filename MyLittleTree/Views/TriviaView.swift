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
    @ObservedObject var leavesShow: LeavesView
    @Environment(\.dismiss) var dismiss
    
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
                
                Image("cloud-watering-can")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 150)
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
                        Image(systemName: "chevron.down")
                    }
                    .foregroundColor(Color.heavyGreen)
                })
            }
        }
        .onAppear {
            leavesShow.regenerateLeavesIfNeeded()
            nextQuestion()
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
    TriviaView(leavesShow: LeavesView(leaves: [Leaf(show: true), Leaf(show: true), Leaf(show: true)], lastRegenerationTime: Date()))
}
