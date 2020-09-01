//
//  NRecordDetailViewModel.swift
//  SwfitTestProj
//
//  Created by mac on 2020/8/30.
//  Copyright © 2020 mac. All rights reserved.
//

import Foundation
import SwiftUI

class NRecordDetailViewModel : BaseViewModel, ObservableObject {
    struct SBaseUIInfo {
        var contentBndWidth : CGFloat = UIMgr.kScreenWidth * 0.85
        var fontSizeDate : CGFloat = 14
        var fontSizeContent : CGFloat = 18
        var dateColor : Color = .gray
    }
    
    var reqRecord : RequestRecord? = nil
    var uiInfo : SBaseUIInfo = SBaseUIInfo()
    
    override init() {
        super.init()
    }
    
    init(reqRecord : RequestRecord?) {
        self.reqRecord = reqRecord
        super.init()
    }
    
    init(reqRecord : RequestRecord?, uiInfo: SBaseUIInfo) {
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
}
