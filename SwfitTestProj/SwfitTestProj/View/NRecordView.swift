//
//  NRecordView.swift
//  SwfitTestProj
//
//  Created by mac on 2020/8/30.
//  Copyright © 2020 mac. All rights reserved.
//

import SwiftUI

struct NRecordView: View {
    @ObservedObject var viewModel : NRecordViewModel
    
    var body: some View {
        VStack {
            Text(self.viewModel.recordTimeDesc)
                .font(.system(size: self.viewModel.timeFontSize))
                .foregroundColor(self.viewModel.uiInfo.dateColor)
            
            ZStack {
                RoundedRectangle(cornerRadius: 5.0)
                    .foregroundColor(self.viewModel.contentBndColor)
                
                Text(self.viewModel.recordContent)
                    .font(.system(size: self.viewModel.contentFontSize))
                    .foregroundColor(self.viewModel.contentColor)
                    .padding(5)
            }
            .frame(width: self.viewModel.uiInfo.contentBndWidth, height: self.viewModel.contentTotalHeight)
            .onTapGesture {
                self.viewModel.clickContent()
            }
        }
    }
}

struct NRecordView_Previews: PreviewProvider {
    static var previews: some View {
        NRecordView(viewModel: NRecordViewModel())
    }
}
