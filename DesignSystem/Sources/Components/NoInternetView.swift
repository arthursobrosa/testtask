import SwiftUI

// View displayed when there is no internet connection
public struct NoInternetView: View {
    // Track an attempt to retry the connection
    @Binding private var shouldRetry: Bool
    
    public init(shouldRetry: Binding<Bool>) {
        self._shouldRetry = shouldRetry
    }
    
    public var body: some View {
        VStack(spacing: 24) {
            Image(.noInternet)
                .resizable()
                .scaledToFit()
                .padding(.horizontal, 80)
            
            Text("There is no internet connection")
                .font(.nunito(size: 20, weight: .regular))
                .foregroundStyle(Color.black87)
                .padding(.horizontal)
            
            // Button that triggers the retry logics
            Button("Try again") {
                shouldRetry = true
            }
            .buttonStyle(ActionButtonStyle(.large))
        }
        .navigationBarBackButtonHidden()
    }
}

#Preview {
    NoInternetView(shouldRetry: .constant(false))
}
