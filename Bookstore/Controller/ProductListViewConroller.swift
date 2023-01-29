//
//  ProductListViewConroller.swift
//  Bookstore
//
//  Created by Johnny Yang on 12/4/22.
//

import Foundation
import UIKit
import Kingfisher

class ProductListViewController:UICollectionViewController,UICollectionViewDelegateFlowLayout{
    @IBOutlet weak var signout: UIButton!
    
    // Give number of sections in collection view
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    // Give number of elements in the collection
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return productModel.shared.products.count
    }
    
    // Construct corresponding cells based on current products available
    override func collectionView(_ collectionView:UICollectionView, cellForItemAt indexPath:IndexPath)->UICollectionViewCell{
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "productCell", for: indexPath) as! productCell
        let product = productModel.shared.products[indexPath.row]
        cell.productImage.kf.setImage(with: URL(string: product.imageURL))
        cell.productName.text = product.name
        cell.productPrice.text = String(product.price)
        cell.productRating.text = String(format: "%.1f", product.rating)
        return cell
    }
    
    // Set currentProduct before entering details page
    override func prepare(for segue:UIStoryboardSegue,sender:Any?){
        if segue.identifier == "showDetails"{
            let rownum = self.collectionView.indexPathsForSelectedItems!.first!.row
            productModel.shared.currentProduct = productModel.shared.products[rownum]
        }
    }
    
    // Set size of cells
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let noOfCellsInRow = 2

        let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout

        let totalSpace = flowLayout.sectionInset.left
            + flowLayout.sectionInset.right
            + (flowLayout.minimumInteritemSpacing * CGFloat(noOfCellsInRow-1))

        let size = Int((collectionView.bounds.width - totalSpace) / CGFloat(noOfCellsInRow))

        return CGSize(width: size, height: size)
    }
    
    // When entering this page, update current product to remote DB and refresh the list of products we have
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        productModel.shared.updateCurrentProduct()
        productModel.shared.getProducts(onSuccess: {})
        self.collectionView?.reloadData()
    }
    
    // Return to login page
    @IBAction func Signout(_ sender: UIButton) {
        self.dismiss(animated:true, completion:nil)
        performSegue(withIdentifier: "logout", sender: nil)
    }
}
