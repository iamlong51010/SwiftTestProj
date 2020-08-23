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
