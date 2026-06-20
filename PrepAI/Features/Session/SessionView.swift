//
//  SessionView.swift
//  PrepAI
//
//  Created by Lin Thit Khant on 9/6/2569 BE.
//

import SwiftUI

struct SessionView: View {
    @State private var viewModel: SessionViewModel
    
    init(category: CategoryType) {
        _viewModel = State(initialValue: SessionViewModel(category: category))
    }
    
    var body: some View {
        VStack {
            Text(viewModel.category.displayName)
            Text(
                viewModel.currentQuestion?.text ?? "Nothing to display"
            )
            
            switch viewModel.state {
            case .idle:
                Button("Record") {
                    viewModel.startRecording()
                }
            case .recording:
                Text(viewModel.speechRecognizer.transcript)
                Button("Stop") {
                    viewModel.stopRecording()
                }
            case .transcriptReady:
                TextEditor(text: $viewModel.speechRecognizer.transcript)
                Button("Re-record") {
                    viewModel.startRecording()
                }
                Button("Send") {
                    Task {
                        await viewModel.submit(transcript: viewModel.speechRecognizer.transcript)
                    }
                }
            case .evaluating:
                ProgressView()
                Text("Evaluating")
            case .scored(let score):
                Text("Overall Score \(score.overall.score, specifier: "%.1f") out of 10")
                Button("Next Question") {
                    viewModel.nextQuestion()
                }
            case .error(let error):
                Text("Couldn't evaluate: \(String(describing: error))")
                Button("Retry") {
                    Task {
                        await viewModel.retry(transcript: viewModel.speechRecognizer.transcript)
                    }
                }
            }
        }
        .onAppear {
            viewModel.speechRecognizer.requestAuthorization()
        }
    }
}

#Preview {
    SessionView(category: .iOSSpecific)
}
