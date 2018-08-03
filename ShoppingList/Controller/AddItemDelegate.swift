//
//  AddItemDelegate.swift
//  ShoppingList
//
//  Created by Royce Reynolds on 8/1/18.
//  Copyright © 2018 Royce Reynolds. All rights reserved.
//

import Foundation

@objc
protocol AddItemDelegate{
   @objc optional func addGroceryList(name: String)
}
