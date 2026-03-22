import SwiftUI
import StoreKit

@main
struct ZeroLineApp: App {

    @Environment(\.scenePhase) private var scenePhase

    var body: some Scene {
        WindowGroup {
            ZeroLineView()
                .onChange(of: scenePhase) { _, phase in
                    guard phase == .active else { return }
                    scheduleReviewPrompt()
                }
        }
    }

    private func scheduleReviewPrompt() {
        let randomDelay = Double.random(in: 4...9)
        DispatchQueue.main.asyncAfter(deadline: .now() + randomDelay) {
            guard let activeScene = UIApplication.shared.connectedScenes
                .compactMap({ $0 as? UIWindowScene })
                .first(where: { $0.activationState == .foregroundActive }) else {
                return
            }
            SKStoreReviewController.requestReview(in: activeScene)
        }
    }
}
