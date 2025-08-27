//
//  Chart.swift
//  PocketMonarch
//
//  Created by 장유진 on 8/21/25.
//

import Charts
import SwiftUI

struct TimePoint: Identifiable, Equatable {
    var id: Int { x }
    let x: Int // 호흡인덱스
    let y: Double // 확률
}

// 서버 응답 모델 (json을 파싱해 담아두는 그릇 Data Transfer Object)
struct InferResponse: Codable {
    let breathIndex: Int // 호흡인덱스
    let probability: Double // 확률
    let receivedAt: Date // 서버 수신 시각
}
