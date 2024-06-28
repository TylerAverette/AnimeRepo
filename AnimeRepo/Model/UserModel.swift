//
//  AnimeModel.swift
//  AnimeRepo
//
//  Created by Shirley Averette on 6/17/24.
//

import Foundation
import FirebaseFirestoreSwift

class UserModel : Codable {
    var waitingList: [AnimeModel]
    var ignoreList: [AnimeModel]
    var completedList: [AnimeModel]
    var watchingList: [AnimeModel]
    var page: String
    
    init(){
        self.waitingList = []
        self.ignoreList = []
        self.completedList = []
        self.watchingList = []
        self.page = "1"
    }
}
