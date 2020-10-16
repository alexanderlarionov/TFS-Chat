//
//  FakeData.swift
//  TFS Chat
//
//  Created by dmitry on 29.09.2020.
//  Copyright © 2020 dmitry. All rights reserved.
//

import Foundation

struct FakeData {
    
    static var conversationListData = [
        [ConversationCellModel(
            name: randomString(length: 5) + " " + randomString(length: 5),
            message: randomString(length: 10) + " " + randomString(length: 10),
            date: Date(),
            isOnline: true,
            hasUnreadMessages: false),
         
         ConversationCellModel(
            name: randomString(length: 3) + " " + randomString(length: 10),
            message: randomString(length: 5) + " " + randomString(length: 3) + " " + randomString(length: 8),
            date: Calendar.current.date(byAdding: .minute, value: -14, to: Date())!,
            isOnline: true,
            hasUnreadMessages: true),
         
         ConversationCellModel(
            name: randomString(length: 10) + " " + randomString(length: 10),
            message: randomString(length: 10),
            date: Calendar.current.date(byAdding: .day, value: -3, to: Date())!,
            isOnline: true,
            hasUnreadMessages: false),
         
         ConversationCellModel(
            name: randomString(length: 5) + " " + randomString(length: 35),
            message: randomString(length: 7) + " " + randomString(length: 8),
            date: Date(),
            isOnline: true,
            hasUnreadMessages: true),
         
         ConversationCellModel(
            name: randomString(length: 5) + " " + randomString(length: 5),
            message: "",
            date: Calendar.current.date(byAdding: .hour, value: -2, to: Date())!,
            isOnline: true,
            hasUnreadMessages: false),
         
         ConversationCellModel(
            name: randomString(length: 5) + " " + randomString(length: 5),
            message: randomString(length: 30),
            date: Date(),
            isOnline: true,
            hasUnreadMessages: false),
         
         ConversationCellModel(
            name: randomString(length: 3) + " " + randomString(length: 10),
            message: randomString(length: 100),
            date: Calendar.current.date(byAdding: .minute, value: -14, to: Date())!,
            isOnline: true,
            hasUnreadMessages: true),
         
         ConversationCellModel(
            name: randomString(length: 10) + " " + randomString(length: 10),
            message: randomString(length: 10),
            date: Calendar.current.date(byAdding: .day, value: -3, to: Date())!,
            isOnline: true,
            hasUnreadMessages: false),
         
         ConversationCellModel(
            name: randomString(length: 5) + " " + randomString(length: 35),
            message: "",
            date: Date(),
            isOnline: true,
            hasUnreadMessages: true),
         
         ConversationCellModel(
            name: randomString(length: 5) + " " + randomString(length: 5),
            message: "",
            date: Calendar.current.date(byAdding: .hour, value: -2, to: Date())!,
            isOnline: true,
            hasUnreadMessages: false)
        ],
        
        [ConversationCellModel(
            name: randomString(length: 5) + " " + randomString(length: 5),
            message: randomString(length: 30),
            date: Date(),
            isOnline: false,
            hasUnreadMessages: false),
         
         ConversationCellModel(
            name: randomString(length: 3) + " " + randomString(length: 10),
            message: randomString(length: 100),
            date: Calendar.current.date(byAdding: .minute, value: -22, to: Date())!,
            isOnline: false,
            hasUnreadMessages: true),
         
         ConversationCellModel(
            name: randomString(length: 10) + " " + randomString(length: 10),
            message: randomString(length: 10),
            date: Calendar.current.date(byAdding: .day, value: -100, to: Date())!,
            isOnline: false,
            hasUnreadMessages: false),
         
         ConversationCellModel(
            name: randomString(length: 5) + " " + randomString(length: 35),
            message: randomString(length: 5),
            date: Date(),
            isOnline: false,
            hasUnreadMessages: true),
         
         ConversationCellModel(
            name: randomString(length: 5) + " " + randomString(length: 5),
            message: randomString(length: 50) + " " + randomString(length: 50),
            date: Calendar.current.date(byAdding: .hour, value: -22, to: Date())!,
            isOnline: false,
            hasUnreadMessages: false),
         
         ConversationCellModel(
            name: randomString(length: 5) + " " + randomString(length: 5),
            message: randomString(length: 30),
            date: Date(),
            isOnline: false,
            hasUnreadMessages: false),
         
         ConversationCellModel(
            name: randomString(length: 3) + " " + randomString(length: 10),
            message: randomString(length: 100),
            date: Calendar.current.date(byAdding: .minute, value: -1, to: Date())!,
            isOnline: false,
            hasUnreadMessages: true),
         
         ConversationCellModel(
            name: randomString(length: 10) + " " + randomString(length: 10),
            message: randomString(length: 10),
            date: Calendar.current.date(byAdding: .day, value: -3, to: Date())!,
            isOnline: false,
            hasUnreadMessages: false),
         
         ConversationCellModel(
            name: randomString(length: 5) + " " + randomString(length: 35),
            message: randomString(length: 5),
            date: Date(),
            isOnline: false,
            hasUnreadMessages: true),
         
         ConversationCellModel(
            name: randomString(length: 5) + " " + randomString(length: 5),
            message: randomString(length: 15) + " " +  randomString(length: 20),
            date: Calendar.current.date(byAdding: .hour, value: -2, to: Date())!,
            isOnline: false,
            hasUnreadMessages: false)
        ]
    ]
    
    static var conversationData = [
        MessageCellModel(text: randomString(length: 20) + " " + randomString(length: 30), type: .sent),
        MessageCellModel(text: randomString(length: 5) + randomString(length: 20), type: .recieved),
        MessageCellModel(text: randomString(length: 4) + randomString(length: 6), type: .sent),
        MessageCellModel(text: randomString(length: 6) + " " + randomString(length: 5), type: .recieved),
        MessageCellModel(text: randomString(length: 20), type: .sent),
        MessageCellModel(text: randomString(length: 30), type: .sent),
        MessageCellModel(text: randomString(length: 3), type: .recieved),
        MessageCellModel(text: randomString(length: 4) + randomString(length: 6), type: .sent),
        MessageCellModel(text: randomString(length: 6) + " " + randomString(length: 5) + " " + randomString(length: 5), type: .recieved),
        MessageCellModel(text: randomString(length: 20) + " " + randomString(length: 9), type: .recieved)
    ]
    
    private static func randomString(length: Int) -> String {
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
        return String((0..<length).map { _ in letters.randomElement()! })
    }
}
