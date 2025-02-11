//
//  RecipeModel.swift
//  iRecipe
//
//  Created by Adrian on 2/7/25.
//
import Foundation

struct Recipe: Decodable, Identifiable {
    let id = UUID()
    let cuisine: String
    let name: String
    let photoUrlLarge: String
    let photoUrlSmall: String
    let sourceUrl: String?
    var uuid: String
    let youtubeUrl: String?
}
