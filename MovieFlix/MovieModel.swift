//
//  MovieModel.swift
//  MovieFlix
//
//  Created by Yeasir Arefin Tusher on 27/12/22.
//

// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let welcome = try? newJSONDecoder().decode(Welcome.self, from: jsonData)

import Foundation

struct MovieModel: Decodable {
    
    let results: [Movie]
    
    enum CodingKeys: String, CodingKey {
        case results = "results"
    }
}

struct Movie: Decodable {
    
    let id: Int
    let overview: String?
    let posterPath: String?
    let title: String?
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case overview = "overview"
        case posterPath = "poster_path"
        case title = "title"
    }
}
