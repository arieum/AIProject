import SwiftUI

struct ScriptView: View {
    @StateObject var chatManager = ChatManager()
    @EnvironmentObject var appState: AppState

    // 보정될 고정 대사
    private let correctedText = """
    지금 현재 혐의자 신분이기 때문에 사건에 대해서 유출하면 안된다는 겁니다.
    발설하면 가중처벌은 당연한거고 당신이 발설한 그 사람들도 같이 처벌 받아요. 이해하셨죠?
    """

    // 빨간 경고 문구
    private let warningText = """
    🚨 헌법 12조에 따르면,
    누구든지 구속의 이유로 변호인의 조력을 받을 권리가 있음을 고지받지 아니하고는 구속을 당하지 아니한다고 명시되어 있습니다.
    즉, 혐의자임을 주장하며 발설하면 안된다는 말은 불법적인 협박이나 강요로 볼 수 있습니다.
    """

    @State private var showCorrection = false

    private let trigger = "이해하셨죠"

    var body: some View {
        VStack(spacing: 12) {
            HStack {
                Image(systemName: "waveform.circle.fill")
                    .foregroundColor(.blue)
                VStack(alignment: .leading, spacing: 2) {
                    Text("듣는 중...").font(.headline)
                    Text("통화를 실시간으로 보호 분석중입니다")
                        .font(.subheadline).foregroundColor(.secondary)
                }
                Spacer()
            }
            .padding(.horizontal)
            .padding(.top, 10)

            ZStack {
                RoundedRectangle(cornerRadius: 20)
                    .fill(.ultraThinMaterial)
                    .frame(height: 300)
                    .padding(.horizontal)

                VStack(alignment: .leading, spacing: 12) {
                    // ZStack 내부의 ScrollView { ZStack { ... } } 부분만 교체
                    ScrollView {
                        ZStack(alignment: .topLeading) {
                            if chatManager.transcript.isEmpty && !showCorrection {
                                TranscriptPlaceholder()
                                    .transition(.opacity)
                            } else {
                                // 1) 실시간 STT 텍스트
                                Text(chatManager.transcript)
                                    .opacity(showCorrection ? 0 : 1)
                                    .font(.body)                       // 가독성
                                    .lineSpacing(4)                    // 행간
                                    .foregroundStyle(.primary)
                                    .textSelection(.enabled)           // 복사 가능
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 8)

                                // 2) 보정된 고정 대사
                                Text(correctedText)
                                    .opacity(showCorrection ? 1 : 0)
                                    .font(.body)
                                    .lineSpacing(4)
                                    .foregroundStyle(.primary)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 8)
                            }
                        }
                        .padding()
                        .contentTransition(.interpolate)
                        .animation(.spring(response: 0.35, dampingFraction: 0.9), value: showCorrection)
                    }
                    .frame(maxHeight: 180)


                    if showCorrection {
                        WarningCard(text: warningText)
                            .transition(.opacity.combined(with: .move(edge: .top)))
                            .padding(.horizontal)
                    }

                    HStack {
                        Button("듣기 시작") {
                            chatManager.startListening()
                            withAnimation { showCorrection = false }
                        }
                        Button("듣기 종료") {
                            chatManager.stopListening()
                        }
                    }
                    .padding(.leading, 30)
                    .padding(.bottom, 10)
                }
                
            }
        }
        .onChange(of: chatManager.transcript) { newValue in
            // 마지막이 "이해하셨죠"로 끝나면 보정 트리거
            guard !showCorrection else { return }
            let normalized = newValue
                .replacingOccurrences(of: "?", with: "")
                .replacingOccurrences(of: "!", with: "")
                .trimmingCharacters(in: .whitespacesAndNewlines)

            if normalized.hasSuffix(trigger) {
                // 살짝 지연 후 자연스럽게 전환
                Task { @MainActor in
                    try? await Task.sleep(nanoseconds: 200_000_000)
                    withAnimation {
                        showCorrection = true
                    }
                    // (선택) 약한 햅틱
                    appState.triggerEvent = true
                    
                    #if os(iOS)
                    UIImpactFeedbackGenerator(style: .light).impactOccurred()
                    #endif
                }
            }
        }
    }
}

// 빨간 경고 카드
private struct WarningCard: View {
    let text: String
    var body: some View {
        Text(text)
            .font(.subheadline).bold()
            .foregroundColor(.red)
            .multilineTextAlignment(.leading)
            .padding(12)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(RoundedRectangle(cornerRadius: 12).fill(Color.red.opacity(0.12)))
            .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.red.opacity(0.35), lineWidth: 1))
            .accessibilityLabel("중요 경고")
    }
}

// 전문적인 빈 상태 UI
private struct TranscriptPlaceholder: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 10) {
                Image(systemName: "text.bubble.fill")
                    .font(.title2)
                    .foregroundStyle(.blue)
                VStack(alignment: .leading, spacing: 2) {
                    Text("분석 대기 중")
                        .font(.headline)
                    Text("통화 내용을 인식하면 여기에서 바로 보여드릴게요.")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                .redacted(reason: .placeholder)
                .shimmering()
            }

            // 얇은 스켈레톤 3줄
            VStack(alignment: .leading, spacing: 6) {
                skeletonLine(width: .infinity)
                skeletonLine(width: .infinity)
                skeletonLine(width: 180)
            }
            .padding(.top, 6)

            // (선택) 트리거 예시 태그
            HStack(spacing: 6) {
                Tag("대포통장")
                Tag("피의자")
                Tag("혐의자")
            }
            .padding(.top, 2)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
    }

    // 얇은 회색 바 한 줄
    @ViewBuilder
    private func skeletonLine(width: CGFloat? = nil) -> some View {
        RoundedRectangle(cornerRadius: 4, style: .continuous)
            .fill(Color.black.opacity(0.08))
            .frame(width: width, height: 10)
    }
}

// 작은 캡슐 태그
private struct Tag: View {
    let text: String
    init(_ text: String) { self.text = text }
    var body: some View {
        Text(text)
            .font(.caption)
            .padding(.vertical, 4)
            .padding(.horizontal, 8)
            .background(
                Capsule().fill(Color.gray.opacity(0.12))
            )
            .overlay(
                Capsule().stroke(Color.gray.opacity(0.25), lineWidth: 0.5)
            )
            .foregroundStyle(.secondary)
    }
}


#Preview { ScriptView() }
