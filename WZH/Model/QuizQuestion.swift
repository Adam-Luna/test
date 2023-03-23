//
//  QuizQuestion.swift
//  WZH
//
//  Created by Matthijs van der Linden on 14/03/2022.
//
///
////https://www.swiftbysundell.com/articles/codable-synthesis-for-swift-enums/


import UIKit


struct QuizQuestion: Codable {
    var category: QuizCategory
    var qaNumber: Int
    var question: String
    var answer: String
}

enum QuizCategory: String, Codable {
    case red    //taal
    case green  //natuur
    case blue   //liedjes
    case yellow //allerlei
    case orange //spreekwoorden en gezegden
}



