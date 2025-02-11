//
//  ContentView.swift
//  iRecipe
//
//  Created by Adrian on 2/4/25.
//

import SwiftUI

struct RecipeListView: View {
    @StateObject private var recipeListVM = RecipeListViewModel()
    @FocusState private var searchFocused: Bool
    var headerView: some View {
        return Text("Available Recipes")
            .frame(maxWidth: .infinity)
            .overlay(
                HStack {
                    Button() {
                        Task {
                            await recipeListVM.fetchRecipes()
                        }
                    } label: {
                        Image(systemName: "arrow.clockwise")
                    }
                    Spacer()
                    Button() {
                        recipeListVM.showingClearCache.toggle()
                    } label: {
                        Image(systemName: "gear")
                    }
                    Button() {
                        recipeListVM.showingFilterToggles.toggle()
                    } label: {
                        Image(systemName: "slider.horizontal.3")
                    }
                }.padding(10)
            )
            .font(.title3)
            .foregroundStyle(.black)
    }
    var searchAndFilterView: some View {
        return VStack(spacing: 0) {
            TextField("Search recipe name or cuisine", text: $recipeListVM.searchText)
                .keyboardType(.webSearch)
                .disableAutocorrection(true)
                .onSubmit {
                    recipeListVM.querySearch()
                }
                .focused($searchFocused)
                .padding(7)
                .background(Color.textFieldGray)
                .onChange(of: recipeListVM.searchText) { _, text in
                    if text.isEmpty {
                        recipeListVM.activeFilterText = ""
                    }
                }
            if recipeListVM.showingFilterToggles {
                Divider()
                VStack(alignment: .leading, spacing: 5) {
                    Text("Must contain:")
                        .font(.label)
                    HStack {
                        Image(systemName: recipeListVM.isFilteringSource ? "checkmark.square.fill" : "square")
                        Text("Source website")
                    }
                    .font(.filter)
                    .onTapGesture {
                        recipeListVM.isFilteringSource.toggle()
                    }
                    HStack {
                        Image(systemName: recipeListVM.isFilteringYouTube ? "checkmark.square.fill" : "square")
                        Text("YouTube tutorial")
                    }
                    .font(.filter)
                    .onTapGesture {
                        recipeListVM.isFilteringYouTube.toggle()
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(10)
                .background(Color.textFieldGray)
            }
        }
    }
    var body: some View {
        VStack {
            headerView
            searchAndFilterView
            if let errorMsg = recipeListVM.fetchErrorMsg {
                VStack {
                    Text("Error fetching recipes:")
                        .padding(10)
                    Text(errorMsg)
                }
                .font(.subtitle)
                .foregroundStyle(.red)
            } else if recipeListVM.recipes.isEmpty {
                Text("No recipes found. Please refresh or check back later.")
                    .font(.subtitle)
                    .padding(10)
            }
            List(recipeListVM.recipes) { recipe in
                if recipeListVM.showRecipe(recipe) {
                    RecipeEntryView(recipe: recipe, recipeEntryVM: RecipeEntryViewModel(recipe))
                }
            }
            .listStyle(PlainListStyle())
            .onScrollPhaseChange { _, _ in
                searchFocused = false
                recipeListVM.querySearch()
            }
            .refreshable {
                await recipeListVM.fetchRecipes()
            }
            .task {
                await recipeListVM.fetchRecipes()
            }
        }
        .background(Color.backgroundColor)
        .confirmationDialog("Do you want to clear images from cache?", isPresented: $recipeListVM.showingClearCache) {
            Button {
                recipeListVM.clearImageCache()
            } label: {
                Text("Clear Cache")
            }
        }
    }
}

