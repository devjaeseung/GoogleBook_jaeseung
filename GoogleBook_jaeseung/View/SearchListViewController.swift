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
import Kingfisher


class SearchListViewController: UIViewController {

    let TAG = "SearchListViewController"
    
    private let viewModel: SearchListViewModel
    
    private let tableView = UITableView()
    let searchController = UISearchController(searchResultsController: nil)

    private let disposeBag = DisposeBag()
    
    init(viewModel: SearchListViewModel) {
        print(TAG," init viewModel : \(viewModel)")
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setView()
        bindViewModel()
    }
    
    private func setView() {
        view.addSubview(tableView)
        
        navigationItem.title = "Google Book Store"
        navigationController?.navigationBar.prefersLargeTitles = true
        definesPresentationContext = true
            
        searchController.searchResultsUpdater = nil
        searchController.hidesNavigationBarDuringPresentation = true
        
        tableView.tableHeaderView = searchController.searchBar
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        tableView.register(SearchListTableViewCell.self,forCellReuseIdentifier: SearchListTableViewCell.identifier)
        tableView.register(SearchListSectionHeader.self, forHeaderFooterViewReuseIdentifier: SearchListSectionHeader.identifier)
    
        tableView.rowHeight = 100
        
        
        
    }
    
    private func bindViewModel() {
        
        rx.viewWillAppear
            .asObservable()
            .subscribe(onNext : { [weak self] _ in
                guard let strongSelf = self else { return }
                strongSelf.viewModel.viewWillAppear()
            })
            .disposed(by: disposeBag)
        
        tableView.rx.itemSelected
            .asObservable()
            .subscribe(onNext: { [weak self] indexPath in
                guard let strongSelf = self else { return }
                strongSelf.viewModel.didSelect(indexPath: indexPath)
            })
            .disposed(by: disposeBag)
        
        
  
        tableView.rx.willDisplayCell
            .asObservable()
            .subscribe(onNext: { [weak self] cell in

                print("willDisplayCell cell.indexPath.row : \(cell.indexPath.row)")
       
            })
        
        tableView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        
        //tableView.rx.tableHeaderView
        
        searchController.searchBar.rx.text.orEmpty
            .asObservable()
            .subscribe(onNext: { [weak self] query in
                guard let strongSelf = self else { return }
                strongSelf.viewModel.didSearch(query: query)
            })
            .disposed(by: disposeBag)
        
        viewModel.items
            .drive(tableView.rx.items(cellIdentifier: SearchListTableViewCell.identifier, cellType: SearchListTableViewCell.self)) { (row,element,cell) in
                
                print(self.TAG," SearchListViewModel.items / row : \(row) ")
                print(self.TAG," SearchListViewModel.items / element : \(element) ")
                print(self.TAG," SearchListViewModel.items / cell : \(cell) ")
                
                cell.titleLabel.text = element.title
                let authorsStringArray = element.authors
                let authorsString = authorsStringArray.joined(separator:",")
                cell.authorLabel.text = authorsString
                cell.dateLabel.text = element.date
                let imageURLString = element.smalltumbnail
                cell.bookImageView.kf.setImage(with: URL(string: imageURLString))
            }
            .disposed(by: disposeBag)
        
        viewModel.loading
            .drive(UIApplication.shared.rx.isNetworkActivityIndicatorVisible)
            .disposed(by: disposeBag)
        
        viewModel.selectedVolume
            .drive(onNext: { [weak self] infoLink in
                
                guard let strongSelf = self else { return }
                
                print(" infoLink : \(infoLink)")
                
                let webVC = WebViewController(infoLink: infoLink)
                
                strongSelf.navigationController?.pushViewController(webVC, animated: true)
            })
            .disposed(by: disposeBag)
        
    }
    


}

extension SearchListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        guard let searchListSectionHeader = tableView.dequeueReusableHeaderFooterView(withIdentifier: SearchListSectionHeader.identifier) as? SearchListSectionHeader else {
            return UIView()
        }
        
    
        
        return searchListSectionHeader
    }
    
//    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return 50
//    }
    
}

