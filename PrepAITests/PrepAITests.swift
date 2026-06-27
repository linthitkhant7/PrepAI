//
//  PrepAITests.swift
//  PrepAITests
//
//  Created by Lin Thit Khant on 2/6/2569 BE.
//

import Testing
@testable import PrepAI
import Foundation

struct PrepAITests {
    
    func makeSession(overallScore: Double) -> Session {
        let categoryType = CategoryType.iOSSpecific
        let question = "Differences between Struct and Class?"
        let transcript = "Struct is a value type and class is a reference type."
        let duration = TimeInterval(3)
        let date = Date(timeIntervalSince1970: 0)
        let clarityCriterion = Criterion(score: 1.1, strength: "good vocabulary", weakness: "mixed meaning")
        let accuracyCriterion = Criterion(score: 2.2, strength: "smooth connection", weakness: "short explaination")
        let structureCriterion = Criterion(score: 3.3, strength: "interesting story", weakness: "weak outcome")
        let depthCriterion = Criterion(score: 4.4, strength: "wide variety", weakness: "unsaturated options")
        let overallCriterion = Criterion(score: overallScore, strength: "good presentation", weakness: "soft tone")
        let score = Score(
            clarity: clarityCriterion,
            accuracy: accuracyCriterion,
            structure: structureCriterion,
            depth: depthCriterion,
            overall: overallCriterion
        )
        let session = Session(
            category: categoryType,
            question: question,
            transcript: transcript,
            duration: duration,
            date: date,
            result: score
        )
        return session
    }

    @Test func categoryTypeHasAllCases() {
        #expect(CategoryType.systemDesign.rawValue == "systemDesign")
        #expect(CategoryType.behavioral.rawValue == "behavioral")
        #expect(CategoryType.iOSSpecific.rawValue == "iOSSpecific")
    }
    
    @Test func criterionCanBeCreated() {
        let criterion = Criterion(score: 9.9, strength: "strong foundation", weakness: "weak pace")
        #expect(criterion.score == 9.9)
        #expect(criterion.strength == "strong foundation")
        #expect(criterion.weakness == "weak pace")
    }
    
    @Test func scoreCanBeCreated() {
        let clarityCriterion = Criterion(score: 1.1, strength: "good vocabulary", weakness: "mixed meaning")
        let accuracyCriterion = Criterion(score: 2.2, strength: "smooth connection", weakness: "short explaination")
        let structureCriterion = Criterion(score: 3.3, strength: "interesting story", weakness: "weak outcome")
        let depthCriterion = Criterion(score: 4.4, strength: "wide variety", weakness: "unsaturated options")
        let overallCriterion = Criterion(score: 5.5, strength: "good presentation", weakness: "soft tone")
        let score = Score(
            clarity: clarityCriterion,
            accuracy: accuracyCriterion,
            structure: structureCriterion,
            depth: depthCriterion,
            overall: overallCriterion
        )
        #expect(score.clarity.score == 1.1)
        #expect(score.clarity.strength == "good vocabulary")
        #expect(score.clarity.weakness == "mixed meaning")
        #expect(score.accuracy.score == 2.2)
        #expect(score.accuracy.strength == "smooth connection")
        #expect(score.accuracy.weakness == "short explaination")
        #expect(score.structure.score == 3.3)
        #expect(score.structure.strength == "interesting story")
        #expect(score.structure.weakness == "weak outcome")
        #expect(score.depth.score == 4.4)
        #expect(score.depth.strength == "wide variety")
        #expect(score.depth.weakness == "unsaturated options")
        #expect(score.overall.score == 5.5)
        #expect(score.overall.strength == "good presentation")
        #expect(score.overall.weakness == "soft tone")
    }
    
    @Test func sessionCanBeCreated() {
        let session = makeSession(overallScore: 5.5)
        #expect(session.category.rawValue == "iOSSpecific")
        #expect(session.question == "Differences between Struct and Class?")
        #expect(session.transcript == "Struct is a value type and class is a reference type.")
        #expect(session.duration == TimeInterval(3))
        #expect(session.date == Date(timeIntervalSince1970: 0))
        #expect(session.result.clarity.score == 1.1)
        #expect(session.result.clarity.strength == "good vocabulary")
        #expect(session.result.clarity.weakness == "mixed meaning")
        #expect(session.result.accuracy.score == 2.2)
        #expect(session.result.accuracy.strength == "smooth connection")
        #expect(session.result.accuracy.weakness == "short explaination")
        #expect(session.result.structure.score == 3.3)
        #expect(session.result.structure.strength == "interesting story")
        #expect(session.result.structure.weakness == "weak outcome")
        #expect(session.result.depth.score == 4.4)
        #expect(session.result.depth.strength == "wide variety")
        #expect(session.result.depth.weakness == "unsaturated options")
        #expect(session.result.overall.score == 5.5)
        #expect(session.result.overall.strength == "good presentation")
        #expect(session.result.overall.weakness == "soft tone")
    }
    
    @Test func averageSessionsScoreCanBeCalculatedWithZeroSession() {
        #expect(ScoreCalculator.averageSessionScore([]) == 0)
    }
    
    @Test func averageSessionScoreCanBeCalculated() {
        let sessionOne = makeSession(overallScore: 10)
        let sessionTwo = makeSession(overallScore: 5)
        #expect(ScoreCalculator.averageSessionScore([sessionOne, sessionTwo]) == 7.5)
    }
    
    @Test func questionsCanBeFilteredByCategory() {
        let questions = [
            Question(text: "Q1", category: .behavioral, coreKeyPoints: [], bonusKeyPoints: []),
            Question(text: "Q2", category: .behavioral, coreKeyPoints: [], bonusKeyPoints: []),
            Question(text: "Q3", category: .iOSSpecific, coreKeyPoints: [], bonusKeyPoints: [])
        ]
        let viewModel = SessionViewModel(category: .behavioral, allQuestions: questions)
        #expect(viewModel.questions.count == 2)
        #expect(viewModel.questions.allSatisfy { $0.category == .behavioral })
    }
    
    func makeQuestion() -> Question {
        return Question(
            text: "test",
            category: .iOSSpecific,
            coreKeyPoints: [],
            bonusKeyPoints: []
        )
    }
    
    @Test func emptyTranscriptThrows() async {
        let evaluator = await FoundationModelsEvaluator()
        await #expect(throws: EvaluationError.transcriptTooShort) {
            try await evaluator.evaluate(transcript: "", question: makeQuestion())
        }
    }
    
    @Test func whitespaceTranscriptionThrows() async {
        let evaluator = await FoundationModelsEvaluator()
        await #expect(throws: EvaluationError.transcriptTooShort) {
            try await evaluator.evaluate(transcript: "  ", question: makeQuestion())
        }
    }
    
    func makeGeneratedScore() -> GeneratedScore {
        return GeneratedScore(
            coveredCorePoints: 4,
            clarityStrength: "clear",
            clarityWeakness: "cw",
            clarityScore: 2,
            accuracyStrength: "accurate",
            accuracyWeakness: "aw",
            accuracyScore: 4,
            structureStrength: "structured",
            structureWeakness: "sw",
            structureScore: 4,
            depthStrength: "deep",
            depthWeakness: "dw",
            depthScore: 2
        )
    }
    
    @Test func overallScoreIsAverageOfFour() async {
        let evaluator = await FoundationModelsEvaluator()
        let score = await evaluator.buildScore(from: makeGeneratedScore())
        await #expect(score.overall.score == 3.0)
    }
    
    @Test func criteriaMapFromGenerated() async {
        let evaluator = await FoundationModelsEvaluator()
        let score = await evaluator.buildScore(from: makeGeneratedScore())
        await #expect(score.clarity.score == 2.0)
        await #expect(score.accuracy.score == 4.0)
        await #expect(score.accuracy.strength == "accurate")
    }
    
    @Test func overallUsesStrongestAndWeakest() async {
        let evaluator = await FoundationModelsEvaluator()
        let score = await evaluator.buildScore(from: makeGeneratedScore())
        await #expect(score.overall.strength == "accurate")
        await #expect(score.overall.weakness == "cw")
    }
    
    struct FakeEvaluator: AnswerEvaluator {
        var result: Result<Score, EvaluationError>
        
        func evaluate(transcript: String, question: Question) async throws -> Score {
            switch result {
            case .success(let score):
                return score
            case .failure(let error):
                throw error
            }
        }
    }
    
    @Test func submitSuccessMovesToScored() async {
        let score = makeSession(overallScore: 5.0).result
        let viewModel = await SessionViewModel(
            category: .iOSSpecific,
            allQuestions: [makeQuestion()],
            evaluator: FakeEvaluator(result: .success(score))
        )
        await viewModel.submit(transcript: "some answer")
        
        guard case .scored = await viewModel.state else {
            Issue.record("expected scored state")
            return
        }
    }
    
    @Test func submitFailureMovesToError() async {
        let viewModel = await SessionViewModel(
            category: .iOSSpecific,
            allQuestions: [makeQuestion()],
            evaluator: FakeEvaluator(result: .failure(.modelUnavailable))
        )
        await viewModel.submit(transcript: "some answer")
        
        guard case .error = await viewModel.state else {
            Issue.record("expected error state")
            return
        }
    }
    
    @Test func formattedTimeShowsMinutesAndSeconds() {
        let viewModel = SessionViewModel(category: .iOSSpecific, allQuestions: [])
        viewModel.remainingSeconds = 65
        #expect(viewModel.formattedTime == "01:05")
    }
}
