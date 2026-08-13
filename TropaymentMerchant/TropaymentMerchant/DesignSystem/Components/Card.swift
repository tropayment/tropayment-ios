import SwiftUI

struct Card<Content: View>: View {
    @Environment(\.colorScheme) private var colorScheme
    let content: Content

    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    var body: some View {
        content
            .padding(TropaymentSpacing.md)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                RoundedRectangle(cornerRadius: TropaymentSpacing.cornerRadiusLarge, style: .continuous)
                    .fill(TropaymentColors.surface(for: colorScheme))
                    .shadow(color: .black.opacity(colorScheme == .dark ? 0.25 : 0.06), radius: 12, y: 4)
            )
            .overlay(
                RoundedRectangle(cornerRadius: TropaymentSpacing.cornerRadiusLarge, style: .continuous)
                    .stroke(TropaymentColors.border, lineWidth: 1)
            )
    }
}
