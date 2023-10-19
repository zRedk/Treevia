//
//  ContentView.swift
//  MyLittleTree
//
//  Created by Emanuele Di Pietro on 17/10/23.
//

import SwiftUI

struct ContentView: View {
    @State private var show_modal: Bool = false
    
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
                        Text("(Time:Time) to the next watering")
                            .foregroundColor(.timeDropMW) //here timeDropMW is the color for the text with the tear drop
                    }
                    Image("Garden view")
                        .resizable()
                        .aspectRatio(contentMode:.fit)
                        .frame(width: 200)
                        .padding(.bottom, 20.0)
                    //here to the button we need to add the function showmodal, and create a call to action to the next page (i.e. the trivia page)
                    Button("Water your plant!") {
                        self.show_modal = true
                    }
                    .padding(25.0)
                    .background(.greenButton) //color that i took from the figma file and put into assets
                    .foregroundColor(.white)
                    .cornerRadius(230)
                    .sheet(isPresented: self.$show_modal) {
                        TriviaView()
                    }

                }
                .padding(.bottom, 50.0)
            }
            .navigationTitle("My Cute Little Tree")
        }
    }
}

#Preview {
    ContentView()
}
