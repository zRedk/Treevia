//  HoorayView.swift

import SwiftUI

struct HoorayView: View {
    var body: some View {
        ZStack{
            Color.accentColor
                .ignoresSafeArea()
            VStack {
                Text("Hooray!")
                    .fontWeight(.bold)
                    .font(.system(size: 60))
                    .padding(40)
                Image("water-can")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 350)
                    .clipShape(RoundedRectangle(cornerRadius: 25))
                    .padding()
                    .frame(width: 300, height: 300)
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
    HoorayView()
}
