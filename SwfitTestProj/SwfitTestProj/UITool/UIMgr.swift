//
//  UIMgr.swift
//  SwfitTestProj
//
//  Created by mac on 2020/8/21.
//  Copyright © 2020 mac. All rights reserved.
//

import SwiftUI
import Foundation

final class UIMgr {
    static let kScreenWidth = UIScreen.main.bounds.width
    static let kScreenHeight = UIScreen.main.bounds.height
    
    static var g_viewLanguageSet : NLanguageSetView? = nil
    static var g_viewRecordHistory : NRecordHistoryView? = nil
    
    static func GlobalGetLanguageSelectView() -> NLanguageSetView {
        if UIMgr.g_viewLanguageSet == nil {
            UIMgr.g_viewLanguageSet = NLanguageSetView()
        }
        return UIMgr.g_viewLanguageSet!
    }
    
    static func GlobalGetRecordHistoryView() -> NRecordHistoryView {
        if UIMgr.g_viewRecordHistory == nil {
            UIMgr.g_viewRecordHistory = NRecordHistoryView()
        }
        return UIMgr.g_viewRecordHistory!
    }
}

struct RefreshableTypes {
    enum ViewType: Int {
        case movingView
        case fixedView
    }
    
    struct PrefData: Equatable {
        let vType: ViewType
        let bounds: CGRect
    }
    
    struct PrefKey: PreferenceKey {
        typealias Value = [PrefData]
        
        static var defaultValue: [RefreshableTypes.PrefData] = []
        
        static func reduce(value: inout [RefreshableTypes.PrefData], nextValue: () -> [RefreshableTypes.PrefData]) {
            value.append(contentsOf: nextValue())
        }
    }
}

struct FixedView: View {
    var body: some View {
        GeometryReader { geo in
            Color.clear.preference(key: RefreshableTypes.PrefKey.self, value: [RefreshableTypes.PrefData(vType: .fixedView, bounds: geo.frame(in: .global))])
        }
    }
}

struct MovingView: View {
    var body: some View {
        GeometryReader { geo in
            Color.clear.preference(key: RefreshableTypes.PrefKey.self, value: [RefreshableTypes.PrefData(vType: .movingView, bounds: geo.frame(in: .global))])
        }.frame(height: 0)
    }
}
