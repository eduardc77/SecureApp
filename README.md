# SecureApp

Example App to test security features.









import SwiftUI

struct LabeledViewModifier: ViewModifier {
   var header: String?
   var headerFont: Font = .caption
   var headerColor: Color = .secondaryTextColor
   var footer: String?
   var footerFont: Font = .caption
   var footerColor: Color = .secondaryTextColor
   var alignment: HorizontalAlignment
   var spacing: Spacing

   var accessibilityHeaderText: String {
      guard let header = header else { return "" }
      let accessibilityHeader: String = header.capitalizedNoSpace
         return accessibilityHeader
   }

   var accessibilityFooterText: String {
      guard let footer = footer else { return "" }
      let accessibilityFooter: String = footer.capitalizedNoSpace
         return accessibilityFooter
   }

   func body(content: Content) -> some View {
      VStack(alignment: alignment, spacing: spacing.v) {
         Section {
            content

         } header: {
            if let header = header {
               Text(header)
                  .font(headerFont)
                  .accessibility(identifier: "\(accessibilityHeaderText)Txt", traits: [.isStaticText, .isHeader])
                  .foregroundColor(headerColor)
                  .padding(.leading, spacing: Spacing.xs)
            }

         } footer: {
            if let footer = footer {
               Text(footer)
                  .font(footerFont)
                  .accessibility(identifier: "\(accessibilityFooterText)Txt", traits: .isStaticText)
                  .foregroundColor(footerColor)
                  .padding(.leading, spacing: Spacing.xs)
            }
         }
      }
   }
}

extension View {
   func labeledViewModifier(header: String? = nil, headerFont: Font = .caption, headerColor: Color = .secondaryTextColor, footer: String? = nil, footerFont: Font = .caption, footerColor: Color = .secondaryTextColor, alignment: HorizontalAlignment = .leading, spacing: Spacing = .small) -> some View {
      modifier(LabeledViewModifier(header: header, headerFont: headerFont, headerColor: headerColor, footer: footer, footerFont: footerFont, footerColor: footerColor, alignment: alignment, spacing: spacing))
   }
}


// MARK: - Previews

struct LabelTextFieldModifier_Previews: PreviewProvider {
   struct LabelTextFieldView: View {
      @State var text: String = ""

      var body: some View {
         VStack {
            TextField("Placeholder", text: $text)
               .textFieldStyle(.mainTextFieldStyle)
               .labeledViewModifier(header: "Your Account Number with Provider *", footer: "Strongly recommended")
         }
      }
   }

   static var previews: some View {
      LabelTextFieldView()
         .padding()
   }
}
