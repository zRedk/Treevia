//
//  AnswerRow.swift
//  MyLittleTree
//
//  Created by Federica Mosca on 18/10/23.
//

import SwiftUI

struct AnswerRow: View {
    var answer: Answer
    //@State private var isSelected = false
    @Binding var selectedAnswer: Answer?
    @EnvironmentObject var gameData: GameEngine
    var body: some View {
        HStack(spacing: 20){
        
            
            Text(answer.text)
                .bold()
                
            
            
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .center)
        .foregroundStyle(selectedAnswer == answer ? .black : (selectedAnswer == nil ? .black : .gray))
        .background(selectedAnswer == answer ? (answer.isCorrect ? .heavyGreen : .redWrong) : .greenButton)
        //.background(isSelected ? (answer.isCorrect ? .heavyGreen : .redWrong ): .greenButton)
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .onTapGesture {
          //  isSelected = true
            if selectedAnswer == nil {
                selectedAnswer = answer
                gameData.answerQuestion(isCorrect: answer.isCorrect)

            }
        }
        .allowsHitTesting(selectedAnswer == nil)
    }
}

#Preview {
    AnswerRow(answer: Answer(text: "Placeholder", isCorrect: false), selectedAnswer: .constant(nil)) 
        .environmentObject(GameEngine())

}
