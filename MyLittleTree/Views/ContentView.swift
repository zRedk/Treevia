//
//  ContentView.swift
//  MyLittleTree
//
//  Created by Emanuele Di Pietro on 17/10/23.
//

import SwiftUI
import Combine

struct ContentView: View {
    
    @ObservedObject var timerViewModel = TimerViewModel()
    @State private var show_modal: Bool = false
    //Modal var
        
    @ObservedObject private var leavesShow = LeavesView(leaves: [Leaf(show: true), Leaf(show: true), Leaf(show: true)], lastRegenerationTime: Date())
    
    @ObservedObject var timerTriviaView = TimerTriviaView()
    @ObservedObject var viewModel = TimerTriviaView.shared
    
    init () {
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor.init(Color.black)]
    }

    var body: some View {
        NavigationStack {
            ZStack {
                
                Color.accentColor
                    .ignoresSafeArea()
                
                VStack{
                    HStack{
                        Image(systemName: "drop.fill")
                            .foregroundColor(.timeDropMW)
                        //here the text needs to be a function, we need to add the timer to the (time)
                        CountDown(timerViewModel: timerViewModel)
                            .foregroundColor(.timeDropMW) //here timeDropMW is the color for the text with the tear drop
                    }
                    Image("Garden view")
                        .resizable()
                        .aspectRatio(contentMode:.fit)
                        .frame(width: 200)
                        .padding(.bottom, 20.0)
                    //here to the button we need to add the function showmodal, and create a call to action to the next page (i.e. the trivia page)
                    Button("Water your plant!") {
                        if viewModel.timeRemaining >= 20 {
                            viewModel.startCountdown()
                        }
                        self.show_modal = true
                        if timerViewModel.remainingTime > 0 {
                            self.show_modal = false
                        }
                    }
                    .padding(25.0)
                    .background(.greenButton)
                    .foregroundColor(.white)
                    .cornerRadius(230)
                    .fullScreenCover(isPresented: self.$show_modal) {
                        TriviaView(leavesShow: leavesShow, timerViewModel: timerViewModel)
                    }
                    
                }
                .padding(.bottom, 50.0)
            }
            .navigationTitle("My Cute Little Tree")
        }.environment(\.colorScheme, .dark)
    }
}

#Preview {
    ContentView()
}
