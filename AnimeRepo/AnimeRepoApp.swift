//
//  AnimeRepoApp.swift
//  AnimeRepo
//
//  Created by Shirley Averette on 6/17/24.
//
import SwiftUI
import FirebaseCore
import FirebaseAuth

@main
struct AnimeRepoApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject var animevm = AnimeViewModel()
    @StateObject var appAuth = AuthViewModel()
    
    var body: some Scene {
        WindowGroup {
          NavigationView {
              ContentView()
                  .environmentObject(animevm)
                  .environmentObject(appAuth)
          }
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()

    return true
  }
}
