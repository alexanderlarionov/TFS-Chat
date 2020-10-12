//
//  ConfigurableView.swift
//  TFS Chat
//
//  Created by dmitry on 29.09.2020.
//  Copyright © 2020 dmitry. All rights reserved.
//

protocol ConfigurableView {
    
    associatedtype ConfigurationModel
    
    func configure(with model: ConfigurationModel)
    
}

extension ConfigurableView {
    
    func configure(with model: ConfigurationModel) {
        
    }
}
