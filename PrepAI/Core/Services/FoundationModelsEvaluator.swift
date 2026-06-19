//
//  FoundationModelsEvaluator.swift
//  PrepAI
//
//  Created by Lin Thit Khant on 19/6/2569 BE.
//

import Foundation
import FoundationModels

actor FoundationModelsEvaluator: AnswerEvaluator {
    func evaluate(transcript: String, question: Question) async throws -> Score {
        let trimmed = transcript.trimmingCharacters(in: .whitespacesAndNewlines)
        guard trimmed.count >= 20 else {
            throw EvaluationError.transcriptTooShort
        }
        let model = SystemLanguageModel.default
        guard model.availability == .available else {
            throw EvaluationError.modelUnavailable
        }
        let session = LanguageModelSession()
        let prompt = buildPrompt(transcript: transcript, question: question)
        do {
            let response = try await session.respond(to: prompt, generating: GeneratedScore.self)
            return buildScore(from: response.content)
        } catch {
            throw EvaluationError.generationFailed
        }
    }

    private func buildPrompt(transcript: String, question: Question) -> String {
        let coreList = question.coreKeyPoints.map { "- \($0)" }.joined(separator: "\n")
        let bonusList = question.bonusKeyPoints.map { "- \($0)" }.joined(separator: "\n")
        let coreCount = question.coreKeyPoints.count
        return """
        You are evaluating a candidate's spoken interview answer.

        Question: \(question.text)

        A strong answer covers these core points:
        \(coreList)

        A great answer may also mention these bonus points:
        \(bonusList)

        Candidate's answer:
        \(transcript)

        The candidate's answer covers some of the \(coreCount) core points listed above.
        First, count exactly how many you find, and report it as coveredCorePoints.

        Only count a core point as covered if the candidate's answer above explicitly
        addresses it. Do not credit a point the candidate did not actually say.

        If the answer is empty, off-topic, incoherent, or does not genuinely attempt to
        answer the question, then coveredCorePoints is 0 and every score is 1.
        A vague or nonsensical answer must score 1, not a middle score.
        
        Then score accuracy and depth based on the proportion covered:
        - All \(coreCount) covered = 5
        - About three-quarters covered = 4
        - About half covered = 3
        - About one-quarter covered = 2
        - None covered = 1

        Do not give a high accuracy or depth score just because what was said is correct.
        An answer that is correct but covers few core points is incomplete and must score low.
        Identify strengths and weaknesses based on which specific points were covered and which were missed.
        """
    }

    private func buildScore(from generated: GeneratedScore) -> Score {
        let clarity = Criterion(
            score: Double(generated.clarityScore),
            strength: generated.clarityStrength,
            weakness: generated.clarityWeakness
        )
        let accuracy = Criterion(
            score: Double(generated.accuracyScore),
            strength: generated.accuracyStrength,
            weakness: generated.accuracyWeakness
        )
        let structure = Criterion(
            score: Double(generated.structureScore),
            strength: generated.structureStrength,
            weakness: generated.structureWeakness
        )
        let depth = Criterion(
            score: Double(generated.depthScore),
            strength: generated.depthStrength,
            weakness: generated.depthWeakness
        )
        let overallScore = (clarity.score + accuracy.score + structure.score + depth.score) / 4.0
        let criteria = [clarity, accuracy, structure, depth]
        let strongest = criteria.max { $0.score < $1.score }
        let weakest = criteria.min { $0.score < $1.score }
        let overall = Criterion(
            score: overallScore,
            strength: strongest?.strength ?? "",
            weakness: weakest?.weakness ?? ""
        )
        return Score(
            clarity: clarity,
            accuracy: accuracy,
            structure: structure,
            depth: depth,
            overall: overall
        )
    }
}

@Generable
struct GeneratedScore {
    @Guide(description: "The exact number of the listed core points that the candidate's answer actually covered")
    let coveredCorePoints: Int

    @Guide(description: "What was clear and easy to follow about the delivery")
    let clarityStrength: String
    @Guide(description: "What was unclear or hard to follow")
    let clarityWeakness: String
    @Guide(.range(1...5))
    let clarityScore: Int

    @Guide(description: "What was technically correct and accurate")
    let accuracyStrength: String
    @Guide(description: "What was incorrect, missing, or imprecise")
    let accuracyWeakness: String
    @Guide(.range(1...5))
    let accuracyScore: Int

    @Guide(description: "What was well-organized about the answer's structure")
    let structureStrength: String
    @Guide(description: "What was disorganized or poorly sequenced")
    let structureWeakness: String
    @Guide(.range(1...5))
    let structureScore: Int

    @Guide(description: "What showed depth of understanding")
    let depthStrength: String
    @Guide(description: "Where the answer was shallow or lacked detail")
    let depthWeakness: String
    @Guide(.range(1...5))
    let depthScore: Int
}
