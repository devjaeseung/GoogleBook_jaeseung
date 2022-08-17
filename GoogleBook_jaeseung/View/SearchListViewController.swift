//
//  ViewController.swift
//  GoogleBook_jaeseung
//
//  Created by jaeseung lim on 2022/08/16.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class SearchListViewController: UIViewController {
    
    private let tableView = UITableView()
    let searchController = UISearchController(searchResultsController: nil)

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setLayout()
        
    }
    
    private func setLayout() {
        
        
        navigationItem.title = "GoogleBook"
        navigationController?.navigationBar.prefersLargeTitles = true
        definesPresentationContext = true
            
        searchController.searchResultsUpdater = nil
        searchController.hidesNavigationBarDuringPresentation = true
        
        tableView.tableHeaderView = searchController.searchBar
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        tableView.register(<#T##nib: UINib?##UINib?#>, forCellReuseIdentifier: <#T##String#>)
        
    }
    


}

