//
//  News.swift
//  Pixels News
//
//  Created by Alief Azies on 18/10/21.
//

import Foundation

struct News: Decodable {
    let id: Int64
    let title: String
    let abstract: String
    let section: String
    let published_date: Date
    let media: [Media]
    let url: String
    
    enum CodingKeys: String, CodingKey{
        case id
        case title
        case abstract
        case section
        case published_date
        case media
        case url
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int64.self, forKey: .id) ?? 0
        title = try values.decodeIfPresent(String.self, forKey: .title) ?? ""
        abstract = try values.decodeIfPresent(String.self, forKey: .abstract) ?? ""
        section = try values.decodeIfPresent(String.self, forKey: .section) ?? ""
        let dateString = try values.decodeIfPresent(String.self, forKey: .published_date) ?? ""
        published_date = dateString.date(format: .date) ?? Date(timeIntervalSince1970: 0)
        media = try values.decodeIfPresent([Media].self, forKey: .media) ?? []
        url = try values.decodeIfPresent(String.self, forKey: .url) ?? ""
    }
}
