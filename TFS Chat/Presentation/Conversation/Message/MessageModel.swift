//
//  MessageModel.swift
//  TFS Chat
//
//  Created by dmitry on 17.10.2020.
//  Copyright © 2020 dmitry. All rights reserved.
//
import Foundation
import FirebaseFirestore

struct MessageModel {
    
    let identifier: String
    let content: String
    let created: Date
    let senderId: String
    let senderName: String
    
    init(content: String, created: Date, senderId: String, senderName: String) {
        self.identifier = ""
        self.content = content
        self.created = created
        self.senderId = senderId
        self.senderName = senderName
    }
    
    init?(firebaseData: QueryDocumentSnapshot) {
        let data = firebaseData.data()
        self.identifier = firebaseData.documentID
        guard let content = data["content"] as? String else { return nil }
        guard let senderName = data["senderName"] as? String else { return nil }
        guard let senderId = data["senderId"] as? String else { return nil }
        guard let createdTimestamp = data["created"] as? Timestamp else { return nil }
        self.content = content
        self.created = createdTimestamp.dateValue()
        self.senderId = senderId
        self.senderName = senderName
    }
    
    func toFirebaseDictionary() -> [String: Any] {
        var data: [String: Any] = [
            "content": self.content,
            "created": Timestamp(date: self.created),
            "senderId": self.senderId,
            "senderName": self.senderName
        ]
        if self.identifier != "" {
            data["identifier"] = self.identifier
        }
        return data
    }
}
