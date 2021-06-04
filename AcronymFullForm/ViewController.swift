//
//  ViewController.swift
//  AcronymFullForm
//
//  Created by hscuser on 01/06/21.
//

import UIKit
class ViewController: UIViewController {
    private let HOME_SCREEN_ESTIMATED_ROW_HEIGHT: CGFloat = 100.0
    @IBOutlet weak var acronylisttblView: UITableView!
    private var searchController: UISearchController!
    private var acronymViewModel: AcronymViewModel = AcronymViewModel()
    private var acronymModel: AcronymModel?
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setup()
        bindings()
        
        
    }
    
    func bindings(){
        acronymViewModel.acronymModel.bind {[weak self] (acronymModel) in
            self?.acronymModel = acronymModel
            self?.acronylisttblView.reloadData()

        }
        
        acronymViewModel.errorString.bind {[weak self] (errorString) in
            let alertController = UIAlertController.init(title: "Error", message: errorString, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(okAction)
            self?.present(alertController, animated: false, completion: nil)
        }
    }
    
    
    private func setup() {
        //        acronylisttblView.register(AcronymListTableViewCell.nib, forCellReuseIdentifier: AcronymListTableViewCell.identifier)
        acronylisttblView.rowHeight = UITableView.automaticDimension
        acronylisttblView.estimatedRowHeight = 44
        
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.searchBar.autocapitalizationType = .none
        searchController.searchBar.placeholder = "Type Acronym. eg: HMM"
        searchController.searchBar.delegate = self
        navigationItem.searchController = searchController
        definesPresentationContext = true
        
    }

}


// MARK: - UITableViewDataSource

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard acronymModel != nil else {
            return 0
        }
        return acronymModel!.lfs?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: AcronymListTableViewCell.identifier, for: indexPath) as? AcronymListTableViewCell{
            cell.indexPath = indexPath
            cell.acronymModel = acronymModel
            return cell
        }
        
        return UITableViewCell()
    }
    
}

//MARK: - UISearchResultsUpdating method


extension ViewController: UISearchResultsUpdating{
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
//        print("searchbar text is \(String(describing: searchBar.text))")
    }
    
    
}

// MARK: - UISearchBarDelegate
extension ViewController: UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar){
        print("\(#function) searchbar text is \(String(describing: searchBar.text))")
        guard let searchtext = searchBar.text else {
            return
        }
        if !acronymViewModel.validateEnteredAcronym(acronym: searchtext) {
            return
        }
        acronymViewModel.fetchAcronymFullForm(for: searchtext)
    }
}
