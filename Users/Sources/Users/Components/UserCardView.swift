import API
import Colors
import Fonts
import SwiftUI

// View that represents a card with user information
struct UserCardView: View {
    // User objects that contains the data to be displayed
    private let user: UserModel
    
    init(user: UserModel) {
        self.user = user
    }
    
    var body: some View {
        // Align image and text horizontally
        HStack(alignment: .top, spacing: 16) {
            // User image to the left
            user.image()
                .resizable()
                .scaledToFit()
                .clipShape(Circle())
                .frame(width: UIScreen.main.bounds.width * 50/360)
                .padding(.leading, 16)
            
            // Text information (vertical) to the right
            VStack(alignment: .leading, spacing: 0) {
                Text(user.name)
                    .font(.nunito(size: 18, weight: .regular))
                    .foregroundStyle(Color.black87)
                    .padding(.bottom, 4)
                
                Text(user.position)
                    .font(.nunito(size: 14, weight: .regular))
                    .foregroundStyle(Color.black60)
                    .padding(.bottom, 8)
                
                Text(user.email)
                    .font(.nunito(size: 14, weight: .regular))
                    .foregroundStyle(Color.black87)
                    .padding(.bottom, 4)
                
                Text(user.formattedPhone())
                    .font(.nunito(size: 14, weight: .regular))
                    .foregroundStyle(Color.black87)
                    .padding(.bottom, 23)
                
                // Custom divider
                Rectangle()
                    .frame(height: 1)
                    .foregroundStyle(.black.opacity(0.12))
            }
            
            Spacer()
        }
        .padding(.trailing, 16)
        .padding(.top, 24)
    }
}

#Preview {
    let user = UserModel(
        name: "Arthur Pinto Sobrosa Lopes",
        email: "arthurpsl99@gmail.com",
        phone: "+55 51 998855392",
        position: "iOS Developer"
    )
    
    UserCardView(user: user)
}
