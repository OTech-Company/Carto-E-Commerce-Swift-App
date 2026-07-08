//
//  ChatInputBar.swift
//  Carto
//
//  Created by Ossama Abdellatif on 05/07/2026.
//

import SwiftUI
import Speech
import AVFoundation

struct ChatInputBar: View {
    @Binding var text: String
    var onSend: () -> Void
    
    // MARK: - Speech Properties
    @State private var isRecording = false
    @State private var speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "en-US"))
    @State private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    @State private var recognitionTask: SFSpeechRecognitionTask?
    @State private var audioEngine = AVAudioEngine()
    
    var body: some View {
        VStack(spacing: 4) {
            HStack(spacing: 12) {
                HStack {
                    TextField("Ask anything...", text: $text)
                        .font(.system(size: 15))
                        .submitLabel(.send)
                        .onSubmit {
                            handleIntentSubmission()
                        }
                    
                    // Waveform / Mic Toggle Button
                    Button(action: toggleRecording) {
                        Image(systemName: isRecording ? "waveform.circle.fill" : "waveform")
                            .font(.system(size: 18, weight: .medium))
                            .foregroundColor(isRecording ? .red : .blue)
                            .scaleEffect(isRecording ? 1.2 : 1.0)
                            .animation(.easeInOut(duration: 0.2), value: isRecording)
                    }
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .glassCardStyle(cornerRadius: 24)
                .overlay(
                    RoundedRectangle(cornerRadius: 24)
                        .stroke(
                            LinearGradient(
                                colors: isRecording ? [.red.opacity(0.6), .orange.opacity(0.6)] : [.cyan.opacity(0.4), .blue.opacity(0.4)],
                                startPoint: .leading,
                                endPoint: .trailing
                            ),
                            lineWidth: 1
                        )
                )
                
                // Secure Intent-Controlled Send Action
                Button(action: {
                    handleIntentSubmission()
                }) {
                    Image(systemName: "arrow.right")
                        .foregroundColor(.blue)
                        .padding(12)
                        .background(Color.blue.opacity(0.1))
                        .clipShape(Circle())
                }
                .disabled(text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty && !isRecording)
            }
            .padding(.horizontal)
            
            Text(isRecording ? "Listening... Tap waveform to stop" : "powered by Carto AI")
                .font(.system(size: 10))
                .foregroundColor(isRecording ? .red : .secondary)
                .padding(.top, 4)
        }
        .onDisappear {
            if isRecording { stopRecording() }
        }
    }
    
    // MARK: - Central Intent Dispatch Validation
    private func handleIntentSubmission() {
        // 1. If we are actively listening, stop the audio hardware track cleanly first
        if isRecording {
            stopRecording()
        }
        
        // 2. Wrap check on the Main Queue thread loop to guarantee text mutations have synchronized
        DispatchQueue.main.async {
            let processedPrompt = text.trimmingCharacters(in: .whitespacesAndNewlines)
            
            // Prevent execution if field contains completely zero content strings
            guard !processedPrompt.isEmpty else { return }
            
            // Run the networking composition payload use-case logic safely
            onSend()
        }
    }
    
    // MARK: - Speech Engine Control Logic
    private func toggleRecording() {
        if isRecording {
            stopRecording()
        } else {
            SFSpeechRecognizer.requestAuthorization { status in
                DispatchQueue.main.async {
                    switch status {
                    case .authorized:
                        try? startRecording()
                    default:
                        text = "Speech tracking permission denied."
                    }
                }
            }
        }
    }
    
    private func startRecording() throws {
        recognitionTask?.cancel()
        recognitionTask = nil
        
        let audioSession = AVAudioSession.sharedInstance()
        try audioSession.setCategory(.record, mode: .measurement, options: .duckOthers)
        try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
        
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        guard let recognitionRequest = recognitionRequest else { return }
        recognitionRequest.shouldReportPartialResults = true
        
        let inputNode = audioEngine.inputNode
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        
        inputNode.removeTap(onBus: 0) // Defensive reset clean state line
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { buffer, _ in
            recognitionRequest.append(buffer)
        }
        
        audioEngine.prepare()
        try audioEngine.start()
        isRecording = true
        
        recognitionTask = speechRecognizer?.recognitionTask(with: recognitionRequest) { result, error in
            var isFinal = false
            
            if let result = result {
                DispatchQueue.main.async {
                    self.text = result.bestTranscription.formattedString
                }
                isFinal = result.isFinal
            }
            
            // Error handling fallback cleanup logic
            if error != nil || isFinal {
                audioEngine.stop()
                inputNode.removeTap(onBus: 0)
                self.recognitionRequest = nil
                self.recognitionTask = nil
                
                DispatchQueue.main.async {
                    self.isRecording = false
                }
            }
        }
    }
    
    private func stopRecording() {
        audioEngine.stop()
        audioEngine.inputNode.removeTap(onBus: 0)
        recognitionRequest?.endAudio()
        recognitionTask?.finish() // complete cleanly instead of calling cancellation errors mid-stream
        
        let audioSession = AVAudioSession.sharedInstance()
        try? audioSession.setCategory(.ambient, mode: .default)
        try? audioSession.setActive(false, options: .notifyOthersOnDeactivation)
        
        isRecording = false
    }
}
