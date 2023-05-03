//
//  TopNewsResponse.swift
//  Pixels News
//
//  Created by Alief Azies on 22/10/21.
//

import Foundation

struct TopNewsResponse: Decodable{
    let results: [News]
    
    enum CodingKeys: String, CodingKey {
        case results
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        results = try values.decodeIfPresent([News].self, forKey: .results) ?? []
    }
}
