//  AnswerRow.swift

import SwiftUI

struct AnswerRow: View {
    var answer: Answer
    //@State private var isSelected = false
    @EnvironmentObject var gameData: GameEngine
    var body: some View {
        HStack(spacing: 20){
            Text(answer.text)
                .bold()
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .center)
        .foregroundStyle(gameData.selectedAnswer == answer ? .white : (gameData.selectedAnswer == nil && gameData.timeRemainingForTrivia != 0 ? .white : .black))
        .background(gameData.selectedAnswer == answer ? (answer.isCorrect ? .heavyGreen : .redWrong) : gameData.selectedAnswer == nil  && gameData.timeRemainingForTrivia != 0 ? .greenButton : .gray)
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .onTapGesture {
            if gameData.selectedAnswer == nil && gameData.timeRemainingForTrivia != 0 {
                gameData.selectedAnswer = answer
                gameData.answerQuestion(isCorrect: answer.isCorrect)
                gameData.stopTimer()
            }
        }
        .allowsHitTesting(gameData.selectedAnswer == nil)
    }
}

#Preview {
    AnswerRow(answer: Answer(text: "Placeholder", isCorrect: false))
        .environmentObject(GameEngine())
    
}
