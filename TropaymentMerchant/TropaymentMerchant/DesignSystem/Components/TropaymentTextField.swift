import SwiftUI

struct TropaymentTextField: View {
    let title: LocalizedStringKey
    @Binding var text: String
    var prompt: LocalizedStringKey?
    var errorMessage: String?
    var keyboardType: UIKeyboardType = .default
    var textContentType: UITextContentType?
    var isSecure: Bool = false

    @Environment(\.colorScheme) private var colorScheme
    @FocusState private var isFocused: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: TropaymentSpacing.xs) {
            Text(title)
                .font(TropaymentTypography.caption())
                .foregroundStyle(TropaymentColors.textSecondary)

            Group {
                if isSecure {
                    SecureField(String(localized: title), text: $text)
                } else {
                    TextField(String(localized: title), text: $text, prompt: prompt.map { Text($0) })
                        .keyboardType(keyboardType)
                        .textContentType(textContentType)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
                }
            }
            .font(TropaymentTypography.body())
            .padding(.horizontal, TropaymentSpacing.md)
            .frame(height: TropaymentSpacing.buttonHeight)
            .background(
                RoundedRectangle(cornerRadius: TropaymentSpacing.cornerRadius, style: .continuous)
                    .fill(TropaymentColors.surface(for: colorScheme))
            )
            .overlay(
                RoundedRectangle(cornerRadius: TropaymentSpacing.cornerRadius, style: .continuous)
                    .stroke(borderColor, lineWidth: isFocused ? 2 : 1)
            )
            .focused($isFocused)

            if let errorMessage, !errorMessage.isEmpty {
                Text(errorMessage)
                    .font(TropaymentTypography.caption())
                    .foregroundStyle(TropaymentColors.danger)
            }
        }
    }

    private var borderColor: Color {
        if errorMessage != nil { return TropaymentColors.danger }
        if isFocused { return TropaymentColors.brandPrimary }
        return TropaymentColors.border
    }
}
