//
//  AnimeModel.swift
//  AnimeRepo
//
//  Created by Shirley Averette on 6/17/24.
//

import Foundation

struct AnimeModel: Codable, Identifiable, Equatable {
    let mal_id : Int
    var title: String
    let synopsis: String
    let images: ImageList
    
    var id: Int {
        return mal_id
    }
    
    static func == (lhs: AnimeModel, rhs: AnimeModel) -> Bool {
        return  lhs.mal_id == rhs.mal_id &&
                lhs.title == rhs.title &&
                lhs.synopsis == rhs.synopsis
    }
}

struct DataModel : Codable {
    var data: [AnimeModel]
}

struct ImageList : Codable {
    var jpg : Image
}

struct Image : Codable {
    let image_url : String
    let small_image_url: String
    let large_image_url: String
}


