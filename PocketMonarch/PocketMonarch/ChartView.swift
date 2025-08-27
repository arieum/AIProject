//
//  ProbabilityView.swift
//  PocketMonarch
//
//  Created by 장유진 on 8/21/25.
//

import SwiftUI

struct ChartView: View {
    
    var body: some View {
        VStack {
            // 게이지 박스
            RoundedRectangle(cornerRadius: 20)
                .fill(Color(.clear))
                .frame(height: 100)
                .padding(.horizontal)
            
            VStack(spacing: 10) {
                Text("보이스피싱 가능성이 있습니다!")
                    .font(.headline)
                    .foregroundStyle(.primary)
            }
        }
        .padding()
    }
}

#Preview {
    ChartView()
}
