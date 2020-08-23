//
//  HomeView.swift
//  SwfitTestProj
//
//  Created by mac on 2020/8/21.
//  Copyright © 2020 mac. All rights reserved.
//

import SwiftUI

struct HomeView: View, RecordClickProtocol {
    
    @EnvironmentObject var userData : UserData
    @State var showSheet : Bool = false
    @State var curShowSheetType : Int = 1 //1:打开语言选择,2:记录详情界面
    @State private var navigationLinkClickID : Int = 0
    @State var reqRecordWillSeeDetail : RequestRecord?
    
    func onClickRecord(reqRecord: RequestRecord?) {
        if reqRecord == nil {
            self.reqRecordWillSeeDetail = nil
        } else {
            self.reqRecordWillSeeDetail = reqRecord!.copy()
        }
        self.curShowSheetType = 2
        self.showSheet = true
    }
    
    var body: some View {
        
        NavigationView {
            VStack {
                Text(GlobalGetSentence(sentenceType: .laststartrecord))
                    .bold()
                    .font(.largeTitle)
                    .padding()
                
                Spacer()
                RecordView(myParent: self, reqRecord: self.userData.lastRecordOfLastStart, isSpecial: true, isHeightLimited: true)
                Spacer()
                
                Button(action: {
                    self.curShowSheetType = 1
                    self.showSheet = true
                }) {
                    Text(GlobalGetSentence(sentenceType: .languageselect))
                    .font(.system(size: 18))
                }
                .buttonStyle(BorderlessButtonStyle())
                
                NavigationLink(destination: RecordHistoryView().environmentObject(self.userData).onDisappear() {
                    self.navigationLinkClickID += 1
                    if self.navigationLinkClickID >= 10 {
                        self.navigationLinkClickID = 0
                    }
                }) {
                    Text(GlobalGetSentence(sentenceType: .recenthistory))
                    .font(.system(size: 18))
                }
                .id(self.navigationLinkClickID)
                .padding(8)
                
                Text(GlobalGetSentence(sentenceType: .remarkhomepage))
                    .font(.system(.caption))
                    .foregroundColor(.gray)
                    .padding(2)
            }
            .sheet(isPresented: self.$showSheet) {
                if self.curShowSheetType == 1 {
                    LanguageSetView()
                } else if self.curShowSheetType == 2 {
                    RecordDetailView(reqRecord: self.reqRecordWillSeeDetail)
                }
            }
        }
        .onAppear() {
            HttpAccessMgr.globalGetIns().startAccess()
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView().environmentObject(UserData.globalGetIns())
    }
}
