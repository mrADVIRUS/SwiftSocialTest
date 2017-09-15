//
//  Post.swift
//  SocialTest
//
//  Created by Sergiy Lyahovchuk on 04.09.17.
//  Copyright © 2017 HardCode. All rights reserved.
//

import Foundation

class Post {
    private var _caption: String!
    private var _imageUrl: String!
    private var _likes: Int!
    private var _postKey: String!
    
    var caption: String {
        return _caption
    }
    
    var imagesUrl: String {
        return _imageUrl
    }
    
    var likes: Int {
        return _likes
    }
    
    var postKey: String {
        return _postKey
    }
    
    init(caption: String, imageUrl: String, likes: Int) {
        _caption = caption
        _imageUrl = imageUrl
        _likes = likes
    }
    
    init(postKey: String, postData: [String: AnyObject]) {
        _postKey = postKey
        
        if let caption = postData["caption"] as? String {
            _caption = caption
        }
        if let imageUrl = postData["imageUrl"] as? String  {
            _imageUrl = imageUrl
        }
        if let likes = postData["likes"] as? Int {
            _likes = likes
        }
        
    }
    
}
