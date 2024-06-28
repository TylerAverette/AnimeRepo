//
//  MainView.swift
//  AnimeRepo
//
//  Created by Shirley Averette on 6/17/24.
//

import SwiftUI

struct MainView: View {
    
    @EnvironmentObject var animevm: AnimeViewModel
    @EnvironmentObject var appAuth: AuthViewModel
    @Binding var username: String
    
    var body: some View {
        TabView {
            VStack {
                if self.animevm.currentAnime.mal_id != 00 {
                    FinderView()
                        .environmentObject(animevm)
                        .environmentObject(appAuth)
                } else {
                    LoadingScreen()
                }
            }.tabItem {
                Label("Anime List", systemImage: "1.circle")
            }
            
            ListView(listName: "Completed", listToDisplay: appAuth.userInstance.completedList)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .tabItem{
                    Label("Completed", systemImage: "2.circle")
                }
                .environmentObject(animevm)
                .environmentObject(appAuth)
         
            ListView(listName: "Ignore", listToDisplay: appAuth.userInstance.ignoreList)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .tabItem{
                    Label("Ignore", systemImage: "3.circle")
                }
                .environmentObject(animevm)
                .environmentObject(appAuth)
            
            ListView(listName: "Watching", listToDisplay: appAuth.userInstance.watchingList)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .tabItem{
                    Label("Watching", systemImage: "4.circle")
                }
                .environmentObject(animevm)
                .environmentObject(appAuth)
           
            ListView(listName: "Plan to Watch", listToDisplay: appAuth.userInstance.waitingList)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .tabItem{
                    Label("Plan to watch", systemImage: "5.circle")
                }
                .environmentObject(animevm)
                .environmentObject(appAuth)
            
        }
        .onAppear() {
            print("MainView: uid: \(appAuth.session!.uid) IgnoreCount: \(appAuth.userInstance.ignoreList.count)")
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button("Sign Out") {
                    appAuth.SignOut()
                }
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                Text(username)
            }
        }
    }
}

#Preview {
    MainView(username: .constant("username"))
}
