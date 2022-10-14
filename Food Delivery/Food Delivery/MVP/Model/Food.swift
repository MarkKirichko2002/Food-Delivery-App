//
//  Food.swift
//  Food Delivery
//
//  Created by Марк Киричко on 13.10.2022.
//

import Foundation

struct FoodCategory {
    let id: Int
    let name: String
    let icon: String
}

struct Banner {
    let text: String
    let image: String
}

// MARK: - Food
struct Food: Codable {
    let request: [Request]
}

// MARK: - Request
struct Request: Codable {
    let name: String
    let calories, id, carbs: Int
    let requestDescription: String
    let price: Double
    let protein: Int
    let imageURL: String

    enum CodingKeys: String, CodingKey {
        case name, calories, id, carbs
        case requestDescription = "description"
        case price, protein, imageURL
    }
}
