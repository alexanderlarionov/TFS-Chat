//
//  ColorTheme.swift
//  TFS Chat
//
//  Created by dmitry on 07.10.2020.
//  Copyright © 2020 dmitry. All rights reserved.
//

import UIKit

enum ColorTheme: Int {
    
    case classic, day, night
    
    var navigationBarColor: UIColor {
        switch self {
        case .classic:
            return UIColor(red: 0.961, green: 0.961, blue: 0.961, alpha: 1)
        case .day:
            return UIColor(red: 0.875, green: 0.875, blue: 0.875, alpha: 1)
        case .night:
            return UIColor(red: 0.118, green: 0.118, blue: 0.118, alpha: 1)
        }
    }
    
    var navigationBarTextColor: UIColor {
        switch self {
        case .classic:
            return UIColor.black
        case .day:
            return UIColor.black
        case .night:
            return UIColor.white
        }
    }
    
    var conversationListBackgroundColor: UIColor {
        switch self {
        case .classic:
            return UIColor.white
        case .day:
            return UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1)
        case .night:
            return UIColor.black
        }
    }
    
    var conversationListCellColor: UIColor {
        switch self {
        case .classic:
            return UIColor(red: 1.0, green: 1.0, blue: 0.65, alpha: 1.0)
        case .day:
            return UIColor(red: 0.58, green: 0.66, blue: 0.75, alpha: 1.00)
        case .night:
            return UIColor(red: 0.118, green: 0.118, blue: 0.118, alpha: 1)
        }
    }

    var conversationListCellNameColor: UIColor {
        switch self {
        case .classic:
            return UIColor.black
        case .day:
            return UIColor.black
        case .night:
            return UIColor.white
        }
    }
    
    var conversationListCellTextColor: UIColor {
        switch self {
        case .classic:
            return UIColor(red: 0.235, green: 0.235, blue: 0.263, alpha: 0.6)
        case .day:
            return UIColor(red: 0.235, green: 0.235, blue: 0.263, alpha: 0.6)
        case .night:
            return UIColor(red: 0.553, green: 0.553, blue: 0.576, alpha: 1)
        }
    }
    
    var themesViewControllerBackgroundColor: UIColor {
        switch self {
        case .classic:
            return UIColor(red: 0.07, green: 0.55, blue: 0.49, alpha: 1.00)
        case .day:
            return UIColor(red: 0.098, green: 0.21, blue: 0.379, alpha: 1)
        case .night:
            return UIColor(red: 0.118, green: 0.118, blue: 0.118, alpha: 1)
        }
    }
    
    var sentMessageBackgroundColor: UIColor {
        switch self {
        case .classic:
            return UIColor(red: 0.875, green: 0.875, blue: 0.875, alpha: 1)
        case .day:
            return UIColor(red: 0.918, green: 0.922, blue: 0.929, alpha: 1)
        case .night:
            return UIColor(red: 0.18, green: 0.18, blue: 0.18, alpha: 1)
        }
    }
    
    var recievedMessageBackgroundColor: UIColor {
        switch self {
        case .classic:
            return UIColor(red: 0.863, green: 0.969, blue: 0.773, alpha: 1)
        case .day:
            return UIColor(red: 0.263, green: 0.537, blue: 0.976, alpha: 1)
        case .night:
            return UIColor(red: 0.361, green: 0.361, blue: 0.361, alpha: 1)
        }
    }
    
    var sentMessageTextColor: UIColor {
        switch self {
        case .classic:
            return UIColor.black
        case .day:
            return UIColor.black
        case .night:
            return UIColor.white
        }
    }
    
    var recievedMessageTextColor: UIColor {
        switch self {
        case .classic:
            return UIColor.black
        case .day:
            return UIColor.white
        case .night:
            return UIColor.white
        }
    }
    
    var conversationViewBackgroundColor: UIColor {
        switch self {
        case .classic:
            return UIColor.white
        case .day:
            return UIColor.white
        case .night:
            return UIColor.black
        }
    }
    
}
