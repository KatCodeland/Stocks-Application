//
//  TableViewController.swift
//  StockAppSwift
//
//  Created by user131645 on 10/27/17.
//  Copyright © 2017 SenecaCollege. All rights reserved.
//

import UIKit
import CoreData




class TableViewController: UITableViewController,addCompanyDelegate,UISearchBarDelegate {
    
    @IBOutlet weak var favSearch: UISearchBar!
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "first"{
            let nextView = segue.destination as! searchContoller
            nextView.addCompanyDelegate = self
        }
        if segue.identifier == "detailSeg"{
            let nextVC:DetailViewController = segue.destination as! DetailViewController
            nextVC.pickedSymbol = mydata[(self.tableView.indexPathForSelectedRow?.row)!].symbol!
        }
    }
    
    
    lazy var mySearchController = searchContoller()
   
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    var mydata: [Company] = []
    
    
    func addCompDidFinishWith(results: [[String:String]], selectedRow: Int) {
        
        
        //fetch for that symbol and if there are more than zero returns
        //do fetch request with predicate for symbol name and say if they match - do nothing
        //if they dont match insert in context and save
        
        
        let companyName: String = results[selectedRow]["name"]!
        let predicate = NSPredicate(format: "%K MATCHES[c] %@", "name", companyName)
        
        let predRequest:NSFetchRequest<Company> = Company.fetchRequest()
        predRequest.predicate = predicate
        
       let managedObjectContext = appDelegate.persistentContainer.viewContext
        
        do{
            var returnedCompany = try managedObjectContext.fetch(predRequest)
            
            var howMany: Int = returnedCompany.count
            
            if howMany == 0 {
            
//            for i in 0 ..< returnedCompany.count{
//                let theCompany = returnedCompany[i]
//                if theCompany.name != companyName{
                    //creating entity
                    let myCompany: Company = NSEntityDescription.insertNewObject(forEntityName: "Company", into: appDelegate.persistentContainer.viewContext) as! Company //create Company variable = inside variable we have created new object and inserted into a context
                    
                    //set entity attributes
                    myCompany.name = results[selectedRow]["name"]
                    myCompany.symbol = results[selectedRow]["symbol"]
                    //save to core data
                    appDelegate.saveContext()
                    //}
            
        }
           
                }catch{
                    
            }
        
        
  
        //fetch request
        fetchData(request: request)
      }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String){
        if !searchText.isEmpty {
            var searPredicate: NSPredicate = NSPredicate()
            searPredicate = NSPredicate(format: "%K contains[c] %@", "name", searchText)
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
            let managedObjectContext = appDelegate.persistentContainer.viewContext
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName:"Company")
            fetchRequest.predicate = searPredicate
            do {
                mydata = try managedObjectContext.fetch(fetchRequest) as! [NSManagedObject] as! [Company]
             
            } catch let error as NSError {
                print("Could not fetch. \(error)")
            }
        }
        tableView.reloadData()
    }
  
    
    
    
    //fetch request function
    let request:NSFetchRequest<Company> = Company.fetchRequest()
    func fetchData (request: NSFetchRequest<Company>){
        // let request:NSFetchRequest<Company> = Company.fetchRequest()
        
        do{
            mydata = try appDelegate.persistentContainer.viewContext.fetch(request)
        }
        catch {
            print(error)
            
        }
        
        //dismiss view
     self.dismiss(animated: true, completion: nil)
       // navigationController?.popViewController(animated: true)
        
        //reload table
        self.tableView.reloadData()
      
    }
    
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            //get symbol property of row selected
            let item = indexPath.row
            let itemName = mydata[item].name
           
            let managedObjectContext = appDelegate.persistentContainer.viewContext
           
            let predicate = NSPredicate(format: "%K MATCHES[c] %@", "name", itemName!)
          request.predicate = predicate
            
           
            do{
                let toDelete = try managedObjectContext.fetch(request)
                for i in 0 ..< toDelete.count{
                  //print(toDelete[i])
                    let del = toDelete[i]
                    managedObjectContext.delete(del)
                    appDelegate.saveContext()
                    self.tableView.reloadData()
                }
                //}
                }
            catch{
            }
            }
        
      
    }
    
    // MARK: Delete Data Records
    
    func deleteRecords() -> Void {
        let moc = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Company")
        
        let result = try? moc.fetch(fetchRequest)
        let resultData = result as! [Company]
        
        for object in resultData {
            moc.delete(object)
        }
        
        do {
            try moc.save()
            print("saved!")
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        } catch {
            
        }
        
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchData(request: request)
        mySearchController.addCompanyDelegate = self
       favSearch.delegate = self
        //FETCH CORE DATA
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        //  dataBaseController.saveContext()
        
        
        
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
        return self.mydata.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
       
        cell.textLabel?.text = mydata[indexPath.row].name
        cell.detailTextLabel?.text = mydata[indexPath.row].symbol

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
