//
//  HttpAccessMgr.swift
//  SwfitTestProj
//
//  Created by mac on 2020/8/22.
//  Copyright © 2020 mac. All rights reserved.
//

import Foundation
import UIKit

final class HttpAccessMgr {
    
    private var accessThread : Thread? = nil
    var accessThreadCondition : NSCondition = NSCondition()
    
    private init() {
    }
    static var g_data : HttpAccessMgr? = nil
    static func globalGetIns() -> HttpAccessMgr {
        if HttpAccessMgr.g_data == nil {
            HttpAccessMgr.g_data = HttpAccessMgr()
        }
        return HttpAccessMgr.g_data!
    }
    
    func startAccess() {
        if self.accessThread == nil {
            self.accessThread = Thread(target: self, selector: #selector(run), object: nil)
        }
        self.accessThread!.start()
    }
    
    @objc private func run() {
        while true {
            Thread.sleep(forTimeInterval: 5)
            
            HttpMgr.GlobalHttpGet(urlstr: HttpMgr.kHttpUrlTest, success: { (strData) in
                //print("___cur req data is:\(strData)")
                
                DispatchQueue.main.async(execute: {
                    self.accessThreadCondition.lock()
                    _ = UserData.globalGetIns().addReqRecord(date: Date(), content: strData)
                    self.accessThreadCondition.unlock()
                    self.accessThreadCondition.signal()
                })
            }, fail: { (error) in
                /*
                if error != nil {
                    print("___cur req error is: \(error!)")
                } else {
                    print("___cur req error is: nil")
                }
                */
                self.accessThreadCondition.signal()
            })
            self.accessThreadCondition.wait()
        }
    }
}





