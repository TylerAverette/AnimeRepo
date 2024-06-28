//
//  AnimeViewModel.swift
//  AnimeRepo
//
//  Created by Shirley Averette on 6/17/24.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift
import SwiftUI

class AnimeViewModel : ObservableObject {
    @Published var animeData = [AnimeModel]()
    @Published var currentIndex: Int = 0
    @Published var currentAnime = AnimeModel(mal_id: 00, title: "", synopsis: "", images: ImageList(jpg: Image(image_url: "", small_image_url: "", large_image_url: "")))
    @Published var page = 1
    @Published var canSave: Bool = true
    var appAuth: AuthViewModel?
    private var animeURL = "https://api.jikan.moe/v4/top/anime"
    let db = Firestore.firestore()
    
    
    
    func fetchData() {
        // Verify valid url
        guard let url = URL(string: "\(animeURL)?page=\(appAuth!.userInstance.page)&limit=25" ) else {
            print("Invalid URL")
            return
        }
        
        // Request Data
        URLSession.shared.dataTask(with: url) {data, response, error in
            if let error = error {
                print("error: \(error)")
                return
            }
            
            // Verify data
            guard let data = data else {
                print("No data")
                return
            }
            
            // Retrieve Data
            do {
                let results = try JSONDecoder().decode(DataModel.self, from: data)
                self.animeData = results.data
                self.nextAnime()
            } catch {
                print(error)
            }
        }.resume()
    }
    
    func addToWaitList(anime: AnimeModel) {
        self.appAuth?.userInstance.waitingList.append(anime)
        self.updateUserFields()
    }
    
    func addToWatchingList(anime: AnimeModel) {
        self.appAuth?.userInstance.watchingList.append(anime)
        self.updateUserFields()
    }
    
    func addToCompletedList(anime: AnimeModel) {
        self.appAuth?.userInstance.completedList.append(anime)
        self.updateUserFields()
    }
    
    func addToIgnoreList(anime: AnimeModel) {
        self.appAuth?.userInstance.ignoreList.append(anime)
        self.updateUserFields()
    }
    
    // When an anime is in a list, this segment allows the user to move it to another list
    func switchLists(anime: AnimeModel, currentList: String, newList: String) {
        switch currentList {
            case "Plan to Watch":
                if let index = self.appAuth?.userInstance.waitingList.firstIndex(of: anime) {
                    self.appAuth?.userInstance.waitingList.remove(at: index)
                    self.updateUserFields()
                }
            case "Completed":
                if let index = self.appAuth?.userInstance.completedList.firstIndex(of: anime) {
                    self.appAuth?.userInstance.completedList.remove(at: index)
                    self.updateUserFields()
                }
            case "Ignore":
                if let index = self.appAuth?.userInstance.ignoreList.firstIndex(of: anime) {
                    self.appAuth?.userInstance.ignoreList.remove(at: index)
                    self.updateUserFields()
                }
            case "Watching":
                if let index = self.appAuth?.userInstance.watchingList.firstIndex(of: anime) {
                    self.appAuth?.userInstance.watchingList.remove(at: index)
                    self.updateUserFields()
                }
        default:
            return
        }
        
        switch newList {
            case "waitingList":
                self.appAuth?.userInstance.waitingList.append(anime)
                self.updateUserFields()
            case "completedList":
                self.appAuth?.userInstance.completedList.append(anime)
                self.updateUserFields()
            case "ignoreList":
                self.appAuth?.userInstance.ignoreList.append(anime)
                self.updateUserFields()
            case "watchingList":
                self.appAuth?.userInstance.watchingList.append(anime)
                self.updateUserFields()
            default:
                return
        }
        
    }

    func updateUserFields() {
        self.canSave = false
        if let id = self.appAuth?.session?.uid {
            do {
                try db.collection("userData").document(id).setData(from: self.appAuth?.userInstance) {err in
                    if let err = err {
                        print(err)
                    } else {
                        self.nextAnime()
                        self.appAuth?.populateUser()
                        
                        // Debounce task
                        let task = DispatchWorkItem {[weak self] in
                            DispatchQueue.global(qos: .userInteractive).async { [weak self] in
                                DispatchQueue.main.async {
                                    self?.canSave = true
                                }
                            }
                        }
                        // Execute task after 1 second
                        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.75, execute: task)
                    }
                }
            } catch {
                print(error)
            }
        }
    }
    
    /* This function checks to see if the current anime has been added to a list, if it has increment the anime to display*/
    func nextAnime() {
        repeat {
           
            
            // Checks for first item in data set
            if self.currentIndex < self.animeData.count && isUsed(anime: self.animeData[self.currentIndex]) {
                self.currentIndex += 1 // Moves through data set
            }
            
            // Checks if we have went through an entire page of data, and iterates if so
            if self.currentIndex == 25 {
                self.page += 1
                self.appAuth?.userInstance.page = String(self.page)
                self.currentIndex = 0
                self.fetchData()
                return
            }
            // While checks remaining data
        } while self.currentIndex < self.animeData.count && isUsed(anime: self.animeData[self.currentIndex])
        if self.currentIndex < 25 {
            DispatchQueue.main.async {
                self.currentAnime = self.animeData[self.currentIndex]
            }
        }
        
    }

    /*
        @anime An anime that you want to verify isn't in a list.
        @returns returns a boolean value; true if the anime is in a list, false otherwise
    */
    func isUsed(anime: AnimeModel) -> Bool {
        return  anime.mal_id == 00 ||
                (self.appAuth!.userInstance.watchingList.contains(where: {$0.mal_id == anime.mal_id}) ||
                self.appAuth!.userInstance.waitingList.contains(where: {$0.mal_id == anime.mal_id}) ||
                self.appAuth!.userInstance.ignoreList.contains(where: {$0.mal_id == anime.mal_id}) ||
                self.appAuth!.userInstance.completedList.contains(where: {$0.mal_id == anime.mal_id}))
    }
    
    /* This function is used the access the environment variable values in the model. */
    func setup(appAuth: AuthViewModel) {
        self.appAuth = appAuth
    }
    
}
