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
    var triviaAnswer = Answers()
    
    var body: some View {
                    
                    VStack{
                        HStack{
                            Text("1 of 5").foregroundStyle(Color.heavyGreen)
                               
                            
                            Spacer()
                            Image(systemName: "leaf")
                                .foregroundStyle(Color.heavyGreen)
                            Image(systemName: "leaf")
                                .foregroundStyle(Color.heavyGreen)
                            Image(systemName: "leaf")
                                .foregroundStyle(Color.heavyGreen)
                                
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
                            Text("Question 1")
                                .font(.title)
                                .bold()
                                

                            
                            AnswerRow(answer: Answer(text: "false", isCorrect: false), selectedAnswer: $selectedAnswer)
                            AnswerRow(answer: Answer(text: "true", isCorrect: true), selectedAnswer: $selectedAnswer)
                            AnswerRow(answer: Answer(text: "false", isCorrect: false),selectedAnswer: $selectedAnswer)
                            AnswerRow(answer: Answer(text: "false", isCorrect: false),selectedAnswer: $selectedAnswer)
                            
                        } .padding(50)
                        Spacer()
                            //.border(/*@START_MENU_TOKEN@*/Color.black/*@END_MENU_TOKEN@*/)
                        
                    }
        
                    .frame(maxHeight: .infinity)
                    .background(Color.accentColor)
                    //.ignoresSafeArea()
                    
                    //.border(.red)
            }
        }
    
    #Preview {
        TriviaView()
    }

