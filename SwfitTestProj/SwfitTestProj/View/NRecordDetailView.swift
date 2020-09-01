//
//  NRecordDetailView.swift
//  SwfitTestProj
//
//  Created by mac on 2020/8/30.
//  Copyright © 2020 mac. All rights reserved.
//

import SwiftUI

struct NRecordDetailView: View {
    
    @ObservedObject var viewModel : NRecordDetailViewModel
    
    var body: some View {
        VStack {
            Text(ESentenceType.recorddetail.localized)
                .bold()
                .font(.largeTitle)
                .padding()
            
            Text(self.viewModel.recordTimeDesc)
                .font(.system(size: self.viewModel.uiInfo.fontSizeDate))
                .foregroundColor(self.viewModel.uiInfo.dateColor)
            
            MyTextView(text: self.viewModel.recordContent, fontSize: self.viewModel.uiInfo.fontSizeContent, fontColor: .blue)
                .frame(width: self.viewModel.uiInfo.contentBndWidth)
                .padding(8)
        }
    }
}

struct NRecordDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NRecordDetailView(viewModel: NRecordDetailViewModel())
    }
}
