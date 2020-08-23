//
//  SentenceData.swift
//  SwfitTestProj
//
//  Created by mac on 2020/8/21.
//  Copyright © 2020 mac. All rights reserved.
//

import Foundation

enum ESentenceType : Int {
    case lastrecord = 0
    case recenthistory
    case languageselect
    case cancel
    case newmessage
    case scrollfullmsg
    case recorddetail
    case remarkhomepage
}

enum ELanguageType : Int {
    case English = 0
    case ChineseSimple
    case ChineseComplex
    case Japanese
}

func GlobalGetSentence(sentenceType : ESentenceType) -> String {
    return SentenceData.globalGetIns().getSentence(sentenceType: sentenceType)
}

final class SentenceData {
    static let kLanguageList : [String] = ["English","简体中文","繁體中文","日本語"]
    static var g_data : SentenceData? = nil
    
    var sentence : [Int : [String]] = [:]
    
    private init() {
        self.sentence.removeAll()
        
        self.sentence[ESentenceType.lastrecord.rawValue] = ["Last Record","最后一次记录","最後一次記錄","最後のレコード"]
        self.sentence[ESentenceType.recenthistory.rawValue] = ["History Query","历史查询","歷史査詢","履歴の検索"]
        self.sentence[ESentenceType.languageselect.rawValue] = ["Language Select","语言选择","語言選擇","言語選択"]
        self.sentence[ESentenceType.cancel.rawValue] = ["cancel","取消","取消","キャンセル"]
        self.sentence[ESentenceType.newmessage.rawValue] = ["Some news coming, please click me or drag down to view.","有新消息了，请点击我或向下拖动查看。","有新消息了，請點擊我或向下拖動查看。","新しいニュースがありました。私をクリックするか、下にドラッグしてみてください。"]
        self.sentence[ESentenceType.scrollfullmsg.rawValue] = ["It's the end","已经到底了","已經到底了","もうおしまいだ"]
        self.sentence[ESentenceType.recorddetail.rawValue] = ["Record Details","记录详情","記錄詳情","詳細を記録"]
        self.sentence[ESentenceType.remarkhomepage.rawValue] = ["Note: you can click record to view the record details.","备注：您可以点击记录以查看记录详情。","備註：您可以點擊記錄以查看記錄詳情。","備考：記録をクリックして記録の詳細を確認することができます。"]
        
        //self.sentence[ESentenceType.xxxxx.rawValue] = ["","","",""]
    }
    
    static func globalGetIns() -> SentenceData {
        if SentenceData.g_data == nil {
            SentenceData.g_data = SentenceData()
        }
        return SentenceData.g_data!
    }
    
    static func getDefaultLanguageTypeFromCurSystemLang() -> ELanguageType {
        let preferredLang = Bundle.main.preferredLocalizations.first! as NSString
        let strSystemLang = String(describing: preferredLang)
        //print("____cur language=[" + strSystemLang + "]")
        switch strSystemLang
        {
            case "zh","zh-Hans-CN","zh-Hans-HK","zh-Hans-MO","zh-Hans-SG","zh-Hans","zh-Hans-US":
                return .ChineseSimple
            case "zh-HK","zh-TW","zh-Hant-CN","zh-Hant-HK","zh-Hant-MO","zh-Hant-TW","zh-Hant":
                return .ChineseComplex
            case "ja":
                return .Japanese
            default:
                return .English
        }
    }
    
    func getSentence(sentenceType:ESentenceType) -> String {
        if UserData.globalGetIns().language >= 0 {
            return self.sentence[sentenceType.rawValue]?[UserData.globalGetIns().language] ?? ""
        } else {
            return ""
        }
    }
}
