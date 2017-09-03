//
//  RicepesListViewController.swift
//  RicepesLab
//
//  Created by Dmitriy Yurchenko on 01.09.17.
//  Copyright © 2017 DYFiJ. All rights reserved.
//

import UIKit
import SDWebImage

class RicepesListViewController: UIViewController
{
    @IBOutlet weak var recipesSearchBar: UISearchBar!
    @IBOutlet weak var recipeListTableView: UITableView!
    
    var recipeObject = RecipesLab(recipesArray: Array<Any>(), searchItems: Array<Any>(), searchText: String(), isSearchMode: Bool())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Recipe labs"
       
        self.recipeListTableView.estimatedRowHeight = 70
        self.recipeListTableView.rowHeight = UITableViewAutomaticDimension
        self.navigationController?.navigationBar.isTranslucent = false
        
        if let savedSearchText = UserDefaults.standard.object(forKey: "RECIPES_SEARCH_TEXT_STORAGE") as? String
        {
            recipeObject.searchText  = savedSearchText
        }
        if let savedSearchDataArray = UserDefaults.standard.object(forKey: "SEARCH_STORAGE") as? NSArray
        {
            recipeObject.searchItems  = savedSearchDataArray as! Array<Any>
        }
        
        if recipeObject.searchItems.isEmpty == true
        {
            NetworkManager.getAllRiceps { (items, errorMessage) in
                if let items = items {
                    self.recipeObject.recipesArray.append(contentsOf: items)
                    //                print(self.recipesArray)
                    self.recipeListTableView.reloadData()
                }
                else {
                    self.showErrorMessage(errorMessage!)
                }
            }
        } else {
            recipeObject.isSearchMode = true
        }
        recipesSearchBar.delegate = self
    }
    
    // MARK: Search Function!
    
    func search()
    {
        NetworkManager.getSearchRequest(searchKey: self.recipesSearchBar.text!) { (items, errorMessage) in
            if let items = items {
                self.recipeObject.searchItems.removeAll()
                self.recipeObject.searchItems.append(contentsOf: items)
                UserDefaults.standard.set(self.recipeObject.searchItems, forKey: "SEARCH_STORAGE")
                self.recipeListTableView.reloadData()
                UserDefaults.standard.set(self.recipeObject.searchText, forKey: "RECIPES_SEARCH_TEXT_STORAGE")
            }
        }
    }
    
    func showErrorMessage(_ errorMessage: String)
    {
        let controller = UIAlertController(title: errorMessage, message: nil, preferredStyle: .alert)
        let cancelButton = UIAlertAction(title: "OK", style: .default, handler: nil)
        controller.addAction(cancelButton)
        present(controller, animated: true, completion: nil)
    }
    override func didReceiveMemoryWarning() {
        SDImageCache.shared().clearDisk(onCompletion: nil)
    }
}

extension RicepesListViewController: UITableViewDataSource, UITableViewDelegate
{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        if self.recipeObject.isSearchMode {
            let item = self.recipeObject.searchItems[indexPath.row] as! NSDictionary
            let link = item["href"] as! String
            UIApplication.shared.open(URL(string:link)!, options: [:], completionHandler: nil)
        }
        else {
            let item = self.recipeObject.recipesArray[indexPath.row] as! NSDictionary
            let link = item["href"] as! String
            UIApplication.shared.open(URL(string:link)!, options: [:], completionHandler: nil)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if self.recipeObject.isSearchMode
        {
            return self.recipeObject.searchItems.count
        }
        return self.recipeObject.recipesArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: RicepesTableViewCell = tableView.dequeueReusableCell(withIdentifier: "RecipeTableViewCellIdentifier", for: indexPath) as! RicepesTableViewCell
        
        var item : NSDictionary!
        
        if self.recipeObject.isSearchMode
        {
            item = self.recipeObject.searchItems[indexPath.row] as! NSDictionary
        }
        else {
            item = self.recipeObject.recipesArray[indexPath.row] as! NSDictionary
        }
        cell.recipeTitleLabel.text = item["title"] as? String
        cell.labelDescription.text = item["ingredients"] as? String
        
        if let thumbnail = item["thumbnail"] as? String
        {
            cell.recipeImage.sd_showActivityIndicatorView()
            cell.recipeImage.sd_setIndicatorStyle(.gray)
            cell.recipeImage.sd_setImage(with: URL(string: thumbnail))
        }
        else
        {
            cell.recipeImage.image = nil
        }
        SDImageCache.shared().clearMemory()
        return cell
    }
    func calculateHeightForConfiguredSizingCell(cell: RicepesTableViewCell) -> CGFloat {
        cell.setNeedsLayout()
        cell.layoutIfNeeded()
        let height = cell.contentView.systemLayoutSizeFitting(UILayoutFittingExpandedSize).height + 1.0
        return height
    }
}
extension RicepesListViewController: UISearchBarDelegate
{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String)
    {
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(search), object: nil)
        
        if searchText.characters.count > 0 {
            self.recipeObject.isSearchMode = true
            perform(#selector(search), with: nil, afterDelay: 0.5)
        }
        else
        {
            self.recipeObject.isSearchMode = false
        }
        recipeListTableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar)
    {
        searchBar.resignFirstResponder()
    }
}













