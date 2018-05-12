//
//  DDRequestManager.swift
//  ZDLao
//
//  Created by WY on 2017/10/17.
//  Copyright © 2017年 com.16lao. All rights reserved.
//app address : https://itunes.apple.com/us/app/%e7%8e%89%e9%be%99%e4%bc%a0%e5%aa%92/id1335870775?l=zh&ls=1&mt=8
/*
 status = 1;
 id = 4;
 name = JohnLock;
 token = 5ebfcf173717960b25b270f06c401d20;
 avatar = http://f0.ugshop.cn/FilF9WGuUGZW5eX-WtfvpFoeTsaY;
 */

import UIKit
import Alamofire
import CoreLocation

enum DomainType : String  {

    case release  = "http://172.16.2.39:8080/"
    case release2  = "http://172.16.2.39:8181/"
}
class DDRequestManager: NSObject {
    let version = ""
//    let client = COSClient.init(appId: "1255626690", withRegion: "sh")
    var token : String? = "token"
    static let share : DDRequestManager = {
        let mgr = DDRequestManager()
        mgr.setSafe()
        mgr.result.session.configuration.timeoutIntervalForRequest = 10
        return mgr
    }()
    func setSafe()  {
//        let manager = Alamofire.
        Alamofire.SessionManager.default.delegate.sessionDidReceiveChallenge =  { session, challenge in
            var disposition = URLSession.AuthChallengeDisposition.performDefaultHandling
            var credential: URLCredential?

            if challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust {
                disposition = URLSession.AuthChallengeDisposition.useCredential
                credential = URLCredential(trust: challenge.protectionSpace.serverTrust!)
            } else {
                if challenge.previousFailureCount > 0 {
                    disposition = .cancelAuthenticationChallenge
                } else {
                    credential = Alamofire.SessionManager.default.session.configuration.urlCredentialStorage?.defaultCredential(for: challenge.protectionSpace)

                    if credential != nil {
                        disposition = .useCredential
                    }
                }
            }

            return (disposition, credential)
        }
    }
    let result = SessionManager.default
    private func performRequest(url : String,method:HTTPMethod , parameters: Parameters? ,  print : Bool = false  ) -> DataRequest? {
        if let status = NetworkReachabilityManager(host: "www.baidu.com")?.networkReachabilityStatus{
            switch status {
            case .notReachable:
//                GDAlertView.alert("连接失败,请检查网络后重试", image: nil, time: 3, complateBlock: nil )
                return nil
            case .unknown :
//                GDAlertView.alert("连接失败,请检查网络后重试", image: nil, time: 3, complateBlock: nil )
                return nil
            case .reachable(NetworkReachabilityManager.ConnectionType.ethernetOrWiFi):
                break
            case .reachable(NetworkReachabilityManager.ConnectionType.wwan):
                break
            }
        }
        
        
        var parameters = parameters == nil ? Parameters() : parameters!

        let url = (DomainType.release.rawValue + version) + url
        if let url  = URL(string: url){
            let result = Alamofire.request(url , method: method , parameters: parameters ).responseJSON(completionHandler: { (response) in
//                if print{mylog(response.debugDescription.unicodeStr)}
                switch response.result{
                case .success :
                    break
                    
                case .failure :
//                    mylog(response.debugDescription.unicodeStr)
//                    GDAlertView.alert("请求失败,请重试", image: nil , time: 2, complateBlock: nil )//请求超时处理
                    break
                }
            })
            return result
        
        }else{return nil }
    }
    func testRequestPerfect()  {
        let url = DomainType.release2.rawValue + "hello?name=heikeheike"
        if let url  = URL(string: url){
            let result = Alamofire.request(url , method: .get , parameters: nil ).responseJSON(completionHandler: { (response) in
                mylog(response.value)
                //                if print{mylog(response.debugDescription.unicodeStr)}
                switch response.result{
                case .success :
                    break
                    
                case .failure :
                    //                    mylog(response.debugDescription.unicodeStr)
                    //                    GDAlertView.alert("请求失败,请重试", image: nil , time: 2, complateBlock: nil )//请求超时处理
                    break
                }
            })
            
        }
    }
   
    func downloadMp3(musicName:String , complite:(()->())? = nil )  {
        var url = musicName.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlPathAllowed)!
        url = DomainType.release.rawValue + "music/upload/" + url
        let u = URL.init(string: url)!
//        Alamofire.download(URLRequestConvertible) { (<#URL#>, <#HTTPURLResponse#>) -> (destinationURL: URL, options: DownloadRequest.DownloadOptions) in
//            <#code#>
//        }
//        HTTPURLResponse
        Alamofire.download(u) { (url, response ) -> (destinationURL: URL, options: DownloadRequest.DownloadOptions) in
            
            mylog(url )
            mylog(response.debugDescription)
            var  docuPath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).last!
            docuPath = docuPath + "/\(musicName)"
            mylog(docuPath)
            
            return (URL(fileURLWithPath : docuPath), .createIntermediateDirectories);
            }.downloadProgress { (progress) in
                mylog(progress)
                if (progress.completedUnitCount / progress.totalUnitCount) >= 1{
                    complite?();
                    mylog("完成了")
                }
                mylog("总共:\(progress.totalUnitCount)  已下载\(progress.completedUnitCount)")
        }
    }
    @discardableResult
    func request(url : String , method: HTTPMethod, para:[String:String ] , _ print : Bool = false ) -> DataRequest? {
        return  performRequest(url: url , method: method, parameters: para , print : print )
    }
    
    
    
    
    
}

