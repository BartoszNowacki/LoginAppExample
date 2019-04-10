//
//  PokeManager.swift
//  LoginAppExample
//
//  Created by Bartosz Nowacki on 09/04/2019.
//  Copyright © 2019 Appunite. All rights reserved.
//

//
//  UserManager.swift
//  LoginAppExample
//
//  Created by Bartosz Nowacki on 08/04/2019.
//  Copyright © 2019 Bartosz Nowacki. All rights reserved.
//

import UIKit
import RealmSwift

class PokeManager: NSObject {
    
    lazy fileprivate var realmURL: URL = {
        let documentUrl = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)[0]
        let url = documentUrl.appendingPathComponent("Poke.realm")
        return url
    }()
    
    lazy fileprivate var config: Realm.Configuration = {
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
    
    static let shared: PokeManager = PokeManager()
    
    
    ///Get objects stored in Realm Data Base.
    ///- returns: Object sof given Type stored in Data Base
    
    func load<T: PokeData>() -> [T] {
        guard let realm = try? Realm(configuration: config) else { fatalError() }
        return Array(realm.objects(T.self))
    }
    
    ///Save object to Realm Data Base.
    
    func save<T: PokeData>(_ objects: [T]) {
        guard let realm = try? Realm(configuration: config) else { return }
        try? realm.write {
            realm.deleteAll()
            realm.add(objects)
        }
        
    }
    
    ///Delete object from Realm Data Base.
    
    func delete<T: PokeData>(_ type: T.Type) {
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
    
    func isAvailable<T: PokeData>(_ type: T.Type) -> Bool {
        guard let realm = try? Realm(configuration: config) else { fatalError() }
        return realm.objects(T.self).count > 0
    }
}
