//
//  HomeViewModel.swift
//  contactmanager
//
//  Created by @karthi on 14/01/22.
//

import Foundation
import CoreData
import UIKit

class HomeViewModel {
    
    //MARK:- Properties
    private var offset = 0
    
    static let shared = HomeViewModel()
    
    //MARK:- API Calls
    public func callContactsAPI() {
        
        NetworkManager.getContacts(offset: self.offset, responseType: [ContactNetworkResponse].self) { (result) in
            switch result {
            case .failure(let error):
                print(error)
            case .success(let contactList):
                for contact in contactList {
                    if !Contact.isExist(contact.name) {
                        self.saveContactsToCoreData(contact)
                    }
                }
                self.offset = self.offset + 1
                if self.offset <= AppConstants.offsetTarget {
                    self.callContactsAPI()
                } else {
                    print("Download...Completed")
                    UserDefaults.standard.set(true, forKey: "DownloadCompleted")
                }
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Reload"), object: nil)
            }
        }
    }
    
    //Mark:- For Downloading of  image
    public func downloadImage(_ url:URL,_ saveInTo:String,onReturn: @escaping (UIImage) -> Void){
        NetworkManager.loadPicture(from: url) { data in
            if let localContact = Contact.fetchParticularContact(for: saveInTo) {
                   localContact.photo = data
            }
            CoreDataHandler.shared.saveContext()
            if let image = UIImage(data: data) {
                onReturn(image)
            }
        }
    }
    
    
    //Mark:- Save Contacts to core data
    private func  saveContactsToCoreData(_ contact:ContactNetworkResponse) {
        let contacts = Contact.fetchOverAllContacts()
        let contactCoreDataObject = Contact.getContactCoreDataObject()
        contactCoreDataObject?.name = contact.name
        contactCoreDataObject?.company = contact.company
        contactCoreDataObject?.age = Int16(contact.age)
        contactCoreDataObject?.email = contact.email
        contactCoreDataObject?.phone = contact.phone
        contactCoreDataObject?.address = contact.address
        contactCoreDataObject?.country = contact.country
        contactCoreDataObject?.id = Int16(contact.id)
        contactCoreDataObject?.zip = contact.zip
        contactCoreDataObject?.photoString = contact.photo
        let position = contacts.count == 0 ? 0 : contacts.count == 1 ? 1 : contacts.count
        contactCoreDataObject?.position = Int16(position)
        CoreDataHandler.shared.saveContext()
    }
    
    
    //Mark:- Prepare Alphabetical Array
    public func prepareAlphabeticalArray() -> [AlphabetModel] {
        var resultArray = [AlphabetModel]()
        for letter in Alphabets {
            let contacts = Contact.fetchBeginWithLetter(letter)
            if contacts.count > 0 {
                let obj = AlphabetModel(letter: letter, contacts: contacts)
                resultArray.append(obj)
            }
        }
        return resultArray
    }
    
    //Mark:- Prepare Alphabetical Array From Given Db
    public func prepareAlphabeticalArrayFromDb(_ contacts:[Contact]) -> [AlphabetModel] {
        var resultArray = [AlphabetModel]()
        for letter in Alphabets {
            let contacts = contacts.filter({$0.name?.first == letter.randomElement()})
            if contacts.count > 0 {
                let obj = AlphabetModel(letter: letter, contacts: contacts)
                resultArray.append(obj)
            }
        }
        return resultArray
    }
    
}
