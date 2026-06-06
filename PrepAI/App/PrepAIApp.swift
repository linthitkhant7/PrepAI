//
//  PrepAIApp.swift
//  PrepAI
//
//  Created by Lin Thit Khant on 2/6/2569 BE.
//

import SwiftUI
import SwiftData

@main
struct PrepAIApp: App {
    
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding: Bool = false
    
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Session.self
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            if hasCompletedOnboarding {
                HomeView()
            } else {
                OnboardingView()
            }
        }
        .modelContainer(sharedModelContainer)
    }
}
