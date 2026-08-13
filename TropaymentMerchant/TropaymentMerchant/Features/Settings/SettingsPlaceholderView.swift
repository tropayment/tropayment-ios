import SwiftUI

struct SettingsPlaceholderView: View {
    @EnvironmentObject private var session: AppSession
    let user: MerchantUser

    var body: some View {
        List {
            Section {
                VStack(alignment: .leading, spacing: TropaymentSpacing.xxs) {
                    Text(user.displayName)
                        .font(TropaymentTypography.headline())
                    Text(user.email)
                        .font(TropaymentTypography.caption())
                        .foregroundStyle(TropaymentColors.textSecondary)
                }
                .padding(.vertical, TropaymentSpacing.xs)
            }

            Section {
                Button(role: .destructive) {
                    Task { await session.signOut() }
                } label: {
                    Text("auth.sign_out")
                }
            }
        }
        .navigationTitle(String(localized: "tab.settings"))
    }
}
