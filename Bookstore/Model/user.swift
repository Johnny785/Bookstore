//
//  user.swift
//  Bookstore
//
//  Created by Johnny Yang on 12/5/22.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

// User information
struct user:Codable{
    let firstName:String
    let lastName:String
    let email:String
    @DocumentID var UID:String?
}
