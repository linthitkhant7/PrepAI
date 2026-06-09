//
//  SessionView.swift
//  PrepAI
//
//  Created by Lin Thit Khant on 9/6/2569 BE.
//

import SwiftUI

struct SessionView: View {
    let category: CategoryType
    
    var body: some View {
        VStack {
            Text(category.displayName)
            Text("What is the difference between a struct and a class in swift?")
        }
    }
}

#Preview {
    SessionView(category: .iOSSpecific)
}
