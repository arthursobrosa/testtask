import Colors
import Fonts
import SwiftUI

// View displayed when there are no users to show
struct NoUsersView: View {
    var body: some View {
        VStack(spacing: 24) {
            Image(.noUsers)
                .resizable()
                .scaledToFit()
                .padding(.horizontal, 79.5)
            
            Text("There are no users yet")
                .font(.nunito(size: 20, weight: .regular))
                .foregroundStyle(Color.black87)
        }
    }
}

#Preview {
    NoUsersView()
}
