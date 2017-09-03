//
//  RicepesListViewController.swift
//  RicepesLab
//
//  Created by Dmitriy Yurchenko on 01.09.17.
//  Copyright © 2017 DYFiJ. All rights reserved.
//

import UIKit
import SDWebImage


class RicepesListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    @IBOutlet weak var recipesSearchBar: UISearchBar!
    @IBOutlet weak var recipeListTableView: UITableView!
    
    var recipesArray = Array<Any>()
    
    var searchItems = Array<Any> ()
    
    var searchText = String()
    
    var isSearchMode = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let savedSearchText = UserDefaults.standard.object(forKey: "RECIPES_SEARCH_TEXT_STORAGE") as? String
        {
            self.searchText = savedSearchText
        }
        if let savedSearchDataArray = UserDefaults.standard.object(forKey: "SEARCH_STORAGE") as? NSArray
        {
            self.searchItems  = savedSearchDataArray as! Array<Any>
        }
        
        self.recipeListTableView.estimatedRowHeight = 70
        self.recipeListTableView.rowHeight = UITableViewAutomaticDimension
        
        title = "Recipe labs"
    
        
        self.navigationController?.navigationBar.isTranslucent = false
        
        if searchItems.isEmpty == true
        {
            NetworkManager.getAllRiceps { (items, errorMessage) in
                if let items = items {
                    self.recipesArray.append(contentsOf: items)
                    //                print(self.recipesArray)
                    self.recipeListTableView.reloadData()
                }
                else {
                    self.showErrorMessage(errorMessage!)
                }
            }
        } else {
            isSearchMode = true
        }
        recipesSearchBar.delegate = self
    }
    
    func search()
    {
        NetworkManager.getSearchRequest(searchKey: self.recipesSearchBar.text!) { (items, errorMessage) in
            if let items = items {
                self.searchItems.removeAll()
                self.searchItems.append(contentsOf: items)
                UserDefaults.standard.set(self.searchItems, forKey: "SEARCH_STORAGE")
                self.recipeListTableView.reloadData()
                UserDefaults.standard.set(self.searchText, forKey: "RECIPES_SEARCH_TEXT_STORAGE")
            }
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar)
    {
        searchBar.resignFirstResponder()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String)
    {
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(search), object: nil)
        
        if searchText.characters.count > 0 {
            isSearchMode = true
            perform(#selector(search), with: nil, afterDelay: 0.5)
        }
        else {
            isSearchMode = false
        }
        
        recipeListTableView.reloadData()
    }
    
    func showErrorMessage(_ errorMessage: String)
    {
        let controller = UIAlertController(title: errorMessage, message: nil, preferredStyle: .alert)
        let cancelButton = UIAlertAction(title: "OK", style: .default, handler: nil)
        controller.addAction(cancelButton)
        present(controller, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        if isSearchMode {
            let item = searchItems[indexPath.row] as! NSDictionary
            let link = item["href"] as! String
            UIApplication.shared.open(URL(string:link)!, options: [:], completionHandler: nil)
        }
        else {
            let item = recipesArray[indexPath.row] as! NSDictionary
            let link = item["href"] as! String
            UIApplication.shared.open(URL(string:link)!, options: [:], completionHandler: nil)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if isSearchMode
        {
            return searchItems.count
        }
        return recipesArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: RicepesTableViewCell = tableView.dequeueReusableCell(withIdentifier: "RecipeTableViewCellIdentifier", for: indexPath) as! RicepesTableViewCell
        
        var item : NSDictionary!
        
        if isSearchMode
        {
            item = searchItems[indexPath.row] as! NSDictionary
            
        }
        else {
            item = recipesArray[indexPath.row] as! NSDictionary
        }
        
        cell.recipeTitleLabel.text = item["title"] as? String
        cell.labelDescription.text = item["ingredients"] as? String
        
        if let thumbnail = item["thumbnail"] as? String
        {
            cell.recipeImage.sd_setImage(with: URL(string: thumbnail))
        }
        else {
            cell.recipeImage.image = nil
        }
        return cell
    }
    func calculateHeightForConfiguredSizingCell(cell: RicepesTableViewCell) -> CGFloat {
        cell.setNeedsLayout()
        cell.layoutIfNeeded()
        let height = cell.contentView.systemLayoutSizeFitting(UILayoutFittingExpandedSize).height + 1.0
        return height
    }
}













