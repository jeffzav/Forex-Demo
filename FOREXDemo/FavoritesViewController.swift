//
//  UIViewController.swift
//  FOREXDemo
//
//  Created by Jeffrey Zavattero on 3/16/19.
//  Copyright © 2019 Noble Desktop. All rights reserved.
//

import UIKit
import Firebase


class FavoritesViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    lazy var db = Firestore.firestore()
    lazy var document = db.collection("favorites").document("currentUser")
    var favorites: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.allowsMultipleSelection = true
        
        document.addSnapshotListener { (snapshot, error) in
            var favoritesData = snapshot?.data() as? [String: Bool] ?? [:]
            var favoriteSymbols: [String] = []
            
            for (key, value) in favoritesData {
                if value {favoriteSymbols.append(key)}
            }
            self.favorites = favoriteSymbols
            self.tableView.reloadData()
            
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier ?? "" {
        case "FavoritesViewController_to_SymbolDetailViewController":
            guard let destination = segue.destination as? SymbolDetailViewController else {
                return
            }
            
            let selectedIndexPaths = tableView.indexPathsForSelectedRows ?? []
            var selectedSymbols: [String] = []
            
            for indexPath in selectedIndexPaths {
                selectedSymbols.append(favorites[indexPath.row])
            }
            
            destination.symbols = selectedSymbols
        default:
            assert(false, "You added a segue but didn't implement prepare for segue")
        }
    }
}

extension FavoritesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favorites.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FavoritesTableViewCell")!
        cell.textLabel?.text = favorites[indexPath.row]
        cell.selectionStyle = .none
        return cell
    }
}
extension FavoritesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = self.tableView.cellForRow(at: indexPath)
        cell?.accessoryType = .checkmark
    }
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = self.tableView.cellForRow(at: indexPath)
        cell?.accessoryType = .none
    }
}
