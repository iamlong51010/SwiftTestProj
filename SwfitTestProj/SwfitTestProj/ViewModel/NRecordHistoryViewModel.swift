//
//  NRecordHistoryViewModel.swift
//  SwfitTestProj
//
//  Created by mac on 2020/8/30.
//  Copyright © 2020 mac. All rights reserved.
//

import Foundation
import SwiftUI
import RxSwift

class NRecordHistoryViewModel : BaseViewModel, ObservableObject, RecordClickProtocol {
    static let kRefreshThreshold : CGFloat = 60.0
    static let kOnePageCount : Int = 5
    
    var userData : UserData {
        return UserData.globalGetIns()
    }
    
    @Published var curLoadPageIndex : Int = -1
    @Published var recentRecordStartIndex : Int = -1
    @Published var recentRecordEndIndex : Int = -1
    @Published var recentRecordSeeEndIndex : Int = -1
    
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
    
    override func onAppear() {
        super.onAppear()
        self.refreshRecentRecordStartEndInfo()
        self.refreshRecentRecordSeeEndInfo()
        self.initCurLoadPageIndex()
    }
    
    func initSubscriberIfNeed() {
        if self.subscriber == nil {
            self.subscriber = UserData.globalGetIns().pubSubjectRecordList
            .subscribe(onNext: { message in
                if self.bHandleSubscriber {
                    if message == .recordlistchange {
                        self.refreshRecentRecordStartEndInfo()
                    }
                    self.objectWillChange.send()
                }
            }, onError: { error in
            }, onCompleted: {
            }, onDisposed: {
            })
            self.subscriber?.disposed(by: self.disposeBag)
        }
    }
    
    func refreshRecentRecordStartEndInfo() -> Void {
        if self.userData.arrReqRecord.count > 0 {
            self.recentRecordStartIndex = 0
            self.recentRecordEndIndex = self.userData.arrReqRecord.count-1
        } else {
            self.recentRecordStartIndex = -1
            self.recentRecordEndIndex = -1
        }
    }
    func refreshRecentRecordSeeEndInfo() -> Void {
        if self.userData.arrReqRecord.count > 0 {
            self.recentRecordSeeEndIndex = self.userData.arrReqRecord.count-1
        } else {
            self.recentRecordSeeEndIndex = -1
        }
    }
    
    func onClickRecord(reqRecord: RequestRecord?) {
        if reqRecord == nil {
            self.reqRecordWillSeeDetail = nil
        } else {
            self.reqRecordWillSeeDetail = reqRecord!.copy()
        }
        if let popUIView = self.view as? PopUIProtocol {
            popUIView.popSomething()
        }
    }
    
    var seeRecordIndexReverseList : [Int] {
        var result = Array<Int>()
        if self.recentRecordStartIndex >= 0 && self.recentRecordSeeEndIndex >= self.recentRecordStartIndex && self.curLoadPageIndex >= 0 {
            
            var startIndex = self.recentRecordSeeEndIndex - ((self.curLoadPageIndex+1)*NRecordHistoryViewModel.kOnePageCount - 1)
            if startIndex < self.recentRecordStartIndex {
                startIndex = self.recentRecordStartIndex
            }
            result = (startIndex...self.recentRecordSeeEndIndex).reversed()
        }
        //print("----result is \(result)")
        return result
    }
    
    var isHaveNewFunc : Bool {
        if self.recentRecordEndIndex >= 0 && self.recentRecordEndIndex > self.recentRecordSeeEndIndex {
            return true
        } else {
            return false
        }
    }
    
    func handleRefresh(values: [RefreshableTypes.PrefData]) {
        let movingBounds = values.first(where: {$0.vType == .movingView})?.bounds ?? .zero
        let fixedBounds = values.first(where: {$0.vType == .fixedView})?.bounds ?? .zero
        let offset = movingBounds.minY - fixedBounds.minY
        if offset > NRecordHistoryViewModel.kRefreshThreshold && self.isHaveNewFunc {
            self.refreshRecentRecordSeeEndInfo()
            self.initCurLoadPageIndex()
        }
    }
    
    func getTotalSeeRecordCt() -> Int {
        var totalNeedCt : Int = 0
        if self.recentRecordStartIndex >= 0 && self.recentRecordSeeEndIndex >= self.recentRecordStartIndex {
            totalNeedCt = self.recentRecordSeeEndIndex - self.recentRecordStartIndex + 1
        }
        return totalNeedCt
    }
    
    func getCanLoadPageCt() -> Int {
        let totalNeedCt = self.getTotalSeeRecordCt()
        var totalPages = 0
        if totalNeedCt > 0 {
            totalPages = 1 + (totalNeedCt-1)/NRecordHistoryViewModel.kOnePageCount
        }
        return totalPages
    }
    
    func initCurLoadPageIndex() {
        let totalPages = self.getCanLoadPageCt()
        if totalPages > 0 {
            self.curLoadPageIndex = 0
        } else {
            self.curLoadPageIndex = -1
        }
    }
    
    func loadMoreWithNoNewMsg() {
        let totalPages = self.getCanLoadPageCt()
        if totalPages <= 0 {
            self.curLoadPageIndex = -1
        } else if self.curLoadPageIndex < 0 {
            self.curLoadPageIndex = 0
        } else {
            if self.curLoadPageIndex < (totalPages-1) {
                self.curLoadPageIndex += 1
            }
        }
    }
    
    var isLoadOverWithNoNewMsg : Bool {
        if self.curLoadPageIndex >= 0 && self.curLoadPageIndex >= (self.getCanLoadPageCt()-1) {
            return true
        } else {
            return false
        }
    }
}
