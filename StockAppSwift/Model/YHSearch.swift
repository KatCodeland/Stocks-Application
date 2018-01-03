//
//  YHSearch.swift
//  StockAppSwift
//
//  Created by user131645 on 10/31/17.
//  Copyright © 2017 SenecaCollege. All rights reserved.
//

import Foundation

//delegate protocol
protocol SearchDelegate: class {
    func searchDidFinishWith(resultArray: [[String:String]])
}

class YHSearch{
    //declare delegate property
    weak var  delegate:SearchDelegate?
    
    func searchWithString(searchKey:String) {
        
       
        let session: URLSession = { //property holds an instance or a URL session
            let config = URLSessionConfiguration.default
            return URLSession(configuration: config)
        }()
        
        //create a URL request
        
        let url = NSURL(string: "http://d.yimg.com/autoc.finance.yahoo.com/autoc?query="+searchKey+"&region=1&lang=en&callback=YAHOO.Finance.SymbolSuggest.ssCallback")! as URL
        
        let request = URLRequest(url: url)
        
        //transfer request to server with dataTask & parse out data
        let task = session.dataTask(with: request) {//no need to crete queue as session data task runs request on background thread
            
            (data, response, error) -> Void in
            
            if let jsonData = data {
                do {
                    var jsonString =  String(data: jsonData, encoding: String.Encoding.utf8)
                    
                    jsonString?.removeFirst(39)
                    jsonString?.removeLast(2)
                    
                    let newJsonData = jsonString?.data(using: String.Encoding.utf8)
                    
                    
                    //serialize to get a dictionary of the data
                    let jsonObject = try JSONSerialization.jsonObject(with: newJsonData!,
                                                                      options: []) as! [String:AnyObject]
                    
                    let resultSetArray = jsonObject["ResultSet"] as! [String: Any]//get values for ResultSet key
                    let resultArray = resultSetArray["Result"] as! [[String: String]]//get value for Result key from the result set array
                    
                    
                    OperationQueue.main.addOperation {//return thread back to the main
                        self.delegate?.searchDidFinishWith(resultArray: resultArray) //call method defined in delegate to communicate back to searchcontroller
                    }
                    
                } catch let error {
                    print("Error creating JSON object: \(error)")
                }
            } else if let requestError = error {
                print("Error fetching interesting photos: \(requestError)")
            } else {
                print("Unexpected error with the request")
            }
        }
        task.resume()
    }
}
