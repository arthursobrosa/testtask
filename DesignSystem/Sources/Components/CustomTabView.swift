import SwiftUI

// Struct that defines a custom tab item with a tag, title, and image.
public struct CustomTabItem {
    let tag: Int
    let title: Text
    let image: Image
    
    public init(tag: Int, title: Text, image: Image) {
        self.tag = tag
        self.title = title
        self.image = image
    }
}

// CustomTabView is a SwiftUI view that allows you to create a tab view with custom items and content.
public struct CustomTabView<Content: View>: View {
    let tabs: [CustomTabItem]       // Array of tab items
    @Binding var selection: Int     // Binding tracking selected tab
    let content: () -> Content      // Closure to define the view above the tab bar
    
    public init(
        tabs: [CustomTabItem],
        selection: Binding<Int>,
        content: @escaping () -> Content
    ) {
        self.tabs = tabs
        self._selection = selection
        self.content = content
    }

    public var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                content()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                
                // Light grey back ground overlayed by two tabs horizontally aligned
                Color.lightGrey
                    .frame(width: geometry.size.width, height: geometry.size.height * (56 / 640) + geometry.safeAreaInsets.bottom)
                    .overlay(
                        HStack {
                            ForEach(tabs, id: \.tag) { tab in
                                // Forces icon and label to be horizontally aligned (different from native behaviour)
                                HStack {
                                    tab.image
                                    tab.title
                                }
                                .foregroundColor(selection == tab.tag ? Color.oceanBlue : Color.black60)
                                .frame(maxWidth: .infinity)
                                .onTapGesture {
                                    selection = tab.tag
                                }
                            }
                        }
                        .padding(.bottom, geometry.safeAreaInsets.bottom)
                    )
            }
            .edgesIgnoringSafeArea(.bottom) // Ignores bottom safe area to make tab bar go all the way to the bottom
        }
    }
}
