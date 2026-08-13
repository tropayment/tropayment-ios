import SwiftUI

struct DashboardPlaceholderView: View {
    var body: some View {
        EmptyStateView(
            title: "tab.dashboard",
            message: "placeholder.coming_phase_3",
            systemImage: "chart.bar.fill"
        )
        .navigationTitle(String(localized: "tab.dashboard"))
    }
}
