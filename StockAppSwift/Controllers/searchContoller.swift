//
//  searchContoller.swift
//  StockAppSwift
//
//  Created by user131645 on 10/28/17.
//  Copyright © 2017 SenecaCollege. All rights reserved.
//

import UIKit
import CoreData

//protocol for adding Company
protocol addCompanyDelegate: class {
    func addCompDidFinishWith(results: [[String:String]], selectedRow: Int)
}

class searchContoller: UITableViewController,UISearchBarDelegate,SearchDelegate {
    //id for addCompany delegate
    weak var addCompanyDelegate:addCompanyDelegate?
    
    //declare object of app delegate so can access methods within it
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    var results: [[String:String]] = []
    
    //delegate passes in resuts array from model to here
    func searchDidFinishWith(resultArray: [[String:String]]) {
        results = resultArray
        tableView.reloadData()
    }
    

   lazy var myModel = YHSearch()
        
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String){
        //call searchWithString method from model 
       myModel.searchWithString(searchKey: searchText);
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        let myRow: Int = indexPath.row
        
        self.addCompanyDelegate?.addCompDidFinishWith(results: results, selectedRow: myRow)
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myModel.delegate = self

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return results.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "searchCell", for: indexPath)

        var item: Dictionary = results[indexPath.row]
        cell.textLabel?.text = item["name"]
        cell.detailTextLabel?.text = item["symbol"]
//
        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
