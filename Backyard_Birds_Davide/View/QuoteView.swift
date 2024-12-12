import SwiftUI

struct QuoteView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var quote: Quote?
    @State private var isLoading = true
    
    var body: some View {
        VStack {
            if isLoading {
                ProgressView("Loading Quote")
            } else if let quote = quote {
                VStack(spacing: 10) {
                    Text("\"\(quote.quote)\"")
                        .font(.title2)
                        .multilineTextAlignment(.center)
                        .padding()
                    Text("- \(quote.author)")
                        .font(.footnote)
                        .foregroundColor(.secondary)
                }
                .padding()
            } else {
                Text("Failed to load quote. Try again later.")
                    .foregroundColor(.red)
            }
        }
        .onAppear {
            Task {
                await loadQuote()
            }
        }
        Button("Dismiss") {
            dismiss()
        }
    }
    
    private func loadQuote() async {
        isLoading = true
        quote = await QuoteController.fetchRandomQuote()
        isLoading = false
    }
}

#Preview {
    QuoteView()
}
