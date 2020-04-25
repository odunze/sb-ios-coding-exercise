//
//  Titles.swift
//  Recommendations
//
//  Created by Lotanna Igwe-Odunze on 4/24/20.
//  Copyright © 2020 Serial Box. All rights reserved.
//

import Foundation

struct Recommendation: Codable {
    var imageURL: String
    var title: String
    var tagline: String
    var rating: Float?
    var isReleased: Bool

    enum CodingKeys: String, CodingKey {
        case imageURL = "image"
        case title
        case tagline
        case rating
        case isReleased = "is_released"
    }
}

struct Titles: Codable {
    let titles: [Recommendation]
    let skipped: [String]
    let titlesOwned: [String]

    enum CodingKeys: String, CodingKey {
        case titles
        case skipped
        case titlesOwned = "titles_owned"
    }
}
