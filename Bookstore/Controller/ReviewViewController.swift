//
//  ReviewViewController.swift
//  Bookstore
//
//  Created by Johnny Yang on 12/4/22.
//

import Foundation
import UIKit

class ReviewViewController: UITableViewController{
    @IBOutlet var table: UITableView!
    
    // Set datasource and delegate of tableview
    override func viewDidLoad() {
        super.viewDidLoad()
        table.dataSource=self
        table.delegate=self
    }
    
    // Set number of sections in tableview
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    // Reload data before entering this page
    override func viewWillAppear(_ animated: Bool) {
        self.table.reloadData();
    }
    
    // Give number of elements in the tableview
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return productModel.shared.currentProduct!.reviews.count
    }
    
    // Fetch title and subtitle in a tableview cell
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reviewCell", for: indexPath)
        let review = productModel.shared.currentProduct!.reviews[indexPath.row]
        cell.textLabel?.text = review.firstName+" "+review.lastName+" "+review.location
        // Add country later
        print(review.review)
        cell.detailTextLabel?.text = review.review
        // Configure the cell...
        return cell
    }
    
}
