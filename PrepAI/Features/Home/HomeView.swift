//
//  HomeView.swift
//  PrepAI
//
//  Created by Lin Thit Khant on 6/6/2569 BE.
//

import SwiftUI
import SwiftData

struct HomeView: View {
    
    @Query var sessions: [Session]
    
    var body: some View {
        VStack {
            Text("PrepAI")
            Text("\(ScoreCalculator.averageSessionScore(sessions))")
            ForEach(CategoryType.allCases, id: \.self) { category in
                Button(category.displayName) {
                    
                }
            }
        }
    }
}

#Preview {
    HomeView()
}
