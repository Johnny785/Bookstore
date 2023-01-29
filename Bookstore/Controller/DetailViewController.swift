//
//  DetailViewController.swift
//  Bookstore
//
//  Created by Johnny Yang on 12/3/22.
//

import Foundation
import UIKit
import StoreKit

class DetailViewController : UIViewController, SKProductsRequestDelegate,SKPaymentTransactionObserver{
    @IBOutlet weak var pImage: UIImageView!
    @IBOutlet weak var pName: UILabel!
    @IBOutlet weak var pPrice: UILabel!
    @IBOutlet weak var pRating: UILabel!
    @IBOutlet weak var pContent: UILabel!
    @IBOutlet weak var pDescription: UILabel!
    @IBOutlet weak var purchase: UIButton!
    
    // Load the information from the selected product to detailview
    override func viewDidLoad() {
        super.viewDidLoad()
        if let p = productModel.shared.currentProduct{
            pImage.kf.setImage(with: URL(string: p.imageURL))
            pName.text = p.name
            pPrice.text = String(p.price)
            pRating.text = String(p.rating)
            pContent.text = String(p.description)
        }
        else{
            pName.text = "This product is currently unavailable"
            pPrice.text = "This product is currently unavailable"
            pRating.text = "This product is currently unavailable"
            pContent.text = "This product is currently unavailable"
            purchase.isHidden = true
        }
    }
    
    // Purchase product if available
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        if let product = response.products.first{
            print("Product is available")
            purchaseProduct(productToPurchase:product)
        }
        else{
            print("Product is unavailable")
        }
    }
    
    // Give console outputs about whether payment succeeded
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions{
            switch transaction.transactionState{
            case .purchasing:
                print("Purchase IP")
            case .purchased:
                print("Purchase done")
            case .failed:
                print("Purchase failed")
            case .restored:
                print("Purchase restored")
            case .deferred:
                print("Purchase deferred")
            @unknown default:
                break
            }
        }
    }
    
    // Add transaction to queue, called in productRequest
    func purchaseProduct(productToPurchase:SKProduct){
        let payment = SKPayment(product: productToPurchase)
        SKPaymentQueue.default().add(self)
        SKPaymentQueue.default().add(payment)
    }

    // Action to check if payment can go though and give alert otherwise
    @IBAction func buyItem(_ sender: UIButton) {
        if SKPaymentQueue.canMakePayments(){
            let productID:Set<String> = [productModel.shared.currentProduct!.UID!]
            let productRequest = SKProductsRequest(productIdentifiers: productID)
            productRequest.delegate = self
            productRequest.start()
        }
        else{
            let alertController = UIAlertController(title: "Warning", message: "You cannot make purchase with your account, please double check",
            preferredStyle: .alert)
            let OKAction = UIAlertAction(title:"OK", style: .default, handler: nil)
            alertController.addAction(OKAction)
            self.present(alertController, animated:true)
        }
    }
}
