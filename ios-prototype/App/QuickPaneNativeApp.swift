import SwiftUI

@main
struct QuickPaneNativeApp: App {
    var body: some Scene {
        WindowGroup {
            QuickPaneWebView()
                .ignoresSafeArea()
        }
    }
}
