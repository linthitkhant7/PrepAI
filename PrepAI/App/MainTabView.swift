//
//  MainTabView.swift
//  PrepAI
//
//  Created by Lin Thit Khant on 9/6/2569 BE.
//

import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Label("Home", systemImage: "house")
                }
            Text("History")
                .tabItem {
                    Label("History", systemImage: "clock")
                }
            Text("Settings")
                .tabItem {
                    Label("Settings", systemImage: "gearshape")
                }
        }
    }
}

#Preview {
    MainTabView()
}
