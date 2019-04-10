//
//  UserManager.swift
//  Recruit1
//
//  Created by Bartosz Nowacki on 14/03/2019.
//  Copyright © 2019 Appunite. All rights reserved.
//

import UIKit
import RealmSwift

class BaseManager {
    
    var encryptionKey: String {
        return ""
    }
    
    var realmName: String {
        return ""
    }
    
    lazy var realmURL: URL = {
        let documentUrl = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)[0]
        let url = documentUrl.appendingPathComponent(self.realmName)
        log.debug(url)
        return url
    }()
    
    lazy var config: Realm.Configuration = {
        return Realm.Configuration(
            fileURL: self.realmURL,
            inMemoryIdentifier: nil,
            encryptionKey: self.encryptionKey.data(using: String.Encoding.utf8),
            readOnly: false,
            schemaVersion: 5,
            migrationBlock: { _, oldSchemaVersion in
                if oldSchemaVersion < 5 {
                    //Nothing to do here
                }
        },
            deleteRealmIfMigrationNeeded: true,
            objectTypes: nil)
    }()
    
    var count: Int {
        return 0
    }
    
    func save<T: Object>(_ objects: [T]) {
        fatalError("save has not been implemented")
    }
    
    func load<T: Object>() -> Results<T> {
        fatalError("load has not been implemented")
    }
    
    func deleteAll() {
        fatalError("deleteAll has not been implemented")
    }
}
