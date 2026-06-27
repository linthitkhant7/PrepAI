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
        if case .sessionComplete = viewModel.state {
            SessionCompleteView(viewModel: viewModel)
                .navigationBarBackButtonHidden(true)
                .toolbar(.hidden, for: .tabBar)
        } else {
            VStack(alignment: .leading, spacing: AppTheme.spacingSmall) {
                HStack {
                    Text(viewModel.category.displayName)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    Spacer()
                    Text(viewModel.formattedTime)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                Text(
                    viewModel.currentQuestion?.text ?? "Nothing to display"
                )
                .font(.title2)
                .fontWeight(.bold)
                .frame(maxWidth: .infinity, alignment: .leading)
                
                switch viewModel.state {
                case .idle:
                    IdleStateView(viewModel: viewModel)
                case .recording:
                    RecordingStateView(viewModel: viewModel)
                case .transcriptReady:
                    TranscriptReadyStateView(viewModel: viewModel)
                case .evaluating:
                    EvaluatingStateView(viewModel: viewModel)
                case .scored(let score):
                    ScoredStateView(viewModel: viewModel, score: score)
                case .error(let error):
                    ErrorStateView(viewModel: viewModel, error: error)
                case .sessionComplete:
                    SessionCompleteView(viewModel: viewModel)
                }
                Spacer()
            }
            .padding(.horizontal, AppTheme.spacingMedium)
            .onAppear {
                viewModel.speechRecognizer.requestAuthorization()
            }
            .navigationBarBackButtonHidden(true)
            .toolbar(.hidden, for: .tabBar)
            .alert("End Interview?", isPresented: $viewModel.showingEndAlert) {
                Button("Yes", role: .destructive) {
                    
                }
                Button("No", role: .cancel) { }
            } message: {
                Text("This will end your session and save your current progress.")
            }
            .overlay {
                if !viewModel.hasStarted {
                    ZStack {
                        Rectangle()
                            .fill(.ultraThinMaterial)
                            .ignoresSafeArea()
                        Button {
                            viewModel.startSession()
                        } label: {
                            Text("Tap to start your interview session")
                                .font(.headline)
                                .foregroundStyle(.white)
                                .padding()
                                .background(AppTheme.send)
                                .clipShape(Capsule())
                        }
                    }
                }
            }
        }
    }
}

#Preview {
//    SessionView(category: .iOSSpecific)
    SessionCompleteView(viewModel: SessionViewModel(category: .iOSSpecific))
}

struct IdleStateView: View {
    let viewModel: SessionViewModel
    
    var body: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                Text("Tap to start recording your answer.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                Spacer()
                CircleButton(icon: "mic", color: AppTheme.send) {
                    viewModel.startRecording()
                }
            }
            .padding()
        }
    }
}

struct RecordingStateView: View {
    let viewModel: SessionViewModel
    
    var body: some View {
        VStack {
            Text(viewModel.speechRecognizer.transcript)
                .frame(maxWidth: .infinity, alignment: .leading)
            Spacer()
            HStack {
                Button {
                    viewModel.clearTranscript()
                } label: {
                    Image(systemName: "xmark")
                        .font(.title2)
                        .foregroundStyle(.black)
                        .frame(width: 60, height: 60)
                        .glassEffect()
                }
                Spacer()
                Text("Transcribing")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                Spacer()
                CircleButton(icon: "stop", color: AppTheme.stop) {
                    viewModel.stopRecording()
                }
            }
            .padding()
        }
    }
}

struct TranscriptReadyStateView: View {
    let viewModel: SessionViewModel
    
    var body: some View {
        VStack {
            Text(viewModel.speechRecognizer.transcript)
                .frame(maxWidth: .infinity, alignment: .leading)
            Spacer()
            HStack {
                Button {
                    viewModel.startRecording()
                } label: {
                    Image(systemName: "arrow.clockwise")
                        .font(.title2)
                        .foregroundStyle(.black)
                        .frame(width: 60, height: 60)
                        .glassEffect()
                }
                Spacer()
                Text("Tap to submit your answer.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                Spacer()
                CircleButton(icon: "paperplane", color: AppTheme.send) {
                    Task {
                        await viewModel.submit(transcript: viewModel.speechRecognizer.transcript)
                    }
                }
            }
            .padding()
        }
    }
}

struct EvaluatingStateView: View {
    let viewModel: SessionViewModel
    
    var body: some View {
        VStack {
            Text(viewModel.speechRecognizer.transcript)
                .frame(maxWidth: .infinity, alignment: .leading)
            Spacer()
            HStack {
                Button {
                    viewModel.showAlert()
                } label: {
                    Image(systemName: "chevron.left")
                        .font(.title2)
                        .foregroundStyle(.black)
                        .frame(width: 60, height: 60)
                        .glassEffect()
                }
                Spacer()
                Text("Evaluating")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                Spacer()
                CircleButton(icon: "mic", color: AppTheme.send) {
                    Task {
                        await viewModel.submit(transcript: viewModel.speechRecognizer.transcript)
                    }
                }
                .disabled(true)
            }
            .padding()
        }
    }
}

struct ScoredStateView: View {
    let viewModel: SessionViewModel
    let score: Score
    
    var body: some View {
        VStack {
            Text(viewModel.speechRecognizer.transcript)
                .frame(maxWidth: .infinity, alignment: .leading)
            Spacer()
            HStack {
                Button {
                    viewModel.showAlert()
                } label: {
                    Image(systemName: "chevron.left")
                        .font(.title2)
                        .foregroundStyle(.black)
                        .frame(width: 60, height: 60)
                        .glassEffect()
                }
                Spacer()
                Text("Overall Score \(score.overall.score, specifier: "%.1f") out of 10.")
                    .font(.subheadline)
                    .foregroundStyle(AppTheme.next)
                Spacer()
                CircleButton(icon: "chevron.right", color: AppTheme.next) {
                    viewModel.nextQuestion()
                }
            }
            .padding()
        }
    }
}

struct ErrorStateView: View {
    let viewModel: SessionViewModel
    let error: EvaluationError
    
    var body: some View {
        VStack {
            Text(viewModel.speechRecognizer.transcript)
                .frame(maxWidth: .infinity, alignment: .leading)
            Spacer()
            HStack {
                Button {
                    viewModel.showAlert()
                } label: {
                    Image(systemName: "chevron.left")
                        .font(.title2)
                        .foregroundStyle(.black)
                        .frame(width: 60, height: 60)
                        .glassEffect()
                }
                Spacer()
                Text("Couldn't evaluate: \(String(describing: error)).")
                    .font(.subheadline)
                    .foregroundStyle(AppTheme.retry)
                Spacer()
                CircleButton(icon: "arrow.trianglehead.2.clockwise", color: AppTheme.retry) {
                    Task {
                        await viewModel.retry(transcript: viewModel.speechRecognizer.transcript)
                    }
                }
            }
            .padding()
        }
    }
}

struct
SessionCompleteView: View {
    let viewModel: SessionViewModel
    @Environment(\.dismiss) private var dismiss
    	
    var body: some View {
        VStack(spacing: AppTheme.spacingMedium) {
            Spacer()
            Image(systemName: "checkmark")
                .font(.system(size: 80))
                .foregroundStyle(.primary)
            Text("Session complete.")
                .font(.title)
                .fontWeight(.bold)
            Spacer()
            Text("Evaluated on-device · nothing was uploaded")
                .font(.caption)
                .foregroundStyle(.secondary)
            HStack {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "chevron.left")
                        .font(.title2)
                        .foregroundStyle(.black)
                        .frame(width: 60, height: 60)
                        .glassEffect()
                }
                Spacer()
                Button {
                    // see feedback - future screen
                } label: {
                    Label("See your feedback", systemImage: "apple.intelligence")
                        .font(.headline)
                        .foregroundStyle(.white)
                        .padding()
                        .background(AppTheme.feedback)
                        .clipShape(Capsule())
                }
            }
            .padding()
        }
        .frame(maxWidth: .infinity)
    }
}
