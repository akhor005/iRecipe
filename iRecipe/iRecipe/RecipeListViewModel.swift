//
//  RecipeListViewModel.swift
//  iRecipe
//
//  Created by Adrian on 2/7/25.
//

import Foundation

@MainActor
class RecipeListViewModel: ObservableObject {
    @Published var recipes:[Recipe] = []
    @Published var searchText = ""
    @Published var activeFilterText = ""
    @Published var isFilteringYouTube = false
    @Published var isFilteringSource = false
    
    @Published var showingClearCache = false
    @Published var showingFilterToggles = false
    @Published var fetchErrorMsg: String? = nil
    func showRecipe(_ recipe: Recipe) -> Bool {
        let searchTextCondition = (recipe.cuisine+recipe.name).contains(self.activeFilterText) || self.activeFilterText.isEmpty
        let ytCondition = !self.isFilteringYouTube || (recipe.youtubeUrl != nil)
        let sourceCondition = !self.isFilteringSource || (recipe.sourceUrl != nil)
        return searchTextCondition && ytCondition && sourceCondition
    }
    func querySearch() {
        self.activeFilterText = self.searchText
    }

    func decodeData(data: Data) async {
        do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            let decodedResponse = try decoder.decode([String: [Recipe]].self, from: data)
            self.recipes = decodedResponse["recipes"] ?? []
        } catch let error as DecodingError {
            switch error {
            case .typeMismatch(_, let context):
                if context.codingPath.count > 1, let index = context.codingPath[1].intValue {
                    self.fetchErrorMsg = "Type mismatch at index \(index): \(context.debugDescription)"
                } else {
                    self.fetchErrorMsg = "Type mismatch: \(context.debugDescription)"
                }
            case .valueNotFound(_, let context): //couldn't test; removing value threw typeMismatch error instead
                if context.codingPath.count > 1, let index = context.codingPath[1].intValue {
                    self.fetchErrorMsg = "Missing value at index \(index)"
                } else {
                    self.fetchErrorMsg = "Missing value"
                }
            case .keyNotFound(let codingKey, let context):
                if context.codingPath.count > 1, let index = context.codingPath[1].intValue {
                    self.fetchErrorMsg = "Recipe at index \(index) missing \(codingKey.stringValue)"
                } else {
                    self.fetchErrorMsg = "Recipe at missing \(codingKey.stringValue)"
                }
            case .dataCorrupted:
                self.fetchErrorMsg = "Data corrupted"
            @unknown default:
                self.fetchErrorMsg = "Unknown decoding error"
            }
        } catch {
            self.fetchErrorMsg = "Unknown error"
        }
    }
    func loadRecipes() async {
        self.fetchErrorMsg = nil
        clearFilters()
        do {
            //https://d3jbb8n5wk0qxi.cloudfront.net/recipes.json
            //https://d3jbb8n5wk0qxi.cloudfront.net/recipes-malformed.json
            //https://d3jbb8n5wk0qxi.cloudfront.net/recipes-empty.json
            guard let url = URL(string: "https://d3jbb8n5wk0qxi.cloudfront.net/recipes.json") else {
                self.fetchErrorMsg = "Invalid URL"
                return
            }
            let (data, _) = try await URLSession.shared.data(from: url)
            await decodeData(data: data)
        } catch {
            self.fetchErrorMsg = "Could not fetch data. Please double check URL."
        }
    }
    func clearImageCache() {
        for recipe in self.recipes {
            do {
                let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
                let fileURL = documentsDirectory!.appendingPathComponent("\(recipe.uuid).png")
                try FileManager.default.removeItem(at: fileURL)
                print("deleting image from \(recipe.uuid)")
            } catch {
                print("no image to delete")
            }
        }
    }
    func clearFilters() {
        self.isFilteringYouTube = false
        self.isFilteringSource = false
        self.showingFilterToggles = false
        self.searchText = ""
        self.activeFilterText = ""
    }
}
