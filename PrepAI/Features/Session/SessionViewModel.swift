//
//  SessionViewModel.swift
//  PrepAI
//
//  Created by Lin Thit Khant on 9/6/2569 BE.
//

import Foundation

@Observable
class SessionViewModel {
    
    enum SessionState {
        case idle
        case recording
        case transcriptReady
        case evaluating
        case scored(Score)
        case error(EvaluationError)
    }
    
    private(set) var state: SessionState = .idle
    
    private let evaluator: AnswerEvaluator
    let speechRecognizer = SpeechRecognizer()

    let category: CategoryType
    var questions: [Question] = []
    
    var currentIndex = 0
    var currentQuestion: Question? {
        guard questions.indices.contains(currentIndex) else { return nil }
        return questions[currentIndex]
    }
    
    init(
        category: CategoryType,
        allQuestions: [Question] = QuestionLoader.loadAllQuestion(),
        evaluator: AnswerEvaluator = FoundationModelsEvaluator()
    ) {
        self.category = category
        self.questions = allQuestions.filter { $0.category == category }
        self.evaluator = evaluator
    }
    
    func submit(transcript: String) async {
        guard let question = currentQuestion else { return }
        state = .evaluating
        do {
            let score = try await evaluator.evaluate(transcript: transcript, question: question)
            state = .scored(score)
        } catch let error as EvaluationError {
            state = .error(error)
        } catch {
            state = .error(.generationFailed)
        }
    }
    
    func nextQuestion() {
        currentIndex += 1
        state = .idle
    }
    
    func retry(transcript: String) async {
        await submit(transcript: transcript)
    }
    
    func startRecording() {
        speechRecognizer.startTranscribing()
        state = .recording
    }
    
    func stopRecording() {
        speechRecognizer.stopTranscribing()
        state = .transcriptReady
    }
    
}
