//
//  Session.swift
//  PrepAI
//
//  Created by Lin Thit Khant on 2/6/2569 BE.
//
import Foundation
import SwiftData

struct Criterion: Codable {
    let score: Double
    let strength: String
    let weakness: String
}

struct Score: Codable {
    let clarity: Criterion
    let accuracy: Criterion
    let structure: Criterion
    let depth: Criterion
    let overall: Criterion
}

enum CategoryType: String, Codable {
    case systemDesign
    case behavioral
    case iOSSpecific
}

@Model
class Session {
    @Attribute(.unique) var id: UUID = UUID()
    var category: CategoryType
    var question: String
    var transcript: String
    var duration: TimeInterval
    var date: Date
    var result: Score
    
    init(category: CategoryType, question: String, transcript: String, duration: TimeInterval, date: Date, result: Score) {
        self.category = category
        self.question = question
        self.transcript = transcript
        self.duration = duration
        self.date = date
        self.result = result
    }
}
