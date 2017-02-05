//
//  HttpController.swift
//  DBFM
//
//  Created by 包笛 on 2017/2/4.
//  Copyright © 2017年 包笛. All rights reserved.
//

import UIKit
import Alamofire

class HttpController:NSObject{
    
    var delegate:HttpProtocol?
    func onSearch(url:String){
        Alamofire.request(url).responseJSON { (data) in
            self.delegate?.didRecieveResults(results: data.value as AnyObject)
        }
    }
}

protocol HttpProtocol {
    func didRecieveResults(results:AnyObject)
}
