//
//  SearchResultTableViewController.swift
//  Remember
//
//  Created by Songbai Yan on 07/01/2017.
//  Copyright © 2017 Songbai Yan. All rights reserved.
//

import Foundation
import UIKit

class SearchResultTableViewController : UITableViewController, UISearchResultsUpdating{
    private var filteredThings = [ThingEntity]()
    
    var things = [ThingEntity]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text{
            filterResultsForSearchText(searchText)
        }
        self.tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.filteredThings.count
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = self.filteredThings[indexPath.row].content
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    private func filterResultsForSearchText(_ searchText: String){
        self.filteredThings = self.things.filter({ (thing) -> Bool in
            return thing.content.contains(searchText)
        })
    }
}
