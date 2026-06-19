//
//  AnswerEvaluator.swift
//  PrepAI
//
//  Created by Lin Thit Khant on 19/6/2569 BE.
//

protocol AnswerEvaluator {
    func evaluate(transcript: String, question: Question) async throws -> Score
}

enum EvaluationError: Error {
    case modelUnavailable
    case generationFailed
    case guardrailTriggered
    case transcriptTooShort
}
