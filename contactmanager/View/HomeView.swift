//
//  HomeView.swift
//  contactmanager
//
//  Created by @karthi on 14/01/22.
//

import UIKit

class HomeView: UIView {

    //MARK:- Properties
    @IBOutlet weak var headerView:UIView!
    
    @IBOutlet weak var searchButton:UIButton!
    
    @IBOutlet weak var contactListTableView:UITableView!
    
    private lazy var viewController:HomeViewController = {
        return HomeViewController()
    }()
    
    private lazy var dataSource:[Contact] = {
        return Contact.fetchOverAllContacts()
    }()
    
    //MARK:- Life Cycle
    public func viewDidLoad(_ forController:HomeViewController) {
        
        self.viewController = forController
        
        contactListTableView.separatorColor = .clear
        
        contactListTableView.register(ContactCell.getNib(), forCellReuseIdentifier: ContactCell.reuseIdentifier)
        
        contactListTableView.showsVerticalScrollIndicator = false
        
        contactListTableView.showsHorizontalScrollIndicator = false
        
        contactListTableView.delegate = self
        
        contactListTableView.dataSource = self
        
        self.enableDrag()
        
        NotificationCenter.default.addObserver(self, selector: #selector(reloadData), name: Notification.Name("Reload"), object: nil)
        
    }
    
    public func viewWillAppear() {
        
        self.reloadData()
        
    }
    
    //MARK:- Private functions
    @objc private func reloadData() {
        
        self.dataSource = Contact.fetchOverAllContacts()
        
        print("\(dataSource.count) contacts in list")
        
        self.contactListTableView.reloadData()
        
    }
    
    @objc private func enableDrag() {
            
            contactListTableView.dragInteractionEnabled = true
            
            contactListTableView.dragDelegate = self
        
    }
    
    
    //MARK:- UIInteractions
    @IBAction func searchAction(_ sender:UIButton) {
        
        self.viewController.navigateToSearchViewController()
        
    }
    
}

//MARK:- Table View Delegate and Data Sourece
extension HomeView:UITableViewDelegate,UITableViewDataSource,UITableViewDragDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return dataSource.count
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 90
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(
            withIdentifier: ContactCell.reuseIdentifier,
            for: indexPath) as? ContactCell
        let contact = dataSource[indexPath.row]
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
        
        let contact = dataSource[indexPath.row]
        self.viewController.navigateToContactDetail(contact)
        
    }
    
    func tableView(_ tableView: UITableView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        
        let dragItem = UIDragItem(itemProvider: NSItemProvider())
        dragItem.localObject = dataSource[indexPath.row]
        return [ dragItem ]
        
    }

     func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
         
         let mover = dataSource.remove(at: sourceIndexPath.row)
         dataSource.insert(mover, at: destinationIndexPath.row)
         self.move(sourceIndexPath.row, destinationIndexPath.row)

    }
    
    private func move(_ source:Int,_ destination:Int) {
        dataSource[destination].position = Int16(destination)
        if source > destination {
            print("up")
            for i in destination +  1 ... source {
                let prevContact = dataSource[i-1]
                let contact = dataSource[i]
                contact.position = prevContact.position + 1
            }
        }
        
        if source < destination {
            print("down")
            for i in source ... destination - 1 {
                let contact = dataSource[i]
                contact.position -= 1
            }
        }
        CoreDataHandler.shared.saveContext()
    }
}
