//
//  productModel.swift
//  Bookstore
//
//  Created by Johnny Yang on 12/5/22.
//

import Foundation
import FirebaseFirestoreSwift
import FirebaseFirestore

class productModel {
    static var shared:productModel = productModel()
    var products:[product]
    var currentProduct:product?
    
    // Initialize products to an empty array
    init() {
        products = []
    }
    
    // Retrieve information of documents from firestore and store in products list
    func getProducts(onSuccess: @escaping () -> Void){
        let collectionRef = Firestore.firestore().collection("products")
        collectionRef.getDocuments(){ (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                self.products = []
                for document in querySnapshot!.documents {
                    do {
                        let tempProduct = try document.data(as: product.self)
                        self.products.append(tempProduct)
                        print(tempProduct.reviews)
                    }
                    catch {
                        print(error)
                        return
                    }
                }
                onSuccess()
            }
        }
    }
    
    // Store the new version of current product to Firestore
    func updateCurrentProduct(){
        let encoder = JSONEncoder()
        var JSONArray = [Any]()
        if let p = currentProduct{
            for review in p.reviews{
                do{
                    let Jsondata = try encoder.encode(review)
                    let Jsonobject = try JSONSerialization.jsonObject(with: Jsondata)
                    JSONArray.append(Jsonobject)
                }
                catch{
                    print(error)
                    return
                }
            }
            let productRef = Firestore.firestore().collection("products").document(p.UID!)
            productRef.setData([
                "name":p.name,
                "price":p.price,
                "description":p.description,
                "imageURL":p.imageURL,
                "rating":p.rating,
                "reviews":JSONArray])
        }
    }
}
