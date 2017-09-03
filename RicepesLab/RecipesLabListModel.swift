//
//  RecipesLabListModel.swift
//  RicepesLab
//
//  Created by Dmitriy Yurchenko on 03.09.17.
//  Copyright © 2017 DYFiJ. All rights reserved.
//

import Foundation
class RecipesLab
{
    var recipesArray = Array<Any>()
    var searchItems = Array<Any> ()
    var searchText = String()
    var isSearchMode = false
    
    init (recipesArray: Array<Any>, searchItems: Array<Any>,  searchText: String, isSearchMode: Bool)
    {
        self.recipesArray = recipesArray
        self.searchItems = searchItems
        self.searchText = searchText
        self.isSearchMode = isSearchMode
    }
}
