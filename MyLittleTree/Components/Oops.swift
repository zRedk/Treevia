//  OopsView.swift

import SwiftUI

struct Oops: View {
    var body: some View {
        ZStack {
            Color("backgroundColor")
                .ignoresSafeArea()
            VStack {
                Text("Oops!")
                    .bold()
                    .font(.system(size: 50))
                    .padding(35)
                Image("nowater")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .padding()
                    .frame(width: 250, height: 250)
                    .shadow(radius: 10)
                Text("Unfortunately your plant will not receive water today, try tomorrow!")
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
    Oops()
}
