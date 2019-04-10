//
//  UserManager.swift
//  LoginAppExample
//
//  Created by Bartosz Nowacki on 08/04/2019.
//  Copyright © 2019 Bartosz Nowacki. All rights reserved.
//

import UIKit
import RealmSwift

class UserManager: NSObject {
    
    lazy private var realmURL: URL = {
        let documentUrl = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)[0]
        let url = documentUrl.appendingPathComponent("User.realm")
        return url
    }()
    
    lazy private var config: Realm.Configuration = {
        return Realm.Configuration(
            fileURL: self.realmURL,
            inMemoryIdentifier: nil,
            encryptionKey: "BeAnAQYUmu3FJieuWwYyEHmwjZ8FTAvFiw7KxdNTkjDxCUGLCzzjCEyCfJsHFtsD".data(using: String.Encoding.utf8),
            readOnly: false,
            schemaVersion: 3,
            migrationBlock: { _, oldSchemaVersion in
                if oldSchemaVersion < 2 { }
        },
            deleteRealmIfMigrationNeeded: true,
            objectTypes: nil)
    }()
    
    static let shared: UserManager = UserManager()
    
    
    ///Get object stored in Realm Data Base.
    ///- returns: Object of given Type stored in Data Base
    
    func current<T: UserData>(_ type: T.Type) -> T? {
        guard let realm = try? Realm(configuration: config) else { fatalError() }
        return realm.objects(T.self).first
    }
    
    func load<T: UserData>() -> [T] {
        guard let realm = try? Realm(configuration: config) else { fatalError() }
        return Array(realm.objects(T.self))
    }
    
    ///Save object to Realm Data Base.
    
    func save<T: UserData>(_ item: T) {
        guard let realm = try? Realm(configuration: config) else { return }
        try? realm.write {
            realm.add(item, update: true)
        }
        
    }
    
    func saveArray<T: UserData>(_ objects: [T]) {
        guard let realm = try? Realm(configuration: config) else { return }
        try? realm.write {
            realm.deleteAll()
            realm.add(objects)
        }
        
    }
    
    ///Delete object from Realm Data Base.
    
    func delete<T: UserData>(_ type: T.Type) {
        guard let realm = try? Realm(configuration: config) else { return }
        try? realm.write {
            realm.delete(realm.objects(T.self))
        }
    }
    
    func deleteAll() {
        guard let realm = try? Realm(configuration: config) else { return }
        try? realm.write {
            realm.deleteAll()
        }
    }
    
    ///Check if object exists in Realm Data Base.
    
    func isAvailable<T: UserData>(_ type: T.Type) -> Bool {
        guard let realm = try? Realm(configuration: config) else { fatalError() }
        return realm.objects(T.self).count > 0
    }
}
