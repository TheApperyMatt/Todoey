//
//  Category.swift
//  Todoey
//
//  Created by Matthew Davis on 2019/05/26.
//  Copyright © 2019 Matthew Davis. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name: String = ""
    let items = List<Item>()
}
