//
//  ProbViewModel.swift
//  PocketMonarch
//
//  Created by 장유진 on 8/21/25.
//

import Foundation

@MainActor
final class ProbViewModel: ObservableObject {
    @Published var points: [TimePoint] = [] // 차트를 배열로 그리기
    @Published var latestText = "--"
    
    private let service: ProbabilityService
    private var breathIndex = 0
    
    init(service: ProbabilityService) {
        self.service = service
    }
    
    func sendBreath(text: String) async {
        breathIndex += 1
        do {
            let res = try await service.infer(breathIndex: breathIndex, text: text)
            points.append(.init(x: res.breathIndex, y: res.probability))
            latestText = String(format: "%.0f%%", res.probability*100)
        } catch {
            latestText = "ERR"
        }
    }
    
    func reset() {
        breathIndex = 0
        points.removeAll()
        latestText = "--"
    }
}
