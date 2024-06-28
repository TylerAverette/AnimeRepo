//
//  AnimeDetailView.swift
//  AnimeRepo
//
//  Created by Shirley Averette on 6/17/24.
//

import SwiftUI

struct AnimeDetailView: View {
    var anime: AnimeModel
    var sender: String
    var curr: String?
    @EnvironmentObject var animevm: AnimeViewModel
    @EnvironmentObject var appAuth: AuthViewModel
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        AsyncImage(url: URL(string: anime.images.jpg.image_url)) { image in
            image.resizable()
                .aspectRatio(contentMode: .fit)
        } placeholder: {
            ProgressView()
        }
        Text(anime.title)
            .font(.title)
        ScrollView {
            Text(anime.synopsis)
                .padding()
        }
        if sender == "ListView" {
            HStack {
                Button("To Watching") {
//                    animevm.addToWatchingList(anime: anime)
                    self.animevm.switchLists(anime: self.anime, currentList: self.curr!, newList: "watchingList")
                    presentationMode.wrappedValue.dismiss()
                }
                .foregroundColor(.black)
                .font(.title2)
                .bold()
                .padding()
                .frame(maxWidth: UIScreen.main.bounds.width - 20)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.blue)
                )
                
                Spacer()
                
                Button("To Completed") {
//                    animevm.addToCompletedList(anime: anime)
                    self.animevm.switchLists(anime: self.anime, currentList: self.curr!, newList: "completedList")
                    presentationMode.wrappedValue.dismiss()
                }
                .foregroundColor(.black)
                .font(.title2)
                .bold()
                .padding()
                .frame(maxWidth: UIScreen.main.bounds.width - 20)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.green)
                )
            }.padding().frame(maxHeight: 50)
            
            HStack{
                Button("To Ignore") {
//                    animevm.addToIgnoreList(anime: anime)
                    self.animevm.switchLists(anime: self.anime, currentList: self.curr!, newList: "ignoreList")
                    presentationMode.wrappedValue.dismiss()
                }
                .foregroundColor(.black)
                .font(.title2)
                .bold()
                .padding()
                .frame(maxWidth: UIScreen.main.bounds.width - 20)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.red)
                )
                Spacer()
                Button("To Plan") {
//                    animevm.addToWaitList(anime: anime)
                    self.animevm.switchLists(anime: self.anime, currentList: self.curr!, newList: "waitingList")
                    presentationMode.wrappedValue.dismiss()
                }
                .foregroundColor(.black)
                .font(.title2)
                .bold()
                .padding()
                .frame(maxWidth: UIScreen.main.bounds.width - 20)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.yellow)
                )
            }.padding()        
        }
    }
}

//#Preview {
//    AnimeDetailView(anime: AnimeModel(
//        mal_id: 000,
//        title: "Hunter x Hunter",
//        synopsis: "Hunters devote themselves to accomplishing hazardous tasks, all from traversing the world's uncharted territories to locating rare items and monsters. Before becoming a Hunter, one must pass the Hunter Examination—a high-risk selection process in which most applicants end up handicapped or worse, deceased.\n\nAmbitious participants who challenge the notorious exam carry their own reason. What drives 12-year-old Gon Freecss is finding Ging, his father and a Hunter himself. Believing that he will meet his father by becoming a Hunter, Gon takes the first step to walk the same path.\n\nDuring the Hunter Examination, Gon befriends the medical student Leorio Paladiknight, the vindictive Kurapika, and ex-assassin Killua Zoldyck. While their motives vastly differ from each other, they band together for a common goal and begin to venture into a perilous world.\n\n[Written by MAL Rewrite]",
//        images: ImageList(jpg: Image(
//            image_url: "https://cdn.myanimelist.net/images/anime/1337/99013.jpg",
//            small_image_url: "https://cdn.myanimelist.net/images/anime/1337/99013t.jpg",
//            large_image_url: "https://cdn.myanimelist.net/images/anime/1337/99013l.jpg" ) )), sender: "FinderView")
//}
