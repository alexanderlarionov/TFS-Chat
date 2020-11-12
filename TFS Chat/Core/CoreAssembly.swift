//
//  CoreAssembly.swift
//  TFS Chat
//
//  Created by dmitry on 12.11.2020.
//  Copyright © 2020 dmitry. All rights reserved.
//

import Foundation

protocol CoreAssemblyProtocol {
    var fileStorage: FileStorageProtocol { get }
    var firestoreClient: ApiClientProtocol { get }
    var storage: StorageProtocol { get }
}

class CoreAssembly: CoreAssemblyProtocol {
    lazy var fileStorage: FileStorageProtocol = FileStorage()
    lazy var firestoreClient: ApiClientProtocol = FirestoreClient()
    lazy var storage: StorageProtocol = CoreDataStack.instance
}
