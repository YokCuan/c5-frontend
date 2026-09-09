import SwiftUI

@main
struct KaraApp: App {
    @StateObject private var categoryStore = CategoryStore.shared
    @State private var showSplash = true
    
    var body: some Scene {
        WindowGroup {
            if showSplash {
                SplashView {
                    showSplash = false
                }
            } else {
                ContentView()
                    .preferredColorScheme(.light)
                    .environmentObject(categoryStore)
                    .task {
                        await CategoryStore.shared.fetchCategoriesIfNeeded()
                    }
            }
        }
    }
}

//modifier to make every keyboard auto-dismiss
//    .contentShape(Rectangle())
//    .onTapGesture {
//        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
//    }
