//
//  Contact+CoreDataProperties.swift
//  contactmanager
//
//  Created by @karthi on 14/01/22.
//
//

import Foundation
import CoreData


extension Contact {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Contact> {
        return NSFetchRequest<Contact>(entityName: "Contact")
    }

    @NSManaged public var name: String?
    @NSManaged public var company: String?
    @NSManaged public var email: String?
    @NSManaged public var phone: String?
    @NSManaged public var age: Int16
    @NSManaged public var id: Int16
    @NSManaged public var address: String?
    @NSManaged public var zip: String?
    @NSManaged public var country: String?
    @NSManaged public var photo: Data?
    @NSManaged public var photoString: String?
    @NSManaged public var position: Int16

}

extension Contact : Identifiable {

}
