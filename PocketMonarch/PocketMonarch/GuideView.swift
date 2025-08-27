import SwiftUI

struct GuideView: View {
    var body: some View {
        NavigationLink(destination: GuideDetailView()) {
            ZStack {
                // 배경 카드
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .fill(Color("PoscoBlue"))
                    .shadow(color: .black.opacity(0.1), radius: 6, y: 3)

                // 내용
                HStack(spacing: 10) {
                    VStack(alignment: .leading, spacing: 6) {
                        Text("다음 가이드라인을 참고해보세요!")
                            .font(.subheadline)
                            .foregroundColor(.white.opacity(0.95))

                        Text("보이스피싱 대처 가이드라인")
                            .font(.headline).bold()
                            .foregroundColor(.white)
                            .lineLimit(1)
                            .minimumScaleFactor(0.9)
                    }

                    Spacer()

                    Image(systemName: "doc.text.magnifyingglass")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 36, height: 36)
                        .foregroundStyle(.white)
                        .padding(10)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(.white.opacity(0.18))
                        )
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 16)
            }
            .frame(height: 100)
            .padding(.horizontal)
            .accessibilityElement(children: .combine)
            .accessibilityLabel("보이스피싱 대처 가이드라인 화면으로 이동")
        }
        .buttonStyle(.plain) // 카드처럼 보이게
        .padding(.vertical, 8)
    }
}

#Preview {
    NavigationStack {
        GuideView()
    }
}
