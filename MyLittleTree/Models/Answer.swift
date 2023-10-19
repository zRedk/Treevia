//
//  Answer.swift
//  MyLittleTree
//
//  Created by Emanuele Di Pietro on 18/10/23.
//

import Foundation
import SwiftUI

struct Answer: Identifiable, Equatable {
    var id = UUID()
    var text: String
    var isCorrect: Bool = false
}


