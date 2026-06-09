//
//  ProgressCalculator.swift
//  PrepAI
//
//  Created by Lin Thit Khant on 9/6/2569 BE.
//

struct ScoreCalculator {
    
    static func averageSessionScore(_ sessions: [Session]) -> Double {
        if sessions.isEmpty { return 0 }
        let total = sessions.reduce(0) { $0 + $1.result.overall.score }
        return total / Double(sessions.count)
    }
}
