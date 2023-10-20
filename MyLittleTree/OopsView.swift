//
//  OopsView.swift
//  MyLittleTree
//
//  Created by Francesca Pia Sasso on 20/10/23.
//

import SwiftUI

struct OopsView: View {
    var body: some View {
        NavigationStack {

                  ZStack {
                      Color.accentColor
                      .ignoresSafeArea()
                      Color.black
                          .opacity(0.3)
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
              }


          }
      }
    

    

#Preview {
    OopsView()
}
