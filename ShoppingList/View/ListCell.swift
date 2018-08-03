//
//  ListCell.swift
//  ShoppingList
//
//  Created by Royce Reynolds on 5/3/18.
//  Copyright © 2018 Royce Reynolds. All rights reserved.
//

import UIKit

class ListCell: UITableViewCell {

    
    @IBOutlet weak var itemCount: UILabel!
    @IBOutlet weak var listName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        itemCount.text = nil
        listName.text = nil
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
