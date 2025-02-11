//
//  RecipeEntryView.swift
//  iRecipe
//
//  Created by Adrian on 2/7/25.
//

import SwiftUI

struct RecipeEntryView: View {
    let recipe: Recipe
    @StateObject var recipeEntryVM: RecipeEntryViewModel
    func webLinkButton(imageName: String, destinationUrl: URL) -> some View {
        Link(destination: destinationUrl) {
            Image(imageName)
                .renderingMode(.template)
                .resizable()
                .scaledToFill()
                .foregroundStyle(.black)
                .opacity(0.8)
                .frame(width: 100, height: 40)
        }
    }
    func recipeSheet() -> some View {
        return VStack {
            Text(recipeEntryVM.recipe.name)
                .font(.recipeSheetTitle)
                .frame(maxWidth: .infinity)
                .padding(.top, 15)
                .padding(.horizontal, 40)
                .overlay {
                    HStack {
                        Spacer()
                        Button {
                            recipeEntryVM.isShowingDetails.toggle()
                        } label: {
                            Image(systemName: "multiply")
                                .bold()
                                .foregroundStyle(.gray)
                        }
                        .padding(15)
                    }
                }
            Text(recipeEntryVM.recipe.cuisine + " Cuisine")
                .font(.recipeSheetCuisine)
                .foregroundStyle(.gray)
            Divider()
            AsyncImage(url: URL(string: recipe.photoUrlLarge)) { image in
                image.resizable()
                    .scaledToFill()
                    .frame(width: UIScreen.main.bounds.width - 50, height: 300)
                    .cornerRadius(5)
            } placeholder: {
                ProgressView()
            }
            Spacer()
            Text("LEARN THIS RECIPE")
                .font(.subtitle)
                .foregroundStyle(Color.backgroundVariant)
            HStack{
                if let sourceUrl = URL(string: recipe.sourceUrl ?? "") {
                    Spacer()
                    webLinkButton(imageName: "RecipeWebsiteLogo", destinationUrl: sourceUrl)
                }
                Spacer()
                if let youtubeUrl = URL(string: recipe.youtubeUrl ?? "") {
                    webLinkButton(imageName: "YouTubeLogo", destinationUrl: youtubeUrl)
                    Spacer()
                }
            }
            .padding(20)
            .background(Color.backgroundColor)
        }
    }

    var body: some View {
        VStack {
            Button {
                withAnimation {
                    recipeEntryVM.isShowingDetails.toggle()
                }
            } label: {
                HStack() {
                    if let image = recipeEntryVM.image {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 55, height: 55)
                            .clipShape(Circle())
                    } else {
                        ProgressView()
                    }
                    
                    VStack(alignment: .leading, spacing: 3) {
                        Text(recipeEntryVM.recipe.name)
                            .font(.recipeListTitle)
                        Text(recipeEntryVM.recipe.cuisine)
                            .font(.recipeListCuisine)
                            .foregroundColor(.gray)
                    }
                    Spacer()
                }
            }.frame(maxWidth: .infinity)
                .sheet(isPresented: $recipeEntryVM.isShowingDetails) {
                    recipeSheet()
                        .presentationDetents([.height(UIScreen.main.bounds.height * 0.67)])
                }
        }
        .onAppear() {
            recipeEntryVM.loadImage() //only loads visible images
        }
    }
}
