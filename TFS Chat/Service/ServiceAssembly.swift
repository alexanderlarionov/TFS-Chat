//
//  ServiceAssembly.swift
//  TFS Chat
//
//  Created by dmitry on 12.11.2020.
//  Copyright © 2020 dmitry. All rights reserved.
//

import Foundation

protocol ServiceAssemblyProtocol {
    var apiService: ApiServiceProtocol { get }
    var storageService: StorageServiceProtocol { get }
    var fileStorageGCDService: FileStorageServiceProtocol { get }
    var fileStorageOperationService: FileStorageServiceProtocol { get }
}

class ServicesAssembly: ServiceAssemblyProtocol {
    
    private let coreAssembly: CoreAssemblyProtocol
    
    init(coreAssembly: CoreAssemblyProtocol) {
        self.coreAssembly = coreAssembly
    }
    
    lazy var apiService: ApiServiceProtocol = ApiService(apiClient: self.coreAssembly.firestoreClient)
    lazy var storageService: StorageServiceProtocol = StorageService(storage: self.coreAssembly.storage)
    lazy var fileStorageGCDService: FileStorageServiceProtocol = GCDDataManager(fileStorage: self.coreAssembly.fileStorage)
    lazy var fileStorageOperationService: FileStorageServiceProtocol = OperationDataManager(fileStorage: self.coreAssembly.fileStorage)
}
