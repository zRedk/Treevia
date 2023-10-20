//
//  TriviaView.swift
//  MyLittleTree
//
//  Created by Emanuele Di Pietro on 17/10/23.
//

import Foundation
import SwiftUI

struct TriviaView: View {
    
    @State private var selectedAnswer: Answer? = nil
    @State  var questions: [Question]
    @State  var unusedQuestions: [Question]
    @State  var currentQuestion: Question?
    var leavesShow = LeavesView()
    @Environment(\.dismiss) var dismiss
    
    @State private var showingAlert = false
    
    var triviaAnswer = Quiz()
    func nextQuestion() {
        guard let nextQuestion = unusedQuestions.popLast() else {
            currentQuestion = nil
            return
        }
        currentQuestion = nextQuestion
        selectedAnswer = nil
    }
    
    var body: some View {
        
        VStack{
            HStack{
                Button(action: {
                    showingAlert = true
                }) {
                    Image(systemName: "chevron.down")
                        .renderingMode(.original)
                }
                .foregroundColor(Color.heavyGreen)
                
                Text("1 of 5").foregroundStyle(Color.heavyGreen)
                
                
                Spacer()
                ForEach(leavesShow.leaves){ leaf in
                    HStack {
                        Image(systemName: "leaf")
                            .foregroundColor(.greenButton)
                    }
                }
                
            }
            //.border(/*@START_MENU_TOKEN@*/Color.black/*@END_MENU_TOKEN@*/)
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
                //Text("Question 1")
                // .font(.title)
                //.bold()
                if let question = currentQuestion{
                    Text(question.text)
                    ForEach(question.Answers){ answer in
                        AnswerRow(answer: answer, selectedAnswer: $selectedAnswer)
                    }
                }
                
                
                /*  AnswerRow(answer: Answer(text: "false", isCorrect: false), selectedAnswer: $selectedAnswer)
                 AnswerRow(answer: Answer(text: "true", isCorrect: true), selectedAnswer: $selectedAnswer)
                 AnswerRow(answer: Answer(text: "false", isCorrect: false),selectedAnswer: $selectedAnswer)
                 AnswerRow(answer: Answer(text: "false", isCorrect: false),selectedAnswer: $selectedAnswer)*/
                
            } .padding(50)
            Spacer()
            //.border(/*@START_MENU_TOKEN@*/Color.black/*@END_MENU_TOKEN@*/)
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
        .onAppear{
            unusedQuestions =
            questions.shuffled()
            nextQuestion()
        }
        
        
        
        .frame(maxHeight: .infinity)
        .background(Color.accentColor)
        //.ignoresSafeArea()
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
        
        
        //.border(.red)
    }
}

#Preview {
    TriviaView(questions: [Question(text: "Question1", Answers: [Answer(text: "Answer1"),Answer(text: "Answer2"),Answer(text: "Answer3"),Answer(text: "Answer4", isCorrect: true)])], unusedQuestions: [Question(text: "Question2", Answers: [Answer(text: "Answer1"),Answer(text: "Answer2"),Answer(text: "Answer3"),Answer(text: "Answer4", isCorrect: true)])])
}

