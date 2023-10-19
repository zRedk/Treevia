//
//  Question.swift
//  MyLittleTree
//
//  Created by Federica Mosca on 19/10/23.
//

import Foundation

struct Question: Identifiable{
    var id = UUID()
    var text: String
    var Answers: [Answer]
}
