//
//  FinderView.swift
//  AnimeRepo
//
//  Created by Shirley Averette on 6/18/24.
//

import SwiftUI

struct FinderView: View {
    
    @EnvironmentObject var animevm: AnimeViewModel
    @EnvironmentObject var appAuth: AuthViewModel
    
    var body: some View {
        
        NavigationView {
            VStack {
                    
                    let anime = animevm.currentAnime
                    
                    VStack {
                        Text(anime.title)
                            .foregroundColor(.black)
                            .font(.title2)
                            .bold()
                            .padding()
                            .frame(maxWidth: UIScreen.main.bounds.width - 20)
                            .background(
                                RoundedRectangle(cornerRadius: 0)
                                    .fill(Color.green)
                            )
                        Spacer()
                        NavigationLink(destination: AnimeDetailView(anime: anime, sender: "FinderView").environmentObject(animevm).environmentObject(appAuth)) {
                            AsyncImage(url: URL(string: anime.images.jpg.image_url)) { image in
                                image.resizable()
                                    .aspectRatio(contentMode: .fit)
                            } placeholder: {
                                ProgressView()
                            }.padding()
                        } 
                    
                        HStack {
                            Button("Watching") {
                                if animevm.canSave {
                                    animevm.addToWatchingList(anime: anime)
                                }
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
                            
                            Button("Completed") {
                                if animevm.canSave {
                                    animevm.addToCompletedList(anime: anime)
                                }
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
                        }.padding()
                        
                        HStack{
                            Button("Ignore") {
                                if animevm.canSave {
                                    animevm.addToIgnoreList(anime: anime)
                                }
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
                            Button("Plan to watch") {
                                if animevm.canSave {
                                    animevm.addToWaitList(anime: anime)
                                }
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
            .onAppear() {
                //self.animevm.fetchData()
                print("FinderView - uid: \(appAuth.session!.uid) IgnoreCount: \(appAuth.userInstance.ignoreList.count)")
            }
        }
    }
}

#Preview {
    FinderView()
}
