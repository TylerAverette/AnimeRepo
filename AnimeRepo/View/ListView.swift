//
//  ListView.swift
//  AnimeRepo
//
//  Created by Shirley Averette on 6/24/24.
//

import SwiftUI

struct ListView: View {

    var listName: String
    var listToDisplay : [AnimeModel]
    @EnvironmentObject var animevm: AnimeViewModel
    @EnvironmentObject var appAuth: AuthViewModel
    
    var body: some View {
        NavigationView {
            List(listToDisplay) { anime in
                NavigationLink(destination: AnimeDetailView(anime: anime, sender: "ListView", curr: listName).environmentObject(animevm)
                    .environmentObject(appAuth), label: {
                    Text(anime.title)
                })
            }
            .navigationTitle(listName)
        }
    }
}

#Preview {
    ListView(listName: "Watching", listToDisplay: [])
}
