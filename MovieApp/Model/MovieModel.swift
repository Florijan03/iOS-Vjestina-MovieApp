//
//  MovieModel.swift
//  MovieApp
//
//  Created by Florijan Stankir on 09.07.2024..
//

import Foundation

struct MovieDetailsModel: Decodable {
    let id: Int
    let name: String
    let year: Int
    let rating: Double
    let releaseDate: String
    let duration: Int
    let summary: String
    let imageUrl: String
    let categories: [MovieCategoryModel]
    let crewMembers: [MovieCrewMemberModel]

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case year
        case rating
        case releaseDate = "release_date"
        case duration
        case summary
        case imageUrl = "image_url"
        case categories
        case crewMembers = "crew_members"
    }
}

struct MovieCategoryModel: Decodable {
    let id: Int
    let localizedTitle: String

    enum CodingKeys: String, CodingKey {
        case id
        case localizedTitle = "localized_title"
    }
}

struct MovieCrewMemberModel: Decodable {
    let id: Int
    let name: String
    let role: String
}
