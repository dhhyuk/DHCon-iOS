//
//  SelectImageCollectionCell.swift
//  DHCon
//
//  Created by 김동혁 on 09/01/2019.
//  Copyright © 2019 김동혁. All rights reserved.
//

import UIKit

class SelectImageCollectionCell: UICollectionViewCell {
    public static let CellId = "SelectImageCollectionCell"
    
    @IBOutlet weak var image: UIImageView!

    var representedAssetIdentifier: String!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
