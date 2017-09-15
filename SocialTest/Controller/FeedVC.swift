 //
//  FeedVC.swift
//  SocialTest
//
//  Created by Sergiy Lyahovchuk on 23.08.17.
//  Copyright © 2017 HardCode. All rights reserved.
//

import UIKit
import Firebase
import SwiftKeychainWrapper

class FeedVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var imageAdd: CircleImageView!
    
    var posts: [Post] = []
    let imagePicker = UIImagePickerController()
    static var imageCache: NSCache<NSString, UIImage> = NSCache()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        imagePicker.delegate = self
        
        DataService.ds.REF_POSTS.observe(.value, with: { (snapshot) in
            if let snapshots = snapshot.children.allObjects as? [DataSnapshot] {
                for snap in snapshots {
                    print("SNAP: \(snap)")
                    if let postDict = snap.value as? [String: AnyObject] {
                        let key = snap.key
                        let post = Post(postKey: key, postData: postDict)
                        self.posts.append(post)
                    }
                }
            }
            self.tableView.reloadData()
        })
    }

    // MARK: - IBActions
    
    @IBAction func onBtnSignOutPressed(_ sender: Any) {
        let keychainResult = KeychainWrapper.standard.removeObject(forKey: KEY_UID)
        print("JESS: TokenID removed from keychain - \(keychainResult)")
        try! Auth.auth().signOut()
        performSegue(withIdentifier: "FeedVCToSignInSegue", sender: nil)
    }
    
    @IBAction func addImagePressed(_ sender: Any) {
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .photoLibrary
        imagePicker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
//        imagePicker.modalPresentationStyle = .popover
        present(imagePicker, animated: true, completion: nil)
//        imagePicker.popoverPresentationController?.barButtonItem = sender as! UIBarButtonItem
    }
}

 extension FeedVC : UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let post = posts[indexPath.row]
        if let cell = tableView.dequeueReusableCell(withIdentifier: "postCell") as? PostCell {
            if let img = FeedVC.imageCache.object(forKey: post.imagesUrl as NSString) {
                cell.configureCell(post: post, image: img)
            } else {
                cell.configureCell(post: post)
            }
            
            return cell
        } else {
            return PostCell()
        }
    }
    
 }
 
 extension FeedVC : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    //MARK: - Delegates
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let chosenImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
//            imageAdd.contentMode = .scaleAspectFit
            imageAdd.image = chosenImage
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
 }
