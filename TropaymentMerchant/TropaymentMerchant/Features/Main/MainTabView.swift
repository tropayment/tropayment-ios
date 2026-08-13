import SwiftUI

struct MainTabView: View {
    let user: MerchantUser

    var body: some View {
        TabView {
            NavigationStack {
                DashboardPlaceholderView()
            }
            .tabItem {
                Label(String(localized: "tab.dashboard"), systemImage: "chart.bar.fill")
            }

            NavigationStack {
                PaymentsPlaceholderView()
            }
            .tabItem {
                Label(String(localized: "tab.payments"), systemImage: "doc.text.fill")
            }

            NavigationStack {
                TransactionsPlaceholderView()
            }
            .tabItem {
                Label(String(localized: "tab.transactions"), systemImage: "list.bullet.rectangle")
            }

            NavigationStack {
                WalletPlaceholderView()
            }
            .tabItem {
                Label(String(localized: "tab.wallet"), systemImage: "wallet.pass.fill")
            }

            NavigationStack {
                SettingsPlaceholderView(user: user)
            }
            .tabItem {
                Label(String(localized: "tab.settings"), systemImage: "gearshape.fill")
            }
        }
        .tint(TropaymentColors.brandPrimary)
    }
}
