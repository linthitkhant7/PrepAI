//
//  SpeechRecognizer.swift
//  PrepAI
//
//  Created by Lin Thit Khant on 10/6/2569 BE.
//

import Foundation
import Speech
import AVFoundation

@Observable
class SpeechRecognizer {
    
    private let audioEngine = AVAudioEngine()
    private let recognizer = SFSpeechRecognizer()
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    
    private var timer: Timer?
    
    var transcript: String = ""
    
    var isRecording = false
    
    var elapsedSeconds = 0
    
    func requestAuthorization() {
        SFSpeechRecognizer.requestAuthorization { _ in }
        AVAudioApplication.requestRecordPermission { _ in }
    }
    
    func startTranscribing() {
        do {
            recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
            
            let audioSession = AVAudioSession.sharedInstance()
            try audioSession.setCategory(.record, mode: .measurement, options: .duckOthers)
            try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
            
            let inputNode = audioEngine.inputNode
            let recordingFormat = inputNode.outputFormat(forBus: 0)
            inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { buffer, _ in
                self.recognitionRequest?.append(buffer)
            }
            audioEngine.prepare()
            try audioEngine.start()
            isRecording = true
            elapsedSeconds = 0
            timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { [weak self] _ in
                self?.elapsedSeconds += 1
            })
            recognitionTask = recognizer?.recognitionTask(
                with: recognitionRequest!
            ) { [weak self] result, _ in
                if let result {
                    DispatchQueue.main.async {
                        if self?.isRecording == true {
                            self?.transcript = result.bestTranscription.formattedString
                        }
                    }
                }
            }
        } catch {
            print("startTranscribing failed: \(error)")
        }
    }
    
    func stopTranscribing() {
        audioEngine.stop()
        isRecording = false
        timer?.invalidate()
        timer = nil
        audioEngine.inputNode.removeTap(onBus: 0)
        recognitionRequest?.endAudio()
        recognitionRequest = nil
        recognitionTask?.cancel()
        recognitionTask = nil
    }
}
