//
//  SearchViewController.swift
//  contactmanager
//
//  Created by @karthi on 14/01/22.
//

import Foundation
import UIKit

class SearchViewController: UIViewController {
    
    //MARK:- Properties
    @IBOutlet weak var searchView:SearchView!
    
    private var ascendingOrder = true
    
    public lazy var fullDataSource:[AlphabetModel] = {
        return [AlphabetModel]()
    }()
    
    private lazy var viewModel:HomeViewModel = {
        return HomeViewModel()
    }()
    
    //MARK:- Life cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Search Contacts"
        searchView.viewDidLoad(self)
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
        let menuButton = UIBarButtonItem(image: UIImage(named: "sort"), style: .plain, target: self, action: #selector(self.sortAction))
        self.navigationItem.rightBarButtonItem = menuButton
        self.fullDataSource = self.viewModel.prepareAlphabeticalArray()
        if !ascendingOrder {
            self.fullDataSource = self.fullDataSource.reversed()
        }
        self.searchView.viewWillAppear()
    }
    
    
    // MARK:- Priavte Fucntions
    
    @objc private func sortAction() {
       
        self.ascendingOrder = !self.ascendingOrder
        
        self.fullDataSource = self.fullDataSource.reversed()
            
        self.searchView.viewWillAppear()
    }
    
    // MARK: - Navigations
    public func navigateToContactDetail(_ contact:Contact) {
        
        let vc = ContactDetailViewController.initWithStory(contact)
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    // MARK: - ViewController Object for Navigation
    class func initWithStory(_ fullDataSource:[AlphabetModel]) -> SearchViewController {
        
        let story = UIStoryboard(name: "Main", bundle: nil)
        let vc = story.instantiateViewController(withIdentifier: "SearchViewController") as!  SearchViewController
        vc.fullDataSource = fullDataSource
        return vc
        
    }

}


