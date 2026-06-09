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
        NavigationStack {
            VStack {
                Text("PrepAI")
                Text("\(ScoreCalculator.averageSessionScore(sessions))")
                ForEach(CategoryType.allCases, id: \.self) { category in
                    NavigationLink(category.displayName, value: category)
                }
            }
            .navigationDestination(for: CategoryType.self) { category in
                SessionView(category: category)
            }
        }
    }
}

#Preview {
    HomeView()
}
