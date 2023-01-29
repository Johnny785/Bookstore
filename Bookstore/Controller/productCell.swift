//
//  productCell.swift
//  Bookstore
//
//  Created by Johnny Yang on 12/5/22.
//

import Foundation
import UIKit

// Collection view cell for product list display
class productCell:UICollectionViewCell{
    @IBOutlet weak var productImage: UIImageView!
    
    @IBOutlet weak var productRating: UILabel!
    
    @IBOutlet weak var productPrice: UILabel!
    
    @IBOutlet weak var productName: UILabel!
}
