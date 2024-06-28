//
//  ContentView.swift
//  AnimeRepo
//
//  Created by Shirley Averette on 6/17/24.
//

import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject var appAuth: AuthViewModel
    @EnvironmentObject var animevm: AnimeViewModel
    
    var body: some View {
        Group {
                if appAuth.session != nil {
                    MainView(username: .constant(appAuth.session?.email ?? "username"))
                        .environmentObject(appAuth)
                        .environmentObject(animevm)
                        .onAppear() {
                            animevm.setup(appAuth: appAuth)
                            appAuth.setup(animevm: animevm)
                        }
                } else {
                    LoginView()
                        .environmentObject(appAuth)
                        .environmentObject(animevm)
                        .onAppear() {
                            animevm.setup(appAuth: appAuth)
                            appAuth.setup(animevm: animevm)
                        }
                }
        }
    }
}

#Preview {
    ContentView()
}
