//  HoorayView.swift

import SwiftUI

struct Hooray: View {
    var body: some View {
        ZStack{
            Color.accentColor
                .ignoresSafeArea()
            VStack {
                Text("Hooray!")
                    .bold()
                    .font(.system(size: 50))
                    .padding(35)
                Image("water-can")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .padding()
                    .frame(width: 250, height: 250)
                    .shadow(radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
                Text("You received some water for your plant!")
                    .bold()
                    .font(.system(size: 35))
                    .padding()
                    .multilineTextAlignment(.center)
            }
        }
        .environment(\.colorScheme, .light)
    }
}

#Preview {
    Hooray()
}
