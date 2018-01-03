//
//  detailSearch.swift
//  StockAppSwift
//
//  Created by user131645 on 11/2/17.
//  Copyright © 2017 SenecaCollege. All rights reserved.
//

import Foundation
class detailSearch {
    private var url : URL
    private lazy var config : URLSessionConfiguration = URLSessionConfiguration.default
    private lazy var session : URLSession = URLSession(configuration: self.config)
    
    init(url : URL) {
        self.url = url
    }
    
    
    
    func getData(complition : @escaping (Data) -> ()) {
        let task =  session.dataTask(with: url) { (data, response, error) in
            if error == nil{
                if let mydata = data{
                    complition(mydata)
                }
            }
        }
        task.resume()
        
        
    }
    
    
}
