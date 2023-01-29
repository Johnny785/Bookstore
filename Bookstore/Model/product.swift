//
//  product.swift
//  Bookstore
//
//  Created by Johnny Yang on 12/5/22.
//

import Foundation
import FirebaseFirestoreSwift
import FirebaseFirestore

// Product information
struct product:Codable{
    let imageURL:String
    let name:String
    let price:Double
    let description:String
    var rating:Double
    var reviews:[review]
    @DocumentID var UID:String?
}
