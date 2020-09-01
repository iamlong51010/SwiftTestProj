//
//  NRecordHistoryView.swift
//  SwfitTestProj
//
//  Created by mac on 2020/8/30.
//  Copyright © 2020 mac. All rights reserved.
//

import SwiftUI

struct NRecordHistoryView: View, PopUIProtocol {

    @ObservedObject var viewModel : NRecordHistoryViewModel = NRecordHistoryViewModel()
    @State var showSheet : Bool = false
    
    func popSomething() {
        self.showSheet = true
    }
    
    var body: some View {
        
        VStack {
            Text(ESentenceType.recenthistory.localized)
                .bold()
                .font(.largeTitle)
                .padding()
            
            List {
                MovingView()
                
                if self.viewModel.isHaveNewFunc {
                   Button(action: {
                        self.viewModel.refreshRecentRecordSeeEndInfo()
                        self.viewModel.initCurLoadPageIndex()
                   }) {
                    Text(ESentenceType.newmessage.localized)
                       .font(.system(size: 18))
                   }
                   .buttonStyle(BorderlessButtonStyle())
                   .padding()
                }

                ForEach(self.viewModel.seeRecordIndexReverseList, id: \.self) { index in
                    NRecordView(viewModel: NRecordViewModel(myParent: self.viewModel, reqRecord: self.viewModel.userData.arrReqRecord[index], uiInfo: NRecordViewModel.SBaseUIInfo(isSpecial: index==self.viewModel.recentRecordSeeEndIndex, isHeightLimited: true)))
                }
                
                Button(action: self.viewModel.loadMoreWithNoNewMsg) {
                    HStack {
                        Spacer()
                        Text(self.viewModel.isLoadOverWithNoNewMsg ? ESentenceType.scrollfullmsg.localized :  "")
                            .foregroundColor(.gray)
                        Spacer()
                    }
                }
                .onAppear {
                    self.viewModel.loadMoreWithNoNewMsg()
                }
            }
            .padding()
            .background(FixedView())
            .onPreferenceChange(RefreshableTypes.PrefKey.self) {
                prefs in
                self.viewModel.handleRefresh(values: prefs)
            }
            
            Spacer()
        }
        .sheet(isPresented: self.$showSheet) {
            NRecordDetailView(viewModel: NRecordDetailViewModel(reqRecord: self.viewModel.reqRecordWillSeeDetail))
        }
        .onAppear() {
            DispatchQueue.main.async(execute: {
                self.viewModel.setView(view: self)
                self.viewModel.onAppear()
            })
        }
        .onDisappear() {
            DispatchQueue.main.async(execute: {
                self.viewModel.onDisappear()
            })
        }
    }
}

struct NRecordHistoryView_Previews: PreviewProvider {
    static var previews: some View {
        NRecordHistoryView()
    }
}
