import SwiftUI

struct PaymentProductItemView: View {
    let line: CartLine

    var body: some View {
        HStack(spacing: 14) {
            Group {
                if let urlStr = line.imageUrl, let url = URL(string: urlStr) {
                    AsyncImage(url: url) { phase in
                        switch phase {
                        case .success(let image):
                            image
                                .resizable()
                                .scaledToFill()
                        default:
                            placeholderIcon
                        }
                    }
                } else {
                    placeholderIcon
                }
            }
            .frame(width: 54, height: 54)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(.systemGray6))
            )

            VStack(alignment: .leading, spacing: 4) {
                Text(line.productTitle)
                    .font(.system(size: 14, weight: .bold, design: .rounded))
                    .foregroundColor(.black)
                    .lineLimit(1)
                Text("\(line.variantTitle)  •  Qty: \(line.quantity)")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(.gray)
            }

            Spacer()

            Text(line.price)
                .font(.system(size: 15, weight: .heavy, design: .rounded))
                .foregroundColor(.black)
        }
        .padding(.vertical, 12)
        .background(Color.white)
    }

    private var placeholderIcon: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.systemGray6))
            Image(systemName: "bag.fill")
                .foregroundColor(.gray.opacity(0.6))
                .font(.system(size: 20))
        }
    }
}
