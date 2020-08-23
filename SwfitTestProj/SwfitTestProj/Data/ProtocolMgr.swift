//
//  ProtocolMgr.swift
//  SwfitTestProj
//
//  Created by mac on 2020/8/23.
//  Copyright © 2020 mac. All rights reserved.
//

import SwiftUI
import Foundation

protocol CopyProtocol {
    associatedtype Item
    func copy() -> Item
}

protocol RecordClickProtocol {
    func onClickRecord(reqRecord : RequestRecord?) -> Void
}
