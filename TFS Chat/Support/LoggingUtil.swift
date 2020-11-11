//
//  LoggingUtil.swift
//  TFS Chat
//
//  Created by dmitry on 16.09.2020.
//  Copyright © 2020 dmitry. All rights reserved.
//

struct LoggingUtil {
    
    static func debugPrint(_ info: String) {
        #if DEBUG
        print(info + "\n")
        #endif
    }
}
