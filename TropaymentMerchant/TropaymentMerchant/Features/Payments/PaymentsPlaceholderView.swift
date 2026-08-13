import SwiftUI

struct PaymentsPlaceholderView: View {
    var body: some View {
        EmptyStateView(
            title: "tab.payments",
            message: "placeholder.coming_phase_4",
            systemImage: "doc.text.fill"
        )
        .navigationTitle(String(localized: "tab.payments"))
    }
}
