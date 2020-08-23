//
//  RecordDetailView.swift
//  SwfitTestProj
//
//  Created by mac on 2020/8/23.
//  Copyright © 2020 mac. All rights reserved.
//

import SwiftUI

struct RecordDetailView: View {
    var reqRecord : RequestRecord? = nil
    var contentBndWidth : CGFloat = UIMgr.kScreenWidth * 0.85
    var fontSizeDate : CGFloat = 14
    var fontSizeContent : CGFloat = 18
    var dateColor : Color = .gray
    
    var recordTimeDesc : String {
        if self.reqRecord != nil {
            return self.reqRecord!.date.getYearMonthDayHourMinSecDesc()
        } else {
            return "Empty Time"
        }
    }
    
    var recordContent : String {
        if self.reqRecord != nil {
            return self.reqRecord!.content
        } else {
            return "Empty Content"
        }
    }
    
    var body: some View {
        VStack {
            Text(GlobalGetSentence(sentenceType: .recorddetail))
                .bold()
                .font(.largeTitle)
                .padding()
            
            Text(self.recordTimeDesc)
                .font(.system(size: self.fontSizeDate))
                .foregroundColor(self.dateColor)
            
            MyTextView(text: self.recordContent, fontSize: self.fontSizeContent, fontColor: .blue)
                .frame(width: self.contentBndWidth)
                .padding(8)
        }
    }
}

struct RecordDetailView_Previews: PreviewProvider {
    static var previews: some View {
        RecordDetailView()
    }
}
