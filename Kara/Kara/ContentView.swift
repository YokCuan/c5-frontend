import SwiftUI
import UserNotifications

struct ContentView: View {
    var body: some View {
        MainTabView()
            .onAppear{
                requestNotificationPermission()
            }
    }
    
    func requestNotificationPermission(){
        UNUserNotificationCenter
            .current()
            .requestAuthorization(
                options: [.alert, .sound, .badge])
        {
            granted, error in
            if granted{
                print("Izin diberikan")
            } else{
                print("Izin ditolak")
            }
        }
    }
}
