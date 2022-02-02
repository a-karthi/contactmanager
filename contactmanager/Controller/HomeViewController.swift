//
//  HomeViewController.swift
//  contactmanager
//
//  Created by @karthi on 14/01/22.
//

import UIKit

class HomeViewController: UIViewController {
    
    //MARK:- Properties
    @IBOutlet weak var homeView:HomeView!
    
    private lazy var viewModel:HomeViewModel = {
        return HomeViewModel()
    }()
    
    //MARK:- Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        homeView.viewDidLoad(self)
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
        homeView.viewWillAppear()
    }
    
    // MARK: - Navigations
    public func navigateToContactDetail(_ contact:Contact) {
        
        let vc = ContactDetailViewController.initWithStory(contact)
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    public func navigateToSearchViewController() {
        
        let res = self.viewModel.prepareAlphabeticalArray()
        let vc = SearchViewController.initWithStory(res)
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    // MARK: - ViewController Object for Navigation
    class func initWithStory() -> HomeViewController {
        
        let story = UIStoryboard(name: "Main", bundle: nil)
        let vc = story.instantiateViewController(withIdentifier: "HomeViewController") as!  HomeViewController
        return vc
        
    }

}

