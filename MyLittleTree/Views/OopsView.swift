//  OopsView.swift

import SwiftUI

struct OopsView: View {
    var body: some View {
        ZStack {
            Color.accentColor
                .ignoresSafeArea()
            
            VStack{
                Text("Oops!")
                    .bold()
                    .font(.system(size: 60))
                Image("nowater")
                    .resizable()
                    .aspectRatio(contentMode:.fit)
                    .frame(width: 300)
                    .padding(.bottom, 20.0)
                    .padding()
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
    OopsView()
}
