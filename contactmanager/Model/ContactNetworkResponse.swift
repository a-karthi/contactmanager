//
//  ContactNetworkResponse.swift
//  contactmanager
//
//  Created by @karthi on 14/01/22.
//

import Foundation


public var Alphabets = ["A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z"]

struct ContactNetworkResponse: Codable {
    let name, phone, email, address: String
    let zip, country: String
    let id: Int
    let company: String
    let photo: String
    let age: Int
}

struct AlphabetModel {
    let letter:String
    let contacts:[Contact]
}
