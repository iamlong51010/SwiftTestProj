//
//  NHomeViewModel.swift
//  SwfitTestProj
//
//  Created by mac on 2020/8/30.
//  Copyright © 2020 mac. All rights reserved.
//

import Foundation
import SwiftUI
import RxSwift

class NHomeViewModel : BaseViewModel, ObservableObject, RecordClickProtocol {
    
    var userData : UserData {
        return UserData.globalGetIns()
    }
    var curShowSheetType : Int = 1 //1:打开语言选择,2:记录详情界面
    var reqRecordWillSeeDetail : RequestRecord?
    
    private let disposeBag = DisposeBag()
    private var subscriber : Disposable?
    
    override init() {
        super.init()
        self.initSubscriberIfNeed()
    }

    override init(view: Any?) {
        super.init(view: view)
        self.initSubscriberIfNeed()
    }
    
    func initSubscriberIfNeed() {
        
        if self.subscriber == nil {
            self.subscriber = UserData.globalGetIns().pubSubjectRecordList
            .subscribe(onNext: { message in
                if self.bHandleSubscriber {
                    DispatchQueue.main.async(execute: {
                        self.objectWillChange.send()
                    })
                }
            }, onError: { error in
            }, onCompleted: {
            }, onDisposed: {
            })
            self.subscriber?.disposed(by: self.disposeBag)
        }
    }
    
    func onClickRecord(reqRecord: RequestRecord?) {
        if reqRecord == nil {
            self.reqRecordWillSeeDetail = nil
        } else {
            self.reqRecordWillSeeDetail = reqRecord!.copy()
        }
        self.curShowSheetType = 2
        if let canPopView = self.view as? PopUIProtocol {
            canPopView.popSomething()
        }
    }
    
    func onClickLanguageSelect() {
        self.curShowSheetType = 1
        if let canPopView = self.view as? PopUIProtocol {
            canPopView.popSomething()
        }
    }
}
