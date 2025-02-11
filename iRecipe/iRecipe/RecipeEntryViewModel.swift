//
//  RecipeEntryViewModel.swift
//  iRecipe
//
//  Created by Adrian on 2/6/25.
//

import Foundation
import SwiftUI

@MainActor
class RecipeEntryViewModel: ObservableObject {
    let recipe: Recipe
    @Published var image: UIImage? = nil
    @Published var isShowingDetails = false
    init(_ recipe: Recipe) {
        self.recipe = recipe
    }
    private func getFilePath() -> URL {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        let fileURL = documentsDirectory!.appendingPathComponent("\(recipe.uuid).png")
        return fileURL
    }
    private func cacheImage() throws {
        if let data = image?.pngData() {
            do {
                try data.write(to: getFilePath())
            } catch {
                print(error) //no handling needed, as app can still fetch from web
            }
        }
    }
    func loadImage() {
        let deviceUrl = getFilePath()
        if FileManager.default.fileExists(atPath: deviceUrl.path()) { //check cache first, otherwise load from web
            do {
                let imageData = try Data(contentsOf: getFilePath())
                self.image = UIImage(data: imageData)
            } catch {
                loadImageWeb()
            }
        } else {
            loadImageWeb()
        }
    }
    func loadImageWeb() {
        let url = URL(string: recipe.photoUrlSmall)!
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                        do { try self?.cacheImage() } catch { }
                    }
                }
            }
        }
    }
}
