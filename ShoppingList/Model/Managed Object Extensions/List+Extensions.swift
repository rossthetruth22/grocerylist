//
//  List+Extensions.swift
//  ShoppingList
//
//  Created by Royce Reynolds on 5/8/18.
//  Copyright © 2018 Royce Reynolds. All rights reserved.
//

import Foundation
import CoreData

extension List{
    public override func awakeFromInsert() {
        super.awakeFromInsert()
        creationDate = Date()
    }
}
