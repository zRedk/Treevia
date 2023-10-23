//
//  LeafDeath.swift
//  MyLittleTree
//
//  Created by Emanuele Di Pietro on 22/10/23.
//

import SwiftUI

struct LeafDeath: View {
    
    @Binding var deadLeaf: Bool
    
    var body: some View {
        Image(systemName: "leaf")
            .foregroundStyle(deadLeaf == false ? .heavyGreen : .gray)
    }
}

#Preview {
    LeafDeath(deadLeaf: .constant(false))
}

