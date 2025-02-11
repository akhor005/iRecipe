//
//  iRecipeTests.swift
//  iRecipeTests
//
//  Created by Adrian on 2/4/25.
//

import Testing
@testable import iRecipe

struct iRecipeTests {

    @Test func example() async throws {
        // Write your test here and use APIs like `#expect(...)` to check expected conditions.
    }
    @MainActor @Test func testShowRecipeYouTube() {
        //arrange
        let recipe1 = Recipe(cuisine: "American",
                                name: "Test Dish",
                                photoUrlLarge: "",
                                photoUrlSmall: "",
                                sourceUrl: nil,
                                uuid: "testRecipe100",
                                youtubeUrl: nil)
        let recipe2 = Recipe(cuisine: "Peruvian",
                                name: "Test Dish",
                                photoUrlLarge: "",
                                photoUrlSmall: "",
                                sourceUrl: nil,
                                uuid: "testRecipe101",
                                youtubeUrl: "https://www.youtube.com/watch?v=1ahpSTf_Pvk")
        
        let recipeList = RecipeListViewModel()
        recipeList.isFilteringYouTube = true
        
        let result1 = recipeList.showRecipe(recipe1)
        #expect(!result1, "Result should be false as test recipe does not have a YouTube link")
        
        let result2 = recipeList.showRecipe(recipe2)
        #expect(result2, "Result should be true as test recipe has a YouTube link")
    }
    
    @MainActor @Test func testShowRecipeSource() {
        //arrange
        let recipe1 = Recipe(cuisine: "American",
                                name: "Test Dish",
                                photoUrlLarge: "",
                                photoUrlSmall: "",
                                sourceUrl: "https://www.bbcgoodfood.com/recipes/angela-nilsens-christmas-cake",
                                uuid: "testRecipe200",
                                youtubeUrl: nil)
        let recipe2 = Recipe(cuisine: "Canadian",
                                name: "Test Dish",
                                photoUrlLarge: "",
                                photoUrlSmall: "",
                                sourceUrl: nil,
                                uuid: "testRecipe201",
                                youtubeUrl: nil)
        
        let recipeList = RecipeListViewModel()
        recipeList.isFilteringSource = true
        
        //act
        let result1 = recipeList.showRecipe(recipe1)
        let result2 = recipeList.showRecipe(recipe2)
        
        //assert
        #expect(result1, "Result should be false as test recipe does not have a YouTube link")
        #expect(!result2, "Result should be true as test recipe has a YouTube link")
    }
    @MainActor @Test func testQuerySearch() {
        //arrange
        let recipeList = RecipeListViewModel()
        recipeList.searchText = "French"
        
        //act
        recipeList.querySearch()
        
        //assert
        #expect(recipeList.activeFilterText == "French", "activeFilterText must be updated when querying to filter results")
    }

}
