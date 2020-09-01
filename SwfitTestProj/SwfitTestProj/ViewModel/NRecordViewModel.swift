//
//  NRecordViewModel.swift
//  SwfitTestProj
//
//  Created by mac on 2020/8/30.
//  Copyright © 2020 mac. All rights reserved.
//

import Foundation
import SwiftUI

class NRecordViewModel : BaseViewModel, ObservableObject {
    struct SBaseUIInfo {
        var dateColor : Color = .gray
        var contentBndColor : Color = ColorMgr.kColor_lightGray
        var contentColor : Color = .black
        var contentBndWidth : CGFloat = UIMgr.kScreenWidth * 0.85
        var fontSizeDate : CGFloat = 10.0
        var fontSizeContent : CGFloat = 14.0
        var isSpecial : Bool = false
        var isHeightLimited : Bool = true
    }
    
    var myParent : Any? = nil
    var reqRecord : RequestRecord? = nil
    var uiInfo : SBaseUIInfo = SBaseUIInfo()
    
    override init() {
        super.init()
    }
    
    init(myParent : Any?, reqRecord : RequestRecord?) {
        self.myParent = myParent
        self.reqRecord = reqRecord
        super.init()
    }
    
    init(myParent : Any?, reqRecord : RequestRecord?, uiInfo : SBaseUIInfo) {
        self.myParent = myParent
        self.reqRecord = reqRecord
        self.uiInfo = uiInfo
        super.init()
    }
    
    var recordTimeDesc : String {
        if self.reqRecord != nil {
            return self.reqRecord!.date.getYearMonthDayHourMinSecDesc()
        } else {
            return "Empty Time"
        }
    }
    
    var recordContent : String {
        if self.reqRecord != nil {
            return self.reqRecord!.content.toJsonString()
        } else {
            return "Empty Content"
        }
    }
    
    var timeFontSize : CGFloat {
        return self.uiInfo.isSpecial ? 12.0 : self.uiInfo.fontSizeDate
    }
    
    var contentBndColor : Color {
        return self.uiInfo.isSpecial ? ColorMgr.kColor_lightGray : self.uiInfo.contentBndColor
    }
    
    var contentColor : Color {
        return self.uiInfo.isSpecial ? .red : self.uiInfo.contentColor
    }
    
    var contentFontSize : CGFloat {
        return self.uiInfo.isSpecial ? 16.0 : self.uiInfo.fontSizeContent
    }
    
    var contentTotalHeight : CGFloat {
        return self.estimatedHeightOfText(strText: self.recordContent, fontSize: (self.uiInfo.isSpecial ? 16.0 : self.uiInfo.fontSizeContent))+16
    }
    
    func clickContent() {
        if self.myParent != nil {
            if let clickParent = self.myParent as? RecordClickProtocol {
                clickParent.onClickRecord(reqRecord: self.reqRecord)
            }
        }
    }
    
    func estimatedHeightOfText(strText : String, fontSize : CGFloat) -> CGFloat {
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        let hLimited : CGFloat = self.uiInfo.isHeightLimited ? (UIMgr.kScreenHeight*0.5) : (UIMgr.kScreenHeight*3.0)
        let estimatedFrame = NSString(string: strText).boundingRect(with: CGSize(width: self.uiInfo.contentBndWidth, height: hLimited), options: options, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: fontSize)], context: nil)
        return estimatedFrame.height
    }
}
