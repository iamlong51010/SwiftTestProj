//
//  FileOpe.swift
//  SwfitTestProj
//
//  Created by mac on 2020/8/21.
//  Copyright © 2020 mac. All rights reserved.
//

import Foundation

final class FileOpe {
    static func CreateFileInDocument(subDirName:String, fileName:String) -> Bool {
        if subDirName.isEmpty || fileName.isEmpty {
            return false
        }
        
        let manager = FileManager.default
        let urls: [URL] = manager.urls(for: .documentDirectory, in: .userDomainMask)
        
        // .libraryDirectory、.cachesDirectory ...
        let documentURL = urls.first!
        
        let urlSubDir = documentURL.appendingPathComponent(subDirName, isDirectory: true)
        var isDirectory: ObjCBool = ObjCBool(true)
        var isExist = manager.fileExists(atPath: urlSubDir.path, isDirectory: &isDirectory)
        if !isExist {
          do {
            try manager.createDirectory(at: urlSubDir, withIntermediateDirectories: true, attributes: nil)
          } catch {
            print("createDirectory error:\(error)")
          }
        }
        //now,directory has been created, we now created file
        //txt文件会自动创建，只要给个名称就行
        let urlFile  = documentURL.appendingPathComponent(subDirName+"/"+fileName, isDirectory: false)
        isDirectory = ObjCBool(false)
        isExist = manager.fileExists(atPath: urlFile.path, isDirectory: &isDirectory)
        if !isExist {
          return manager.createFile(atPath: urlFile.path, contents: nil, attributes: nil)
        }
        return true
    }
    static func WriteArrayInDocumentFile<T:Codable>(list:[T], subDirName:String, fileName:String) -> Bool {
        if subDirName.isEmpty || fileName.isEmpty {
            return false
        }
        
        let manager = FileManager.default
        let urls: [URL] = manager.urls(for: .documentDirectory, in: .userDomainMask)
        
        // .libraryDirectory、.cachesDirectory ...
        let documentURL = urls.first!
        
        let urlFile  = documentURL.appendingPathComponent(subDirName+"/"+fileName, isDirectory: false)
        do {
            let dataJson = try JSONEncoder().encode(list)
            try dataJson.write(to: urlFile)
            return true
        } catch {
            fatalError("Couldn't parse list")
        }
        
    }
    static func LoadArrayInDocumentFile<T: Decodable>(subDirName:String, fileName:String) -> T? {
        
        if subDirName.isEmpty || fileName.isEmpty {
            return nil
        }
        
        let manager = FileManager.default
        let urls: [URL] = manager.urls(for: .documentDirectory, in: .userDomainMask)
        
        // .libraryDirectory、.cachesDirectory ...
        let documentURL = urls.first!
        
        let urlFile  = documentURL.appendingPathComponent(subDirName+"/"+fileName, isDirectory: false)
        let data: Data
        
        do {
            data = try Data(contentsOf: urlFile)
        } catch {
            fatalError("Couldn't load \(fileName) :\n\(error)")
        }
        
        if data.isEmpty {
            return nil
        }
        
        do {
            let decoder = JSONDecoder()
            return try decoder.decode(T.self, from: data)
        } catch {
            fatalError("Couldn't parse \(fileName)")
        }
    }
}
