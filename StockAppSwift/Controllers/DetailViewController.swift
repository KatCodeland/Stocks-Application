//
//  DetailViewController.swift
//  StockAppSwift
//
//  Created by user131645 on 11/2/17.
//  Copyright © 2017 SenecaCollege. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var symbolDisplay: UILabel!
    
    @IBOutlet weak var askDisplay: UILabel!
    
    @IBOutlet weak var changeDisplay: UILabel!
    
    
    @IBAction func reloadDetails() {
        //pass in argument of the symbool of the selected row
        getDetails(pickedSymbol: pickedSymbol)
    }
    
    
    
    var pickedSymbol: String = ""
    
func getDetails(pickedSymbol: String)  {
    
  
   let urlString = "https://query.yahooapis.com/v1/public/yql?q=select%20*%20from%20csv%20where%20url%3D'http%3A%2F%2Fdownload.finance.yahoo.com%2Fd%2Fquotes.csv%3Fs%3DGOOG%2CYHOO%2Caapl%26f%3Dsl1d1t1c1ohgv%26e%3D.csv'%20and%20columns%3D'symbol%2Cprice%2Cdate%2Ctime%2Cchange%2Ccol1%2Chigh%2Clow%2Ccol2'&format=json&diagnostics=true&callback=\(pickedSymbol)"
    let url = URL(string: urlString)
    
    let myDownloader = detailSearch(url: url!)
    
    myDownloader.getData { (data) in
        do{
            let myObj = try JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary
            if let myJsonObj = myObj {
                let symbol = myJsonObj.value(forKeyPath: "results")as? String
                let ask = myJsonObj.value(forKeyPath: "results")as? String
                let change = myJsonObj.value(forKeyPath: "results")as? String
                
                DispatchQueue.main.async {
                    self.symbolDisplay.text = symbol
                    self.askDisplay.text = ask
                    self.changeDisplay.text = change
                }
                
            }
            
        }catch{
             DispatchQueue.main.async {
            self.symbolDisplay.text = pickedSymbol
	          self.askDisplay.text = "not available"
       self.changeDisplay.text = "not available"
            }
        }
    }
    
}
    
    override func viewDidLoad() {
        super.viewDidLoad()
       getDetails(pickedSymbol: pickedSymbol)
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
