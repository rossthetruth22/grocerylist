//
//  Item+Extensions.swift
//  ShoppingList
//
//  Created by Royce Reynolds on 5/8/18.
//  Copyright © 2018 Royce Reynolds. All rights reserved.
//

import Foundation
import CoreData

extension Item{
    public override func awakeFromInsert() {
        super.awakeFromInsert()
        dateAdded = Date()
    }
}
