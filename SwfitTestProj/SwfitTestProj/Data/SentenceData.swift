//
//  SentenceData.swift
//  SwfitTestProj
//
//  Created by mac on 2020/8/21.
//  Copyright © 2020 mac. All rights reserved.
//

import Foundation

enum ESentenceType : String, CaseIterable {
    case lastrecord
    case recenthistory
    case languageselect
    case cancel
    case newmessage
    case scrollfullmsg
    case recorddetail
    case remarkhomepage
    
    var localized : String {
        return self.rawValue.localized
    }
}

enum ELanguageType : Int {
    case English = 0
    case ChineseSimple
    case ChineseComplex
    case Japanese
    
    var toLanguageStr : String {
        switch self {
        case .ChineseSimple:
            return "zh-Hans"
        case .ChineseComplex:
            return "zh-Hant"
        case .Japanese:
            return "ja"
        default:
            return "en"
        }
    }
}

extension Int {
    var toLanguageType : ELanguageType {
        switch self {
        case 1:
            return .ChineseSimple
        case 2:
            return .ChineseComplex
        case 3:
            return .Japanese
        default:
            return .English
        }
    }
}

extension String {
    var localized : String {
        NSLocalizedString(self, tableName: "LocalWords", bundle: UserData.globalGetIns().localizedBundle, value: "", comment: "")
    }
}

final class SentenceData {
    static let kLanguageList : [String] = ["English","简体中文","繁體中文","日本語"]
    
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
}
