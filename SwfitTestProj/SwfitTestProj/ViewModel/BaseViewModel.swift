//
//  BaseViewModel.swift
//  SwfitTestProj
//
//  Created by mac on 2020/8/30.
//  Copyright © 2020 mac. All rights reserved.
//

import Foundation
import SwiftUI

class BaseViewModel {
    var view : Any?
    var bHandleSubscriber : Bool = false
    
    init(view: Any?) {
        self.view = view
    }

    init() {
    }

    func setView(view: Any?) {
        self.view = view
    }
    
    func onAppear() {
        self.bHandleSubscriber = true
    }
    
    func onDisappear() {
        self.bHandleSubscriber = false
    }
}
