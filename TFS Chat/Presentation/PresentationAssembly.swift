//
//  PresentationAssembly.swift
//  TFS Chat
//
//  Created by dmitry on 12.11.2020.
//  Copyright © 2020 dmitry. All rights reserved.
//

import UIKit

protocol PresentationAssemblyProtocol {
    
    func rootController() -> UINavigationController
    
}

class PresentationAssembly: PresentationAssemblyProtocol {
    
    private let serviceAssembly: ServiceAssemblyProtocol
    
    init(serviceAssembly: ServiceAssemblyProtocol) {
        self.serviceAssembly = serviceAssembly
    }
    
    func rootController() -> UINavigationController {
        guard let navController = loadVCFromStoryboard(name: "ChannelListViewController", identifier: "ChannelListViewController") as? UINavigationController,
              let channelListViewController = navController.children.first as? ChannelListViewController else {
            fatalError("Unable to load ChannelListViewController")
        }
        
        channelListViewController.injectDependcies(
            storageService: serviceAssembly.storageService,
            apiService: serviceAssembly.apiService,
            presentationAssembly: self,
            gcdDataManager: serviceAssembly.fileStorageGCDService,
            operationDataManager: serviceAssembly.fileStorageOperationService)
        
        return navController
    }
    
    private func loadVCFromStoryboard(name: String, identifier: String) -> UIViewController {
        let storyboard = UIStoryboard(name: name, bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: identifier)
    }
    
}
