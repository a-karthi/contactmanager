//
//  CoreDataHandler.swift
//  contactmanager
//
//  Created by @karthi on 14/01/22.
//

import Foundation
import CoreData
import UIKit

class CoreDataHandler {
    
    static let shared = CoreDataHandler()
    
    /// Shared persistant container
    public lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Contact")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    /// Shared core data context
    public lazy var viewContext: NSManagedObjectContext = {
        
        let viewContext = persistentContainer.viewContext
        return viewContext
        
    }()
    
    /// Save Context
    public func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
        
    }

    
}
