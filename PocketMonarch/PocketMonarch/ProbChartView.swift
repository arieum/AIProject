//
//  ProbChartView.swift
//  PocketMonarch
//
//  Created by 장유진 on 8/21/25.
//

import SwiftUI
import Charts

struct ProbChartView: View {
    @StateObject var vm = ProbViewModel(service: FakeProbabilityService())
    @EnvironmentObject var appState: AppState
    
    private var isHighRisk: Bool {
        (vm.points.last?.y ?? 0) >= 0.95
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("보이스피싱 확률: \(vm.latestText)").font(.headline)
            Chart(vm.points) { pt in
                LineMark(x: .value("Breath", pt.x),
                         y: .value("Probability", pt.y))
                PointMark(x: .value("Breath", pt.x),
                          y: .value("Probability", pt.y))
            }
            .chartYScale(domain: 0...1)
            .frame(height: 90)
            
            HStack {
                Button("확률 출력") {
                    Task { await vm.sendBreath(text: "한 호흡 텍스트")}
                }
                // Button("리셋") { vm.reset() }
            }
        }
        .padding()
        .onChange(of: appState.triggerEvent) { newValue in
            if newValue {
                Task {
                    vm.points.append(TimePoint(x: vm.points.count + 1, y: 0.92))
                    vm.latestText = "98%"
                    appState.triggerEvent = false // 다시 false로 초기화
                    NotificationManager.shared.notifyHighRisk(probText: "98%")
                }
            }
        }
        .onChange(of: vm.points) { _ in
            guard let last = vm.points.last else { return }
            if last.y >= 0.95 {
                NotificationManager.shared.notifyHighRisk(probText: String(format: "%.0f%%", last.y * 100))
            }
        }
    }
}

#Preview {
    ProbChartView()
}
