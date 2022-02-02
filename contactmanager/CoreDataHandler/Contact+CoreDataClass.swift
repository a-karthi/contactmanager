//
//  Contact+CoreDataClass.swift
//  contactmanager
//
//  Created by @karthi on 14/01/22.
//
//

import Foundation
import CoreData

@objc(Contact)
public class Contact: NSManagedObject {
    
    //MARK: - for fetching sorted contacts
    class func fetchSortedContacts(_ ascdening:Bool) -> [Contact] {
        
        var contacts = [Contact]()

        let viewContext = CoreDataHandler.shared.viewContext

        let fetchRequest = Contact.fetchRequest()
        
        //Sort description can be changable depends up on usage
        
        let sort = NSSortDescriptor(key: "name", ascending: ascdening)

        fetchRequest.sortDescriptors = [sort]
        
        do {
            contacts = try viewContext.fetch(fetchRequest)
        } catch {
            print("Failed to retrieve record")
        }
        
        return contacts
    }
    
    //MARK: - for fetch Begins With Particular Letter
    class func fetchBeginWithLetter(_ letter:String) -> [Contact] {
        
        var contacts = [Contact]()

        let viewContext = CoreDataHandler.shared.viewContext

        let fetchRequest = Contact.fetchRequest()
        
        fetchRequest.predicate = NSPredicate(format: "name BEGINSWITH %@", letter)
        
        do {
            contacts = try viewContext.fetch(fetchRequest)
        } catch {
            print("Failed to retrieve record")
        }
        
        return contacts
    }
    
    
    //MARK: - for fetching over all contacts
    class func fetchOverAllContacts() -> [Contact] {
        
        var contacts = [Contact]()

        let viewContext = CoreDataHandler.shared.viewContext

        let fetchRequest = Contact.fetchRequest()
        
        let sort = NSSortDescriptor(key: "position", ascending: true)

        fetchRequest.sortDescriptors = [sort]
        
        do {
            contacts = try viewContext.fetch(fetchRequest)
        } catch {
            print("Failed to retrieve record")
        }
        
        return contacts
    }
    
    
    //MARK: - for searching a particular contact with name and company name
    class func searchContacts(_ queryString:String) -> [Contact] {
        
        var contacts = [Contact]()

        let viewContext = CoreDataHandler.shared.viewContext

        let fetchRequest = Contact.fetchRequest()
        
        let predicate = NSPredicate(format: "name contains[c] %@ || company contains[c] %@", queryString,queryString)

        fetchRequest.predicate = predicate
        
        do {
            contacts = try viewContext.fetch(fetchRequest)
            print(contacts)
        } catch {
            print("Failed to retrieve record")
        }
        
        return contacts
    }
    
    //MARK: - for fetching a particular contact with unique name
    
    class func fetchParticularContact(for name: String) -> Contact? {

        let viewContext = CoreDataHandler.shared.viewContext

        let request = Contact.fetchRequest() as NSFetchRequest

        let predicate = NSPredicate(format: "%K = %@", "name", name)

        request.predicate = predicate

        request.fetchLimit = 1
        
        do {
            let contacts = try viewContext.fetch(request)
            if let object = contacts.first {
                return object
            }
        } catch {
            print("Failed to retrieve record")
        }
        
        return nil
    }
    
    //MARK: - for deleting a particular contact with unique name
    
    class func deleteContact(_ contact:Contact) {

        let viewContext = CoreDataHandler.shared.viewContext

        let fetchRequest = Contact.fetchRequest()
        
        guard let string = contact.name else {return}
        
        let predicate = NSPredicate(format: "%K = %@", "name", string)

        fetchRequest.predicate = predicate
        
        do {
            let contactToDelete = try viewContext.fetch(fetchRequest) as [NSManagedObject]
            if let object = contactToDelete.first {
                CoreDataHandler.shared.viewContext.delete(object)
            }
        } catch {
            print("Failed to retrieve record")
        }
        
        CoreDataHandler.shared.saveContext()
    }
    
    //MARK: - this function checks contact are already exist
    
    class func isExist(_ name:String) -> Bool {

        let contacts = self.fetchOverAllContacts()
        
        let searchResults = contacts.filter({$0.name == name})
        
        return searchResults.count >= 1

    }
    
    //MARK: - returns new object for insert
    
    class func getContactCoreDataObject() -> Contact?{
        
        let contactCoreDataObject = NSEntityDescription.insertNewObject(forEntityName: "Contact", into: CoreDataHandler.shared.viewContext) as? Contact
        return contactCoreDataObject
        
    }

}
