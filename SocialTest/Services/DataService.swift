//
//  DataService.swift
//  SocialTest
//
//  Created by Sergiy Lyahovchuk on 24.08.17.
//  Copyright © 2017 HardCode. All rights reserved.
//

import Foundation
import Firebase
import SwiftKeychainWrapper

let DB_BASE = Database.database().reference()
let DB_STORAGE = Storage.storage().reference()

class DataService {
    
    static let ds = DataService()
    
    //DB reference
    private var _REF_BASE = DB_BASE
    private var _REF_POSTS = DB_BASE.child("posts")
    private var _REF_USERS = DB_BASE.child("users")
    
    //storage reference
    private var _REF_POST_IMAGES = DB_STORAGE.child("post-pics")
    
    var REF_BASE: DatabaseReference {
        return _REF_BASE
    }
    
    var REF_POSTS: DatabaseReference {
        return _REF_POSTS
    }
    
    var REF_USERS: DatabaseReference {
        return _REF_USERS
    }
 
    var REF_USER_CURRENT: DatabaseReference {
        let uid = KeychainWrapper.standard.string(forKey: KEY_UID)
        let user = REF_USERS.child(uid!)
        
        return user
    }
    
    var REF_POST_IMAGES: StorageReference {
        return _REF_POST_IMAGES
    }

    
    func createFirebaseUser(uid: String, userData: [String: String]) {
        REF_USERS.child(uid).updateChildValues(userData)
    }
    
}
