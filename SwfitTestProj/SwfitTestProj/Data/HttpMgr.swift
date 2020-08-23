//
//  HttpMgr.swift
//  SwfitTestProj
//
//  Created by mac on 2020/8/22.
//  Copyright © 2020 mac. All rights reserved.
//

import Foundation

final class HttpMgr {
    
    static let kHttpUrlTest = "https://api.github.com/"
    
    static func GlobalHttpPost(urlstr: String, params: [String: String]?, success: @escaping (_ result : String) -> Void, fail: @escaping (_ error : Error?) -> Void) {
        
        if urlstr.isEmpty {
            fail(nil)
            return
        }
        
        let url = URL(string: urlstr)
        var request = URLRequest.init(url: url!)
        request.httpMethod = "POST"

        var paramStr = ""
        if params != nil{
            for currentParam in params! {
                paramStr += (currentParam.key + "=" + currentParam.value + ";")
            }
        }
        request.httpBody = paramStr.data(using: .utf8)

        let session = URLSession.shared
        let dataTask = session.dataTask(with: request) { (data, respond, error) in
            var result : String? = nil
            if data != nil {
                result = String(data:data!,encoding:.utf8)
            }
            if result != nil {
                success(result!)
            } else {
                fail(error)
            }
        }
        dataTask.resume()
    }
    
    static func GlobalHttpGet(urlstr: String, success: @escaping (_ result : String) -> Void, fail: @escaping (_ error : Error?) -> Void) {
        if urlstr.isEmpty {
            fail(nil)
            return
        }
        
        let url = URL(string: urlstr.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)
        let session = URLSession.shared
        
        let dataTask = session.dataTask(with: url!) { (data, respond, error) in
            var result : String? = nil
            if data != nil {
                result = String(data:data!,encoding:.utf8)
            }
            if result != nil {
                success(result!)
            } else {
                fail(error)
            }
        }
        dataTask.resume()
    }
}

