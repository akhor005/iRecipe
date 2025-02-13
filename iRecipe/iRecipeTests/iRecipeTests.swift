//
//  iRecipeTests.swift
//  iRecipeTests
//
//  Created by Adrian on 2/4/25.
//

import Testing
import Foundation
@testable import iRecipe

struct iRecipeTests {

    //JSON decoding tests:
    @Test func testFetchValidData() async {
        // arrange
        let mockJSON = """
        {"recipes": [
                {
                    "cuisine": "British",
                    "name": "Chelsea Buns",
                    "photo_url_large": "https://d3jbb8n5wk0qxi.cloudfront.net/photos/4aecd46e-e419-49ec-8888-246b3cc0cc94/large.jpg",
                    "photo_url_small": "https://d3jbb8n5wk0qxi.cloudfront.net/photos/4aecd46e-e419-49ec-8888-246b3cc0cc94/small.jpg",
                    "source_url": "https://www.bbc.co.uk/food/recipes/chelsea_buns_95015",
                    "uuid": "7fc217a9-5566-4bf1-b1ce-13bc9e3f2b1a",
                    "youtube_url": "https://www.youtube.com/watch?v=i_zemP3yBKw"
                },
                {
                    "cuisine": "French",
                    "name": "Chinon Apple Tarts",
                    "photo_url_large": "https://d3jbb8n5wk0qxi.cloudfront.net/photos/ec155176-ebb3-4e83-a320-c5c1d8d0c559/large.jpg",
                    "photo_url_small": "https://d3jbb8n5wk0qxi.cloudfront.net/photos/ec155176-ebb3-4e83-a320-c5c1d8d0c559/small.jpg",
                    "source_url": "https://www.bbcgoodfood.com/recipes/chinon-apple-tarts",
                    "uuid": "6377de22-4ec2-44c4-9e76-260be2e4fd90",
                    "youtube_url": "https://www.youtube.com/watch?v=5dAW9HQgtCk"
                }]
        }
        """.data(using: .utf8)!
        
        let recipeList = await RecipeListViewModel()
        
        // act
        await recipeList.decodeData(data: mockJSON)
        
        // assert
        await #expect(recipeList.recipes.count == 2)
        await #expect(recipeList.recipes.first?.name == "Chelsea Buns")
    }
    @Test func testFetchTypeMismatch() async {
        // arrange
        let mockJSON = """
        {"recipes": [{
                    "cuisine": "French",
                    "name": 37.5,
                    "photo_url_large": "https://d3jbb8n5wk0qxi.cloudfront.net/photos/ec155176-ebb3-4e83-a320-c5c1d8d0c559/large.jpg",
                    "photo_url_small": "https://d3jbb8n5wk0qxi.cloudfront.net/photos/ec155176-ebb3-4e83-a320-c5c1d8d0c559/small.jpg",
                    "source_url": "https://www.bbcgoodfood.com/recipes/chinon-apple-tarts",
                    "uuid": "6377de22-4ec2-44c4-9e76-260be2e4fd90",
                    "youtube_url": "https://www.youtube.com/watch?v=5dAW9HQgtCk"
                }]
        }
        """.data(using: .utf8)!
        
        let recipeList = await RecipeListViewModel()
        
        // act
        await recipeList.decodeData(data: mockJSON)
        
        // assert
        await #expect(recipeList.recipes.isEmpty)
        await #expect((recipeList.fetchErrorMsg ?? "no msg").contains("Type mismatch"))
    }
    @Test func testFetchMissingKey() async {
        // arrange
        let mockJSON = """
        {"recipes": [{
                    "cuisine": "French",
                    "name": "Chinon Apple Tarts",
                    "photo_url_large": "https://d3jbb8n5wk0qxi.cloudfront.net/photos/ec155176-ebb3-4e83-a320-c5c1d8d0c559/large.jpg",
                    "photo_url_small": "https://d3jbb8n5wk0qxi.cloudfront.net/photos/ec155176-ebb3-4e83-a320-c5c1d8d0c559/small.jpg",
                    "source_url": "https://www.bbcgoodfood.com/recipes/chinon-apple-tarts",
                    "youtube_url": "https://www.youtube.com/watch?v=5dAW9HQgtCk"
                }]
        }
        """.data(using: .utf8)!
        
        let recipeList = await RecipeListViewModel()
        
        // act
        await recipeList.decodeData(data: mockJSON)
        
        // assert
        await #expect(recipeList.recipes.isEmpty)
        await #expect((recipeList.fetchErrorMsg ?? "no msg").contains("missing uuid"))
    }
    
    //testing list filters:
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
        let result2 = recipeList.showRecipe(recipe2)
        
        #expect(!result1, "Result should be false as test recipe does not have a YouTube link")
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
