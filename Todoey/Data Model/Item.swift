//
//  Item.swift
//  Todoey
//
//  Created by Matthew Davis on 2019/05/26.
//  Copyright © 2019 Matthew Davis. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var done: Bool = false
    @objc dynamic var dateCreated: String = ""
    
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
