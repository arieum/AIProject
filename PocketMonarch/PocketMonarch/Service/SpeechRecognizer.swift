//
//  SpeechTranscriber.swift
//  PocketMonarch
//
//  Created by 장유진 on 8/19/25.
//

import Foundation
import Speech
import AVFoundation

class SpeechRecognizer {
    private let recognizer = SFSpeechRecognizer(locale: Locale(identifier: "ko-KR"))
    private let audioEngine = AVAudioEngine()
    private var request: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    
    var onTextUpdate: ((String) -> Void)?
    private(set) var transcript: String = "" {
        didSet { onTextUpdate?(transcript) }
    }
    
    init() {
        SFSpeechRecognizer.requestAuthorization { authStatus in
            if authStatus != .authorized {
                print("음성 인식 권한이 없습니다.")
            }
        }
    }
    
    func startTranscribing() {
        request = SFSpeechAudioBufferRecognitionRequest()
        
        guard let request = request else { return }
        guard let recognizer = recognizer, recognizer.isAvailable else {
            print("인식기가 사용 불가합니다.")
            return
        }
        
        let inputNode = audioEngine.inputNode
        recognitionTask = recognizer.recognitionTask(with: request) { [weak self] result, error in
            if let result = result {
                self?.transcript = result.bestTranscription.formattedString
            }
            if error != nil {
                self?.stopTranscribing()
            }
        }
        
        let format = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: format) { buffer, _ in
            request.append(buffer)
        }
        
        audioEngine.prepare()
        try? audioEngine.start()
    }
    
    func stopTranscribing() {
        audioEngine.stop()
        audioEngine.inputNode.removeTap(onBus: 0)
        request?.endAudio()
        recognitionTask?.cancel()
    }
    
    func resetTranscript() {
        transcript = ""
    }
}
