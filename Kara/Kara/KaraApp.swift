import SwiftUI

@main
struct KaraApp: App {
    init() {
        // TODO: FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

//modifier to make every keyboard auto-dismiss
//    .contentShape(Rectangle())
//    .onTapGesture {
//        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
//    }
