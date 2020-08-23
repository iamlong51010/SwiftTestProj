//
//  RecordView.swift
//  SwfitTestProj
//
//  Created by mac on 2020/8/21.
//  Copyright © 2020 mac. All rights reserved.
//

import SwiftUI

struct RecordView: View {
    var myParent : Any?
    var reqRecord : RequestRecord? = nil
    var dateColor : Color = .gray
    var contentBndColor : Color = ColorMgr.kColor_lightGray
    var contentColor : Color = .black
    var contentBndWidth : CGFloat = UIMgr.kScreenWidth * 0.85
    var fontSizeDate : CGFloat = 10.0
    var fontSizeContent : CGFloat = 14.0
    var isSpecial : Bool = false
    var isHeightLimited : Bool = true
    
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
    
    func estimatedHeightOfText(strText : String, fontSize : CGFloat) -> CGFloat {
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        let hLimited : CGFloat = self.isHeightLimited ? (UIMgr.kScreenHeight*0.5) : (UIMgr.kScreenHeight*3.0)
        let estimatedFrame = NSString(string: strText).boundingRect(with: CGSize(width: self.contentBndWidth, height: hLimited), options: options, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: fontSize)], context: nil)
        return estimatedFrame.height
    }
    
    var body: some View {
        VStack {
            Text(self.recordTimeDesc)
                .font(.system(size: self.isSpecial ? 12.0 : self.fontSizeDate))
                .foregroundColor(self.dateColor)
            
            
            ZStack {
                RoundedRectangle(cornerRadius: 5.0)
                    .foregroundColor(self.isSpecial ? ColorMgr.kColor_lightGray : self.contentBndColor)
                
                Text(self.recordContent)
                    .font(.system(size: self.isSpecial ? 16.0 : self.fontSizeContent))
                    .foregroundColor(self.isSpecial ? .red : self.contentColor)
                    .padding(5)
            }
            .frame(width: self.contentBndWidth, height: self.estimatedHeightOfText(strText: self.recordContent, fontSize: (self.isSpecial ? 16.0 : self.fontSizeContent))+16)
            .onTapGesture {
                if self.myParent != nil {
                    if let clickParent = self.myParent! as? RecordClickProtocol {
                        
                        clickParent.onClickRecord(reqRecord: self.reqRecord)
                    }
                }
            }
        }
    }
}

struct RecordView_Previews: PreviewProvider {
    static var previews: some View {
        RecordView(myParent: nil)
    }
}
