//
//  review.swift
//  Bookstore
//
//  Created by Johnny Yang on 12/6/22.
//

import Foundation
import FirebaseFirestoreSwift
import FirebaseFirestore

// Review information
struct review:Codable{
    let firstName:String
    let lastName:String
    let review:String
    let location:String
}
