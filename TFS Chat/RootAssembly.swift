//
//  CoreAssembly.swift
//  TFS Chat
//
//  Created by dmitry on 12.11.2020.
//  Copyright © 2020 dmitry. All rights reserved.
//

import Foundation

class RootAssembly {
    
    lazy var presentationAssembly: PresentationAssemblyProtocol = PresentationAssembly(serviceAssembly: self.serviceAssembly)
    private lazy var serviceAssembly: ServiceAssemblyProtocol = ServicesAssembly(coreAssembly: self.coreAssembly)
    private lazy var coreAssembly: CoreAssemblyProtocol = CoreAssembly()
}
