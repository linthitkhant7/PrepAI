//
//  OnboardingView.swift
//  PrepAI
//
//  Created by Lin Thit Khant on 6/6/2569 BE.
//
import SwiftUI

struct OnboardingPage: Identifiable {
    let id = UUID()
    let iconName: String
    let title: String
    let description: String
}

struct OnboardingView: View {
    
    let pages = [
        OnboardingPage(
            iconName: "message.circle",
            title: "PrepAI",
            description: "Coaching in your hand. It is free and secure."
        ),
        OnboardingPage(
            iconName: "lock",
            title: "Your data stays here",
            description: "PrepAI delivers available coaching with zero data leaving your device."
        ),
        OnboardingPage(
            iconName: "cpu",
            title: "Powered locally",
            description: "PrepAI uses your chip's LLM to its fullest capability."
        ),
        OnboardingPage(
            iconName: "paperplane",
            title: "Ready to coach",
            description: "Start practising your interview answers today."
        )
    ]
    
    @State private var currentPageIndex: Int = 0
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding: Bool = false
    
    var body: some View {
        TabView(selection: $currentPageIndex) {
            ForEach(pages.indices, id: \.self) { index in
                VStack {
                    Spacer()
                    Image(systemName: pages[index].iconName)
                    Spacer()
                    Text(pages[index].title)
                    Text(pages[index].description)
                    Button(currentPageIndex == pages.count - 1 ? "Get Started" : "Next") {
                        if currentPageIndex == pages.count - 1 {
                            hasCompletedOnboarding = true
                        } else {
                            currentPageIndex += 1
                        }
                    }
                    Spacer()
                }
                .tag(index)
            }
        }
        .tabViewStyle(.page)
    }
}

#Preview {
    OnboardingView()
}
