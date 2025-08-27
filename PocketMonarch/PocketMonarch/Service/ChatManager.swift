//
//  ChatManager.swift
//  PocketMonarch
//
//  Created by 장유진 on 8/19/25.
//

import SwiftUI
import Speech

enum ChatManagerState {
    case idle
    case listening
    case finished
    case error(String)
}

@MainActor
class ChatManager: ObservableObject {
    let speechRecognizer: SpeechRecognizer
    @Published private(set) var currentState: ChatManagerState = .idle
    @Published var transcript: String = ""
    private var sessionPrefix: String = "" // 이어쓰기
    
    init() {
        self.speechRecognizer = SpeechRecognizer()
        
        // transcript 바인딩
        speechRecognizer.onTextUpdate = { [weak self] text in
            Task { @MainActor in
                self?.transcript = text
            }
        }
        print("ChatManager init")
    }
    deinit { print("ChatManager deinit") }
    
    func startListening() {
        currentState = .listening
        sessionPrefix = transcript // 이어쓰기
        speechRecognizer.onTextUpdate = { [weak self] current in
            guard let self = self else { return }
            Task {@MainActor in
                self.transcript = self.sessionPrefix.isEmpty ? current : (current.isEmpty ? self.sessionPrefix : self.sessionPrefix + " " + current)
            }
        }
        speechRecognizer.startTranscribing()
        print("STT: 듣기 시작")
    }
    
    func stopListening() {
        speechRecognizer.stopTranscribing()
        currentState = .finished
        print("STT: 듣기 종료")
    }
    
    func reset() {
        transcript = ""
        speechRecognizer.resetTranscript()
        currentState = .idle
    }
}
