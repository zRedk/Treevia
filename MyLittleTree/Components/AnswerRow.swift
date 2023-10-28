//  AnswerRow.swift

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
        .foregroundStyle(selectedAnswer == answer ? .white : (selectedAnswer == nil && gameData.timeRemainingForTrivia != 0 ? .white : .black))
        .background(selectedAnswer == answer ? (answer.isCorrect ? .heavyGreen : .redWrong) : selectedAnswer == nil  && gameData.timeRemainingForTrivia != 0 ? .greenButton : .gray)
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .onTapGesture {
            if selectedAnswer == nil && gameData.timeRemainingForTrivia != 0 {
                selectedAnswer = answer
                gameData.answerQuestion(isCorrect: answer.isCorrect)
                gameData.stopTimer()
            }
        }
        .allowsHitTesting(selectedAnswer == nil)
    }
}

#Preview {
    AnswerRow(answer: Answer(text: "Placeholder", isCorrect: false), selectedAnswer: .constant(nil))
        .environmentObject(GameEngine())
    
}
