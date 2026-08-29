import SwiftUI

@main
struct KaraApp: App {
    @StateObject private var categoryStore = CategoryStore.shared
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(categoryStore)
                .task {
                    await CategoryStore.shared.fetchCategoriesIfNeeded()
                }
        }
    }
}

//modifier to make every keyboard auto-dismiss
//    .contentShape(Rectangle())
//    .onTapGesture {
//        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
//    }
