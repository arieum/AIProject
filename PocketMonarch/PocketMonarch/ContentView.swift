import SwiftUI

struct ContentView: View {
    @StateObject private var appState = AppState()
    
    var body: some View {
        NavigationStack {
            VStack {
                ScriptView()
                ProbChartView()
                GuideView()
            }
            .padding()
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    HStack(spacing: 6) {
                        Image(systemName: "shield.lefthalf.fill")
                        Text("POPIPOPI")
                            .font(.headline).bold()
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Image(systemName: "gearshape")
                }
            }
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbarBackground(Color(.systemBackground), for: .navigationBar)
        }
        .environmentObject(appState)
    }
}

#Preview { ContentView() }
