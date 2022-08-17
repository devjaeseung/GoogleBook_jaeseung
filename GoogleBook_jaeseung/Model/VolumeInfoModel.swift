//
//  VolumeInfoModel.swift
//  GoogleBook_jaeseung
//
//  Created by jaeseung lim on 2022/08/17.
//

import Foundation

struct VolumeInfoModel: Decodable {
    
    let volumeInfo: VolumeInfo
    let id: String
    
    var title: String { volumeInfo.title }
    var authors: [String] { volumeInfo.authors }
    var publishedDate: String { volumeInfo.publishedDate }
    var smallThumbnail: String { volumeInfo.imageLinks.smallThumbnail }
    var thumbnail: String { volumeInfo.imageLinks.thumbnail }
    var infoLink: String { volumeInfo.infoLink }
    
    enum CodingKeys : String, CodingKey {
        
        case volumeInfo = "volumeInfo"
        case id = "id"
    }
    
    struct VolumeInfo: Decodable {
        
        let title: String
        let authors: [String]
        let publishedDate: String
        let imageLinks: ImageLinks
        let infoLink: String
        
        enum CodingKeys : String, CodingKey {
            
            case title = "title"
            case authors = "authors"
            case publishedDate = "publishedDate"
            case imageLinks = "imageLinks"
            case infoLink = "infoLink"
            
        }
        
    }
    
}

struct ImageLinks: Decodable {
    
    let smallThumbnail: String
    let thumbnail: String
    
    enum CodingKeys : String, CodingKey {
        
        case smallThumbnail = "smallThumbnail"
        case thumbnail = "thumbnail"

        
    }
    
}
