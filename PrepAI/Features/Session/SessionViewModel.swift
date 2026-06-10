//
//  SessionViewModel.swift
//  PrepAI
//
//  Created by Lin Thit Khant on 9/6/2569 BE.
//

import Foundation

@Observable
class SessionViewModel {
    
    let category: CategoryType
    var questions: [Question] = []
    
    var currentIndex = 0
    var currentQuestion: Question? {
        guard questions.indices.contains(currentIndex) else { return nil }
        return questions[currentIndex]
    }
    
    init(category: CategoryType, allQuestions: [Question] = QuestionLoader.loadAllQuestion()) {
        self.category = category
        self.questions = allQuestions.filter { $0.category == category }
    }
    
}
