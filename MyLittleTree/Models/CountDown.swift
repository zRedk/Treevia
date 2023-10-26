//
//  SwiftUIView.swift
//  MyLittleTree
//
//  Created by Emanuele Di Pietro on 23/10/23.
//

import SwiftUI

struct CountDown: View {
    @ObservedObject var timerViewModel: TimerViewModel
    
    var body: some View {
        HStack(spacing: 5){
            if timerViewModel.remainingTime > 0 {
                Image(systemName: "drop.fill")
                Text(String(format: "%02d:%02d:%02d", (Int(timerViewModel.remainingTime / 3600)), (Int((timerViewModel.remainingTime.truncatingRemainder(dividingBy: 3600)) / 60)), (Int(timerViewModel.remainingTime.truncatingRemainder(dividingBy: 60)))))
                    .bold()
                Text("remaining til next watering")
            } else {
                Image(systemName: "tree.fill")
                Text("Learn more about plants!")
                    .bold()
            }
        }
            .onAppear {
                timerViewModel.stopTimer() 
            }
        }
    }
