import SwiftUI

@main
struct CryptoTrackerApp: App {
    @StateObject private var coinMgr = HomeViewModel()

    init() {
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor(Color.theme.accent)]
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor(Color.theme.accent)]
    }

    var body: some Scene {
        WindowGroup {
            NavigationView {
                HomeView()
                  .navigationBarHidden(true)
            }
              .environmentObject(coinMgr)
        }
    }
}
