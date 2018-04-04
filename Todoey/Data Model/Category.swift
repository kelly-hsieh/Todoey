//
//  Category.swift
//  Todoey
//
//  Created by Kelly Hsieh on 3/31/18.
//  Copyright © 2018 Kelly Hsieh. All rights reserved.
//

import Foundation
import RealmSwift


class Category: Object {
    @objc dynamic var name : String = ""
    @objc dynamic var color : String = ""
    let items = List<Item>() //declaration for a List of Items, which is currently empty. 
    
}
