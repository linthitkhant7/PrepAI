//
//  CircleButton.swift
//  PrepAI
//
//  Created by Lin Thit Khant on 25/6/2569 BE.
//

import SwiftUI

struct CircleButton: View {
    let icon: String
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundStyle(.white)
                .frame(width: 60, height: 60)
                .background(color)
                .clipShape(.circle)
        }
    }
}

#Preview {
    CircleButton(icon: "paperplane", color: AppTheme.send) {
        print("tapped")
    }
}
