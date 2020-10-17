//
//  FirestoreManager.swift
//  TFS Chat
//
//  Created by dmitry on 17.10.2020.
//  Copyright © 2020 dmitry. All rights reserved.
//

import Firebase

struct FirestoreManager {
    
    static let db = Firestore.firestore()
    static let root = db.collection("channels")
}
