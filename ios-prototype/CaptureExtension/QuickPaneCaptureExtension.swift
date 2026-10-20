import LockedCameraCapture
import SwiftUI
import UIKit

@main
struct QuickPaneCaptureExtension: LockedCameraCaptureExtension {
    var body: some LockedCameraCaptureExtensionScene {
        LockedCameraCaptureUIScene { session in
            QuickPaneCaptureView(session: session)
        }
    }
}

struct QuickPaneCaptureView: View {
    let session: LockedCameraCaptureSession

    @State private var didAttemptAutomaticLaunch = false
    @State private var status = "Quick Paneを開いています…"

    var body: some View {
        ZStack(alignment: .bottom) {
            CameraPreview()
                .ignoresSafeArea()

            VStack(spacing: 10) {
                Text("Quick Pane")
                    .font(.headline)
                Text(status)
                    .font(.footnote)
                    .multilineTextAlignment(.center)
                Button("Quick Paneを開く") {
                    openMainApp()
                }
                .buttonStyle(.borderedProminent)
            }
            .padding(20)
            .frame(maxWidth: .infinity)
            .background(.ultraThinMaterial)
        }
        .onAppear {
            guard !didAttemptAutomaticLaunch else { return }
            didAttemptAutomaticLaunch = true

            // Experimental: Camera Control launches this capture extension.
            // Attempt to hand off to the containing app immediately. iOS may
            // reject this because Apple documents openApplication(for:) as an
            // interaction-driven transition. The visible button is the fallback.
            Task {
                try? await Task.sleep(nanoseconds: 350_000_000)
                do {
                    try await session.openApplication(
                        for: NSUserActivity(
                            activityType: NSUserActivityTypeLockedCameraCapture
                        )
                    )
                } catch {
                    status = "自動起動できませんでした。下のボタンを押してください。"
                }
            }
        }
    }

    private func openMainApp() {
        Task {
            do {
                try await session.openApplication(
                    for: NSUserActivity(
                        activityType: NSUserActivityTypeLockedCameraCapture
                    )
                )
            } catch {
                status = "起動できませんでした: \(error.localizedDescription)"
            }
        }
    }
}

private struct CameraPreview: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.sourceType = .camera
        picker.mediaTypes = ["public.image"]
        return picker
    }

    func updateUIViewController(
        _ uiViewController: UIImagePickerController,
        context: Context
    ) {}
}
