import SwiftUI

struct AuthTextField: View {
    let label: LocalizedStringKey
    let placeholder: LocalizedStringKey
    @Binding var text: String
    var error: String?
    var isSecure: Bool = false
    var onFocusLost: (() -> Void)? = nil
    
    @State private var isPasswordVisible: Bool = false
    @FocusState private var isFocused: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(label)
                .font(.system(size: 14, weight: .bold))
                .foregroundColor(.primary)
            
            HStack {
                if isSecure && !isPasswordVisible {
                    SecureField("", text: $text, prompt: Text(placeholder).foregroundColor(.secondary.opacity(0.6)))
                        .tint(Color("PrimaryColor"))
                } else {
                    TextField("", text: $text, prompt: Text(placeholder).foregroundColor(.secondary.opacity(0.6)))
                        .tint(Color("PrimaryColor"))
                }
                
                if isSecure {
                    Button(action: { isPasswordVisible.toggle() }) {
                        Image(systemName: isPasswordVisible ? "eye.fill" : "eye.slash.fill")
                            .foregroundColor(.secondary)
                    }
                }
            }
            .focused($isFocused)
            .font(.system(size: 14))
            .padding(.horizontal, 16)
            .frame(height: 50)
            .background(Color(.secondarySystemGroupedBackground))
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(
                        error != nil ? Color.red : (isFocused ? Color("PrimaryColor") : Color(.systemGray5)),
                        lineWidth: isFocused || error != nil ? 1.5 : 1.0
                    )
            )
            
            if let error {
                Text(error)
                    .font(.caption)
                    .foregroundColor(.red)
                    .padding(.leading, 4)
            }
        }
        .onChange(of: isFocused) { focused in
            guard !focused else { return }
            onFocusLost?()
        }
    }
}

struct CheckboxToggleStyle: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        Button(action: { configuration.isOn.toggle() }) {
            HStack(spacing: 8) {
                Image(systemName: configuration.isOn ? "checkmark.square.fill" : "square")
                    .foregroundColor(configuration.isOn ? Color("PrimaryColor") : .secondary)
                    .font(.system(size: 18))
                configuration.label
            }
        }
        .buttonStyle(PlainButtonStyle())
    }
}
