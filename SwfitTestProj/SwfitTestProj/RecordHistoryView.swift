//
//  RecordHistoryView.swift
//  SwfitTestProj
//
//  Created by mac on 2020/8/21.
//  Copyright © 2020 mac. All rights reserved.
//

import SwiftUI

struct RecordHistoryView: View, RecordClickProtocol {
    @EnvironmentObject var userData : UserData
    static let kRefreshThreshold : CGFloat = 60.0
    static let kOnePageCount : Int = 5
    
    @State var showSheet : Bool = false
    @State var curLoadPageIndex : Int = -1
    @State var reqRecordWillSeeDetail : RequestRecord?
    
    func onClickRecord(reqRecord: RequestRecord?) {
        if reqRecord == nil {
            self.reqRecordWillSeeDetail = nil
        } else {
            self.reqRecordWillSeeDetail = reqRecord!.copy()
        }
        self.showSheet = true
    }
    
    var seeRecordIndexReverseList : [Int] {
        var result = Array<Int>()
        if self.userData.recentRecordStartIndex >= 0 && self.userData.recentRecordSeeEndIndex >= self.userData.recentRecordStartIndex && self.curLoadPageIndex >= 0 {
            
            var startIndex = self.userData.recentRecordSeeEndIndex - ((self.curLoadPageIndex+1)*RecordHistoryView.kOnePageCount - 1)
            if startIndex < self.userData.recentRecordStartIndex {
                startIndex = self.userData.recentRecordStartIndex
            }
            result = (startIndex...self.userData.recentRecordSeeEndIndex).reversed()
        }
        //print("----result is \(result)")
        return result
    }
    
    var isHaveNewFunc : Bool {
        if self.userData.recentRecordEndIndex >= 0 && self.userData.recentRecordEndIndex > self.userData.recentRecordSeeEndIndex {
            return true
        } else {
            return false
        }
    }
    
    func handleRefresh(values: [RefreshableTypes.PrefData]) {
        let movingBounds = values.first(where: {$0.vType == .movingView})?.bounds ?? .zero
        let fixedBounds = values.first(where: {$0.vType == .fixedView})?.bounds ?? .zero
        let offset = movingBounds.minY - fixedBounds.minY
        if offset > RecordHistoryView.kRefreshThreshold && self.isHaveNewFunc {
            self.userData.refreshRecentRecordSeeEndInfo()
            self.initCurLoadPageIndex()
        }
    }
    
    func getTotalSeeRecordCt() -> Int {
        var totalNeedCt : Int = 0
        if self.userData.recentRecordStartIndex >= 0 && self.userData.recentRecordSeeEndIndex >= self.userData.recentRecordStartIndex {
            totalNeedCt = self.userData.recentRecordSeeEndIndex - self.userData.recentRecordStartIndex + 1
        }
        return totalNeedCt
    }
    
    func getCanLoadPageCt() -> Int {
        let totalNeedCt = self.getTotalSeeRecordCt()
        var totalPages = 0
        if totalNeedCt > 0 {
            totalPages = 1 + (totalNeedCt-1)/RecordHistoryView.kOnePageCount
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
    
    var body: some View {
        
        VStack {
            Text(ESentenceType.recenthistory.localized)
                .bold()
                .font(.largeTitle)
                .padding()
            
            List {
                MovingView()
                
                if self.isHaveNewFunc {
                   Button(action: {
                        self.userData.refreshRecentRecordSeeEndInfo()
                        self.initCurLoadPageIndex()
                   }) {
                    Text(ESentenceType.newmessage.localized)
                       .font(.system(size: 18))
                   }
                   .buttonStyle(BorderlessButtonStyle())
                   .padding()
                }

                ForEach(seeRecordIndexReverseList, id: \.self) { index in
                    RecordView(myParent: self, reqRecord: self.userData.arrReqRecord[index], isSpecial: index==self.userData.recentRecordSeeEndIndex, isHeightLimited: true)
                }
                
                Button(action: loadMoreWithNoNewMsg) {
                    HStack {
                        Spacer()
                        Text(self.isLoadOverWithNoNewMsg ? ESentenceType.scrollfullmsg.localized :  "")
                            .foregroundColor(.gray)
                        Spacer()
                    }
                }
                .onAppear {
                    DispatchQueue.global(qos: .background).asyncAfter(deadline: DispatchTime(uptimeNanoseconds: 50)) {
                        self.loadMoreWithNoNewMsg()
                    }
                }
            }
            .padding()
            .background(FixedView())
            .onPreferenceChange(RefreshableTypes.PrefKey.self) {
                prefs in
                self.handleRefresh(values: prefs)
            }
            
            Spacer()
        }
        .sheet(isPresented: self.$showSheet) {
            RecordDetailView(reqRecord: self.reqRecordWillSeeDetail)
        }
        .onAppear() {
            DispatchQueue.main.async(execute: {
                UserData.globalGetIns().refreshRecentRecordSeeEndInfo()
                self.initCurLoadPageIndex()
            })
        }
    }
}

struct RecordHistoryView_Previews: PreviewProvider {
    static var previews: some View {
        RecordHistoryView().environmentObject(UserData.globalGetIns())
    }
}
