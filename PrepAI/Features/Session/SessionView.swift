//
//  SessionView.swift
//  PrepAI
//
//  Created by Lin Thit Khant on 9/6/2569 BE.
//

import SwiftUI

struct SessionView: View {
    @State private var viewModel: SessionViewModel
    @State private var speechRecognizer = SpeechRecognizer()
    
    init(category: CategoryType) {
        _viewModel = State(initialValue: SessionViewModel(category: category))
    }
    
    var body: some View {
        VStack {
            Text(viewModel.category.displayName)
            Text(
                viewModel.currentQuestion?.text ?? "Nothing to display"
            )
            Text("\(speechRecognizer.elapsedSeconds)")
            Button(speechRecognizer.isRecording ? "Stop" : "Record") {
                if speechRecognizer.isRecording {
                    speechRecognizer.stopTranscribing()
                } else {
                    speechRecognizer.startTranscribing()
                }
            }
            TextEditor(text: $speechRecognizer.transcript)
        }
        .onAppear {
            speechRecognizer.requestAuthorization()
        }
    }
}

#Preview {
    SessionView(category: .iOSSpecific)
}
