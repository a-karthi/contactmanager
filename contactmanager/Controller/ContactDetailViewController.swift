//
//  ContactDetailViewController.swift
//  contactmanager
//
//  Created by @karthi on 14/01/22.
//

import UIKit

class ContactDetailViewController: UIViewController {
    
    //MARK:- Properties
    
    @IBOutlet weak var contactDetailView:ContactDetailView!
    
    public lazy var contactDetail:Contact = {
        return Contact()
    }()
    
    //MARK:- Life Cycles

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Details"
        contactDetailView.viewDidLoad(self)
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.backgroundColor = .systemGray6
        self.navigationController?.navigationBar.isHidden = false
    }
    
    //MARK:- Public functions
    public func deleteContact() {
        
        Contact.deleteContact(self.contactDetail)
        self.navigationController?.popViewController(animated: true)
        
    }
    

    // MARK: - ViewController Object for Navigation
    class func initWithStory(_ detail:Contact) -> ContactDetailViewController {
        
        let story = UIStoryboard(name: "Main", bundle: nil)
        let vc = story.instantiateViewController(withIdentifier: "ContactDetailViewController") as!  ContactDetailViewController
        vc.contactDetail = detail
        return vc
        
    }
    

}
