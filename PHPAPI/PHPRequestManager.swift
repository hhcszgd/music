//
//  PHPRequestManager.swift
//  PHPAPI
//
//  Created by WY on 2018/3/19.
//  Copyright © 2018年 HHCSZGD. All rights reserved.
//

import UIKit
class PHPRequestManager : NSObject, URLSessionDelegate{
    static let share = PHPRequestManager()
    var sessiono : URLSession?
    
    func add()  {
        let url = URL(string: "http://127.0.0.1:8080/test/add.php")!
        var  request = NSMutableURLRequest(url: url )
        request.httpMethod = "POST"
        request.timeoutInterval = 5
        let dict : [String : String  ] = ["zhang":"小史" , "lastname":"赵"]
        let encode = JSONEncoder.init()
        do {
            let data = try encode.encode(dict )
            let a = String.init(data: data , encoding: String.Encoding.utf8)
            mylog("hello : \(a!)")
            request.httpBody = data
            if let dd = DDDecode([String:String].self , from: data){
                mylog(dd)
            }
//            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.setValue("application/x-www-form-urlencoded; charset=utf-8", forHTTPHeaderField: "Content-Type")
            mylog(request.httpBody)
            mylog(request.allHTTPHeaderFields)
//            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            //        let params
            
            var  session1 = URLSession(configuration: URLSessionConfiguration.default, delegate: self , delegateQueue: OperationQueue.main)
            self.sessiono = session1
            let dataTask = session1.dataTask(with: url) { (data , response , error ) in
                let result = String.init(data: data! , encoding: String.Encoding.utf8)
                mylog(result )
                if let model = DDDecode([SelectModel].self , from: data ?? Data() ){
                    //                mylog(model)
                    for m in model{
                        mylog(m.id)
                    }
                }
                //            mylog("\(data )-|-\(response)-|-\(error )")
            }
            //        let dataTask = session1.dataTask(with: request){ (data , response , error ) in
            //            mylog("\(data )--\(response)--\(error )")
            //        }
            dataTask.resume()
        } catch  {
            mylog(error     )
        }
        
        
    }
    
    
    func test() {
//        let url = URL(string: "https://wy.local/select.php")!
        let url = URL(string: "http://127.0.0.1:8080/test/select.php")!
        let request = NSMutableURLRequest(url: url )
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        //        let params
        
        var  session1 = URLSession(configuration: URLSessionConfiguration.default, delegate: self , delegateQueue: OperationQueue.main)
        self.sessiono = session1
        let dataTask = session1.dataTask(with: url) { (data , response , error ) in
            let result = String.init(data: data ?? Data() , encoding: String.Encoding.utf8)
//            mylog(result )
            if let model = DDDecode([SelectModel].self , from: data ?? Data() ){
//                mylog(model)
                for m in model{
                    mylog("\(m.lastname) \(m.firstname) \(m.id)")
                }
            }else{
                mylog("data is nill")
            }
//            mylog("\(data )-|-\(response)-|-\(error )")
        }
        //        let dataTask = session1.dataTask(with: request){ (data , response , error ) in
        //            mylog("\(data )--\(response)--\(error )")
        //        }
        dataTask.resume()
    }
    func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Swift.Void){
        if challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust {
            let card = URLCredential(trust: challenge.protectionSpace.serverTrust!)
            completionHandler(URLSession.AuthChallengeDisposition.useCredential , card )
        }
    }
    
    func urlSession(_ session: URLSession, didBecomeInvalidWithError error: Error?){
        mylog(error)
    }
}

