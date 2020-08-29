//
//  UserData.swift
//  SwfitTestProj
//
//  Created by mac on 2020/8/21.
//  Copyright © 2020 mac. All rights reserved.
//

import Foundation
import RxSwift

struct RecordData : Codable {
    var current_user_url : String = ""
    var current_user_authorizations_html_url : String = ""
    var authorizations_url : String = ""
    var code_search_url : String = ""
    var commit_search_url : String = ""
    var emails_url : String = ""
    var emojis_url : String = ""
    var events_url : String = ""
    var feeds_url : String = ""
    var followers_url : String = ""
    var following_url : String = ""
    var gists_url : String = ""
    var hub_url : String = ""
    var issue_search_url : String = ""
    var issues_url : String = ""
    var keys_url : String = ""
    var label_search_url : String = ""
    var notifications_url : String = ""
    var organization_url : String = ""
    var organization_repositories_url : String = ""
    var organization_teams_url : String = ""
    var public_gists_url : String = ""
    var rate_limit_url : String = ""
    var repository_url : String = ""
    var repository_search_url : String = ""
    var current_user_repositories_url : String = ""
    var starred_url : String = ""
    var starred_gists_url : String = ""
    var user_url : String = ""
    var user_organizations_url : String = ""
    var user_repositories_url : String = ""
    var user_search_url : String = ""
    
    func toJsonString() -> String {
        do {
            var result = try String(data: JSONEncoder().encode(self), encoding: String.Encoding.utf8)
            result = (result != nil) ? result!.replacingOccurrences(of: "\\", with: "") : "json parse error!"
            return result!
        } catch {
            return "json parse error!"
        }
    }
    
    init() {
    }
    
    init(jsonStr : String) {
        let data : Data? = jsonStr.data(using: String.Encoding.utf8)
        
        if data == nil || data!.isEmpty {
            return
        }
        do {
            self = try JSONDecoder().decode(RecordData.self, from: data!)
        } catch {
            fatalError("json parse error")
        }
    }
}

struct RequestRecord : Codable, Hashable, Identifiable, CopyProtocol {
    static func == (lhs: RequestRecord, rhs: RequestRecord) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    typealias Item = RequestRecord
    
    var id : Int
    var date : Date
    var content : RecordData
    
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
    @Published var localizedBundle : Bundle = Bundle.main
    @Published var language : Int = 0 {
        didSet {
            let path = Bundle.main.path(forResource:self.language.toLanguageType.toLanguageStr , ofType: "lproj")
            self.localizedBundle = Bundle(path: path!) ?? Bundle.main
        }
    }
    @Published var arrReqRecord : [RequestRecord] = []
    
    //根据当前数据进行刷新
    @Published var recentRecordStartIndex : Int = -1
    @Published var recentRecordEndIndex : Int = -1
    @Published var recentRecordSeeEndIndex : Int = -1
    
    private var recordArrayChanged = false
    private let disposeBag = DisposeBag()
    private var subscriber : Disposable?
    
    private init() {
        if self.subscriber == nil {
            self.subscriber = HttpAccessMgr.globalGetIns().pubSubjectReqRecord
            .subscribe(onNext: { message in
                _ = self.addReqRecord(date: Date(), content: RecordData(jsonStr: message))
            }, onError: { error in
            }, onCompleted: {
            }, onDisposed: {
            })
            self.subscriber?.disposed(by: self.disposeBag)
        }
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
        refreshRelatedDataAfterRecListChanged()
    }
    private func resetReqRecordListID() {
        for index in 0..<arrReqRecord.count {
            arrReqRecord[index].id = UserData.kMinRecordId+index
        }
    }
    func addReqRecord(date:Date, content:RecordData) -> RequestRecord? {
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
