//
//  SearchView.swift
//  contactmanager
//
//  Created by @karthi on 14/01/22.
//

import Foundation
import UIKit

class SearchView: UIView {

    //MARK:- Properties
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var resultTableView: UITableView!
    
    private var queryString = ""
    
    private var ascendingOrder = true
    
    
    private lazy var viewController:SearchViewController = {
        return SearchViewController()
    }()
    
    private lazy var viewModel:HomeViewModel = {
        return HomeViewModel()
    }()
    
    private lazy var dataSource:[AlphabetModel] = {
        return self.viewController.fullDataSource
    }()
    
    //MARK:- Life Cycle
    public func viewDidLoad(_ forController:SearchViewController) {
        
        self.viewController = forController
        
        resultTableView.showsVerticalScrollIndicator = false
        
        resultTableView.showsHorizontalScrollIndicator = false
        
        resultTableView.separatorColor = .clear
        
        resultTableView.register(ContactCell.getNib(), forCellReuseIdentifier: ContactCell.reuseIdentifier)
        
        resultTableView.delegate = self
        
        resultTableView.dataSource = self
        
        self.searchBar.returnKeyType = .done
        
        self.searchBar.delegate = self
        
    }
    
    public func viewWillAppear() {
        
        self.reloadData()
        
    }
    
    //MARK:- Private functions
    @objc public func reloadData() {
        
        if queryString == "" {
            
            self.dataSource = self.viewController.fullDataSource
            
        } else {
            
            let contacts = Contact.searchContacts(queryString)
            self.dataSource = self.viewModel.prepareAlphabeticalArrayFromDb(contacts)
        }
        
        self.resultTableView.reloadData()
        
    }
    
}

//MARK:- Table View Delegate and Data Sourece
extension SearchView:UITableViewDelegate,UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        self.dataSource.count
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let alphabet = dataSource[section]
        
        return alphabet.contacts.count
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 90
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 40
        
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        let alphabet = dataSource[section]
        
        return alphabet.letter
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(
            withIdentifier: ContactCell.reuseIdentifier,
            for: indexPath) as? ContactCell
        let alphabet = dataSource[indexPath.section]
        let contact = alphabet.contacts[indexPath.row]
        cell?.selectionStyle = .none
        cell?.populateCell(contact)
        if let data = contact.photo {
            cell?.profileImageView.image = UIImage(data: data)
        }else {
            cell?.profileImageView.image = UIImage(named: "default")
        }
        return cell ?? UITableViewCell()
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let alphabet = dataSource[indexPath.section]
        let contact = alphabet.contacts[indexPath.row]
        self.viewController.navigateToContactDetail(contact)
        
    }
    
    
}

//MARK:- Search bar delegate

extension SearchView: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.queryString = searchText
        self.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.endEditing(true)
    }
    
}
