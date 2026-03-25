import SwiftUI
import UIKit

struct ActivityViewRepresentable: UIViewControllerRepresentable {
    let activityItems: [Any]
    let applicationActivities: [UIActivity]?
    var excludedActivityTypes: [UIActivity.ActivityType]? = nil
    var onComplete: ((UIActivity.ActivityType?, Bool) -> Void)? = nil

    func makeUIViewController(context: Context) -> UIActivityViewController {
        let controller = UIActivityViewController(
            activityItems: activityItems,
            applicationActivities: applicationActivities
        )
        controller.excludedActivityTypes = excludedActivityTypes
        controller.completionWithItemsHandler = { activityType, completed, _, _ in
            onComplete?(activityType, completed)
        }
        return controller
    }

    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}
