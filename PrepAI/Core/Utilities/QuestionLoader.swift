//
//  QuestionLoader.swift
//  PrepAI
//
//  Created by Lin Thit Khant on 9/6/2569 BE.
//

import Foundation

struct QuestionLoader {
    static func loadAllQuestion() -> [Question] {
        guard let url = Bundle.main.url(forResource: "questions", withExtension: "json") else {
            fatalError("questions.json not found in bundle")
        }
        do {
            let data = try Data(contentsOf: url)
            return try JSONDecoder().decode([Question].self, from: data)
        } catch {
            fatalError("Failed to decode questions.json: \(error)")
        }
    }
}
