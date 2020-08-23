//
//  UserData.swift
//  SwfitTestProj
//
//  Created by mac on 2020/8/21.
//  Copyright © 2020 mac. All rights reserved.
//

import Foundation

struct RequestRecord : Codable, Hashable, Identifiable, CopyProtocol {
    typealias Item = RequestRecord
    
    var id : Int
    var date : Date
    var content : String
    
    func copy() -> RequestRecord {
        return RequestRecord(id: id, date: date, content: content)
    }
}

final class UserData : ObservableObject {
    static let kMinRecordId : Int = 0
    static let kMaxRecordIndex : Int = 1000
    static let kUserKey_language = "UserKey_language"
    static let kSubdirName = "userdata"
    static let kFileName = "reqrecord.json"
    
    //固定存储数据
    @Published var language : Int = 0
    @Published var arrReqRecord : [RequestRecord] = []
    
    //根据当前数据进行刷新
    @Published var recentRecordStartIndex : Int = -1
    @Published var recentRecordEndIndex : Int = -1
    @Published var recentRecordSeeEndIndex : Int = -1
    @Published var lastRecordOfLastStart : RequestRecord? = nil
    
    private var recordArrayChanged = false
    
    private init() {
    }
    static var g_data : UserData? = nil
    static func globalGetIns() -> UserData {
        if UserData.g_data == nil {
            UserData.g_data = UserData()
        }
        return UserData.g_data!
    }
    
    func refreshRecentRecordStartEndInfo() -> Void {
        if arrReqRecord.count > 0 {
            recentRecordStartIndex = 0
            recentRecordEndIndex = arrReqRecord.count-1
        } else {
            recentRecordStartIndex = -1
            recentRecordEndIndex = -1
        }
    }
    func refreshRecentRecordSeeEndInfo() -> Void {
        if arrReqRecord.count > 0 {
            recentRecordSeeEndIndex = arrReqRecord.count-1
        } else {
            recentRecordSeeEndIndex = -1
        }
    }
    func refreshRelatedDataAfterRecListChanged() -> Void {
        self.refreshRecentRecordStartEndInfo()
    }
    func loadUserData() -> Void {
        self.language = (UserDefaults.standard.object(forKey: UserData.kUserKey_language) as! Int?) ?? SentenceData.getDefaultLanguageTypeFromCurSystemLang().rawValue
        if FileOpe.CreateFileInDocument(subDirName: UserData.kSubdirName, fileName: UserData.kFileName) {
            arrReqRecord = FileOpe.LoadArrayInDocumentFile(subDirName: UserData.kSubdirName, fileName: UserData.kFileName) ?? []
        } else {
            arrReqRecord = []
        }
        if arrReqRecord.last == nil {
            self.lastRecordOfLastStart = nil
        } else {
            self.lastRecordOfLastStart = arrReqRecord.last!.copy()
        }
        refreshRelatedDataAfterRecListChanged()
    }
    private func resetReqRecordListID() {
        for index in 0..<arrReqRecord.count {
            arrReqRecord[index].id = UserData.kMinRecordId+index
        }
    }
    func addReqRecord(date:Date, content:String) -> RequestRecord? {
        if arrReqRecord.count >= UserData.kMaxRecordIndex {
            arrReqRecord.removeFirst()
            let newRecId = arrReqRecord.last!.id+1
            arrReqRecord.append(RequestRecord(id: newRecId, date: date, content: content))
            resetReqRecordListID()
        } else {
            var newRecId = UserData.kMinRecordId
            if(arrReqRecord.count > 0) {
                newRecId = arrReqRecord.last!.id+1
            }
            arrReqRecord.append(RequestRecord(id: newRecId, date: date, content: content))
        }
        recordArrayChanged = true
        refreshRelatedDataAfterRecListChanged()
        return arrReqRecord.last
    }
    func removeAllReqRecord() -> Void {
        if arrReqRecord.count > 0 {
            arrReqRecord.removeAll()
            recordArrayChanged = true
            refreshRelatedDataAfterRecListChanged()
        }
    }
    func removeReqRecord(fromid id:Int) -> RequestRecord? {
        var result : RequestRecord? = nil
        for index in 0..<arrReqRecord.count {
            if arrReqRecord[index].id == id {
                result = arrReqRecord.remove(at: index)
                recordArrayChanged = true
                break
            }
        }
        if result != nil {
            refreshRelatedDataAfterRecListChanged()
        }
        return result
    }
    func removeReqRecord(fromindex index:Int) -> RequestRecord? {
        var result : RequestRecord? = nil
        if index >= 0 && index < arrReqRecord.count {
            result = arrReqRecord.remove(at: index)
            recordArrayChanged = true
        }
        if result != nil {
            refreshRelatedDataAfterRecListChanged()
        }
        return result
    }
    func writeCurReqRecordListInLocalFileIfNeed() -> Void {
        if recordArrayChanged {
            recordArrayChanged = false
            _ = FileOpe.WriteArrayInDocumentFile(list: arrReqRecord, subDirName: UserData.kSubdirName, fileName: UserData.kFileName)
        }
    }
    func setLanguage(language:Int) -> Void {
        self.language = language
        UserDefaults.standard.set(self.language, forKey : UserData.kUserKey_language)
        UserDefaults.standard.synchronize()
    }
}
