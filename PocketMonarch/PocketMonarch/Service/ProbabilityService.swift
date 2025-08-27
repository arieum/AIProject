//
//  ProbabilityService.swift
//  PocketMonarch
//
//  Created by 장유진 on 8/21/25.
//

import Foundation

// 가짜 -> 진짜 교체
protocol ProbabilityService {
    func infer(breathIndex: Int, text: String) async throws -> InferResponse
}

final class FakeProbabilityService: ProbabilityService {
    func infer(breathIndex: Int, text: String) async throws -> InferResponse {
        try await Task.sleep(nanoseconds: 300_000_000)
        let p = Double.random(in: 0...1)
        return InferResponse(
            breathIndex: breathIndex,
            probability: p,
            receivedAt: Date()
        )
    }
}
// 나중에 서버 붙을 때 RealProbabilityService 추가
