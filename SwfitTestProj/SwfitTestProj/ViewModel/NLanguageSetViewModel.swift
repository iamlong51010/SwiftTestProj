//
//  NLanguageSetViewModel.swift
//  SwfitTestProj
//
//  Created by mac on 2020/8/30.
//  Copyright © 2020 mac. All rights reserved.
//

import Foundation
import SwiftUI
import RxSwift

class NLanguageSetViewModel: BaseViewModel, ObservableObject {
    
    override init() {
        super.init()
    }
    
    override init(view: Any?) {
        super.init(view: view)
    }
    
    var languageList : [String] {
        return SentenceData.kLanguageList
    }
    
    func clickOnLanguage(language:Int) -> Void {
        UserData.globalGetIns().setLanguage(language: language)
        if let canCloseView = self.view as? CloseSelfProtocol {
            canCloseView.close()
        }
    }
}
