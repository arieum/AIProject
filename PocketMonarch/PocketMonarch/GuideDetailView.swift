import SwiftUI

struct GuideDetailView: View {
    @Environment(\.openURL) private var openURL
    @State private var showToast = false

    // POSCO-ish 컬러 팔레트
    private let brand = Color(red: 0.06, green: 0.34, blue: 0.65)        // #1058A6
    private let brand2 = Color(red: 0.12, green: 0.50, blue: 1.00)       // #1E80FF
    private let card1 = Color(.sRGB, red: 0.07, green: 0.09, blue: 0.13, opacity: 1)
    private let card2 = Color(.sRGB, red: 0.04, green: 0.06, blue: 0.12, opacity: 1)

    var body: some View {
        ZStack {
            // 배경
            LinearGradient(
                colors: [Color(.sRGB, red: 0.93, green: 0.96, blue: 0.99, opacity: 1), .white],
                startPoint: .topLeading, endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            ScrollView {
                VStack(alignment: .leading, spacing: 16) {

                    // HERO
                    VStack(alignment: .leading, spacing: 10) {
                        Label("위협형 보이스피싱 경보", systemImage: "triangle.exclamation.fill")
                            .font(.caption).bold()
                            .padding(.vertical, 6)
                            .padding(.horizontal, 10)
                            .background(.white.opacity(0.2), in: Capsule())
                            .foregroundStyle(.white)

                        Text("“발설하면 가중처벌” 협박 전화, 이렇게 대응하세요")
                            .font(.system(size: 26, weight: .bold))
                            .foregroundStyle(.white)

                        Text("수사기관 사칭 전형 수법입니다. \n끊기 → 공유 → 신고 3단계로 즉시 대응하세요.")
                                .foregroundStyle(.white.opacity(0.95))
                    }
                    .padding(20)
                    .frame(maxWidth: .infinity)
                    .background(
                        LinearGradient(colors: [brand, brand2], startPoint: .topLeading, endPoint: .bottomTrailing)
                    )
                    .cornerRadius(20)
                    .shadow(color: brand.opacity(0.25), radius: 16, y: 6)

                    // 받은 문장 예시
                    HStack(alignment: .top, spacing: 12) {
                        Image(systemName: "info.circle")
                            .font(.title3)
                            .foregroundStyle(.primary.opacity(0.8))
                        VStack(alignment: .leading, spacing: 8) {
                            Text("의심되는 문장")
                                .font(.caption).bold()
                                .padding(.vertical, 4)
                                .padding(.horizontal, 10)
                                .background(Color.green.opacity(0.12), in: Capsule())
                                .foregroundStyle(Color.green)

                            Text("""
                            지금 현재 **혐의자 신분**이기 때문에 사건에 대해서 **유출하면 안된다**는 겁니다. 발설하면 **가중처벌**은 당연한거고 당신이 발설한 그 사람들도 **같이 처벌** 받아요. 이해하셨죠?
                            """)
                                .font(.callout)
                                .foregroundStyle(.primary)
                        }
                    }
                    .padding(16)
                    .frame(maxWidth: .infinity)
                    .background(roundedCard())
                    .overlay(roundedStroke())

                    Divider().opacity(0.2)

                    // 기존:
                    // LazyVGrid(columns: [.init(.flexible()), .init(.flexible()), .init(.flexible())], spacing: 12) {

                    // 변경:
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 220), spacing: 12)], spacing: 12) {
                        StepCard(step: "STEP 1", title: "바로 끊기", points: [
                            "통화 종료 후 재통화·문자 응대 금지",
                            "수사기관은 전화로 ‘발설 금지/가중처벌’을 강요하지 않음"
                        ], tint: brand, icon: "phone.down.fill")

                        StepCard(step: "STEP 2", title: "주변과 공유", points: [
                            "가족·직장 동료에게 즉시 알리기",
                            "대화 내용 캡처·녹취 등 증거 보존"
                        ], tint: brand, icon: "person.2.fill")

                        StepCard(step: "STEP 3", title: "112 신고 & 기관 확인", points: [
                            "112(경찰), 1332(금감원) 공식번호로 문의",
                            "안전계좌 송금 요구는 100% 사기"
                        ], tint: brand, icon: "shield.lefthalf.fill")
                    }


                    Divider().opacity(0.2)

                    // 도구 & 체크리스트
                    VStack(spacing: 16) {
                        // 체크리스트
                        VStack(alignment: .leading, spacing: 10) {
                            Text("증거 저장 체크리스트")
                                .font(.headline)
                            VStack(alignment: .leading, spacing: 8) {
                                bullet("전화번호·발신자명 캡처")
                                bullet("통화 녹취 파일(가능한 경우)")
                                bullet("문자/메신저 대화 캡처")
                                bullet("이체 요구 계좌번호·링크 캡처")
                            }
                            Button {
                                UIPasteboard.general.string =
                                """
                                ■ 증거 저장 체크리스트
                                - 발신 번호/이름 캡처
                                - 통화 녹취 파일
                                - 문자/메신저 대화 캡처
                                - 요구 계좌번호/링크 캡처
                                """
                                withAnimation { showToast = true }
                                DispatchQueue.main.asyncAfter(deadline: .now() + 1.6) {
                                    withAnimation { showToast = false }
                                }
                            } label: {
                                Label("체크리스트 복사", systemImage: "doc.on.doc.fill")
                            }
                            .buttonStyle(ModernButtonStyle(tint: brand))
                            .padding(.top, 4)

                            Text("복사 후 메모앱에 붙여넣어 보관하세요.")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                        .padding(16)
                        .background(roundedCard())
                        .overlay(roundedStroke())

                        // 절대 하지 말아야 할 행동
                        VStack(alignment: .leading, spacing: 10) {
                            Text("절대 하지 말아야 할 행동")
                                .font(.headline)
                            VStack(alignment: .leading, spacing: 8) {
                                bullet("주민번호·계좌·앱 비밀번호·인증번호 제공")
                                bullet("원격제어 앱 설치(예: ‘업무지원’, ‘안전점검’ 등)")
                                bullet("안전계좌·검증계좌 송금, QR/링크 클릭")
                            }
                            DisclosureGroup {
                                Text("검찰·경찰·금감원은 전화로 금전 이체를 요구하거나 발설 금지를 강요하지 않습니다. 수사 공식 통지는 서면·방문·대표번호 재통화 등 절차를 따릅니다.")
                                    .font(.footnote)
                                    .foregroundStyle(.secondary)
                                    .padding(.top, 6)
                            } label: {
                                Text("왜? 수사기관은 돈을 받지 않습니다")
                                    .font(.subheadline).bold()
                            }
                            .tint(brand)
                        }
                        .padding(16)
                        .background(roundedCard())
                        .overlay(roundedStroke())
                    }

                    Divider().opacity(0.2)

                    // 유용한 바로가기
                    VStack(alignment: .leading, spacing: 8) {
                        Text("공식 연락처")
                            .font(.headline)
                        HStack(spacing: 12) {
                            Link("112 (경찰)", destination: URL(string: "tel:112")!)
                            Text("·")
                            Link("1332 (금감원)", destination: URL(string: "tel:1332")!)
                        }
                        .foregroundStyle(brand)
                    }
                    .padding(16)
                    .background(roundedCard())
                    .overlay(roundedStroke())

                }
                .padding(16)
                .navigationTitle("대처 가이드")
                .navigationBarTitleDisplayMode(.inline)
            }
            // 하단 고정 CTA
            .safeAreaInset(edge: .bottom) {
                VStack {
                    HStack(spacing: 12) {
                        Button {
                            // 통화 종료 안내 토스트
                            withAnimation { showToast = true }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.6) {
                                withAnimation { showToast = false }
                            }
                        } label: {
                            Label("통화 종료", systemImage: "phone.down.fill")
                        }
                        .buttonStyle(ModernButtonStyle(tint: .red))

                        Button {
                            openURL(URL(string: "tel:112")!)
                        } label: {
                            Label("112 신고", systemImage: "phone.fill")
                        }
                        .buttonStyle(ModernButtonStyle(tint: brand))
                    }
                    .padding(.horizontal)
                    .padding(.top, 8)
                    .padding(.bottom, 12)
                    .background(.ultraThinMaterial)
                }
            }

            // 토스트
            if showToast {
                Text("복사 완료!")
                    .font(.footnote)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(.black.opacity(0.9), in: RoundedRectangle(cornerRadius: 10))
                    .overlay(RoundedRectangle(cornerRadius: 10).stroke(.white.opacity(0.08), lineWidth: 1))
                    .foregroundStyle(.white)
                    .transition(.opacity.combined(with: .move(edge: .bottom)))
                    .shadow(radius: 10)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
                    .padding(.bottom, 88)
            }
        }
    }

    /// MARK: - UI Helpers
    private func roundedCard() -> some View {
        Color.white
            .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
    }
    private func roundedStroke() -> some View {
        RoundedRectangle(cornerRadius: 18, style: .continuous)
            .stroke(Color.black.opacity(0.08), lineWidth: 1) // 라이트 그레이 테두리
    }
    private func bullet(_ text: String) -> some View {
        HStack(alignment: .top, spacing: 8) {
            Circle().fill(brand).frame(width: 6, height: 6).padding(.top, 6)
            Text(text).font(.callout).foregroundStyle(.primary) // 자동 다크/라이트 대응
        }
    }
}

struct StepCard: View {
    let step: String
    let title: String
    let points: [String]
    var tint: Color = .blue
    var fixedHeight: CGFloat = 150
    var icon: String = "checkmark.circle.fill"

    var body: some View {
        let stroke = Color.black.opacity(0.08)

        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.title3)
                    .foregroundStyle(tint)
                    .frame(width: 24, height: 24, alignment: .center) // 아이콘 너비 고정

                Text(title)
                    .font(.headline)
                    .foregroundStyle(.primary)
                    .lineLimit(1)
                    .minimumScaleFactor(0.85) // 좁을 때 살짝 줄여서 자르지 않기
            }

            // 포인트 리스트
            VStack(alignment: .leading, spacing: 8) {
                ForEach(points, id: \.self) { p in
                    HStack(alignment: .top, spacing: 8) {
                        Circle().fill(tint).frame(width: 6, height: 6).padding(.top, 6)
                        Text(p)
                            .font(.callout)
                            .foregroundStyle(.secondary)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                }
            }
            .layoutPriority(1) // 내용 우선 배치
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .topLeading)
        .frame(height: fixedHeight) // 카드 높이 통일
        .background(
            Color.white,
            in: RoundedRectangle(cornerRadius: 18, style: .continuous)
        )
        .overlay(
            Text(step)
                .font(.caption).bold()
                .padding(.vertical, 4)
                .padding(.horizontal, 10)
                .background(tint, in: Capsule())
                .foregroundStyle(.white)
                .lineLimit(1)
                .minimumScaleFactor(0.8),
            alignment: .topTrailing
        )
        .overlay(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .stroke(stroke, lineWidth: 1)
        )
        .shadow(color: Color.black.opacity(0.05), radius: 4, y: 2)
        .clipped() // 오버레이가 카드 밖으로 삐져나오지 않게
    }
}




#Preview { GuideDetailView() }
