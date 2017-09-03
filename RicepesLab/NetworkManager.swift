//
//  File.swift
//  RicepesLab
//
//  Created by Dmitriy Yurchenko on 01.09.17.
//  Copyright © 2017 DYFiJ. All rights reserved.
//

import Foundation
import Alamofire

class NetworkManager {
    
    enum NetworkConstances:String {
        case baseURLString = "http://recipepuppy.com/"
         case baseAPI = "api/"
    }
    
    fileprivate class func getRequest(path: String , complete: @escaping(_ completeInfo: NSDictionary?, _ errorMessage: String?) -> Void) {
        
        Alamofire.request (NetworkConstances.baseURLString.rawValue + NetworkConstances.baseAPI.rawValue + path).responseJSON  { response in
            
            if response.error != nil {
                complete(nil, response.error?.localizedDescription)
            }
            else {
                complete(response.result.value as? NSDictionary, nil)
            }
        }
    }
    
    class func getAllRiceps(complete: @escaping(_ items: NSArray?, _ errorMessage: String?) -> Void) {
        
        getRequest(path: "?i=onions,garlic&q=omelet&p=3") { (info, errorMessage) in
            
            complete(info?["results"] as? NSArray, errorMessage)
            UserDefaults.standard.object(forKey: "AllRiceps")
        }
    }
    
    class func getSearchRequest(searchKey: String,complete: @escaping(_ items: NSArray?, _ errorMessage: String?) -> Void){
        
        let key = searchKey.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        
        getRequest(path: "?q=\(key)") { (info, errorMessage) in
            complete(info?["results"] as? NSArray, errorMessage)
        }
        
    }
}















