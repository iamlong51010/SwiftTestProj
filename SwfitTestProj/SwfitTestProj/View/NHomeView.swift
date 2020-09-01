//
//  NHomeView.swift
//  SwfitTestProj
//
//  Created by mac on 2020/8/30.
//  Copyright © 2020 mac. All rights reserved.
//

import SwiftUI

struct NHomeView: View, PopUIProtocol, NavigationLinkClickProtocol {
    
    @ObservedObject var viewModel : NHomeViewModel = NHomeViewModel()
    @State var showSheet : Bool = false
    @State var navigationLinkClickID : Int = 0
    
    func popSomething() {
        self.showSheet = true
    }
    
    func handleAfterNaviLinkUIDisappear() {
        self.navigationLinkClickID += 1
        if self.navigationLinkClickID >= 10 {
            self.navigationLinkClickID = 0
        }
    }
    
    var body: some View {
        
        NavigationView {
            VStack {
                Text(ESentenceType.lastrecord.localized)
                    .bold()
                    .font(.largeTitle)
                    .padding()
                
                Spacer()
                NRecordView(viewModel: NRecordViewModel(myParent: self.viewModel, reqRecord: self.viewModel.userData.arrReqRecord.last, uiInfo: NRecordViewModel.SBaseUIInfo(isSpecial: true, isHeightLimited: true)))
                Spacer()
                
                Button(action: {
                    self.viewModel.onClickLanguageSelect()
                }) {
                    Text(ESentenceType.languageselect.localized)
                    .font(.system(size: 18))
                }
                .buttonStyle(BorderlessButtonStyle())
                
                NavigationLink(destination:
                    UIMgr.GlobalGetRecordHistoryView().onDisappear() {
                        self.handleAfterNaviLinkUIDisappear()
                }) {
                    Text(ESentenceType.recenthistory.localized)
                    .font(.system(size: 18))
                }
                .id(self.navigationLinkClickID)
                .padding(8)
                
                Text(ESentenceType.remarkhomepage.localized)
                    .font(.system(.caption))
                    .foregroundColor(.gray)
                    .padding(2)
            }
            .sheet(isPresented: self.$showSheet) {
                if self.viewModel.curShowSheetType == 1 {
                    UIMgr.GlobalGetLanguageSelectView()
                } else if self.viewModel.curShowSheetType == 2 {
                    NRecordDetailView(viewModel: NRecordDetailViewModel(reqRecord: self.viewModel.reqRecordWillSeeDetail))
                }
            }
        }
        .onAppear() {
            self.viewModel.setView(view: self)
            self.viewModel.onAppear()
        }
        .onDisappear() {
            self.viewModel.onDisappear()
        }
    }
}

struct NHomeView_Previews: PreviewProvider {
    static var previews: some View {
        NHomeView()
    }
}
