//
//  Item.swift
//  Todoey
//
//  Created by Kelly Hsieh on 3/31/18.
//  Copyright © 2018 Kelly Hsieh. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var done: Bool = false
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items") //under Realm, the inverse relationsjip has to be declared too. Note "Category" is the class not the type, so you need to add .self
     //property asks for the name of the forwarding relationship, here, items
    @objc dynamic var dateCreated: Date?
    
    
}
