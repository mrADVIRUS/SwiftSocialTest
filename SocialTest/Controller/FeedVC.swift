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
    @IBOutlet weak var captionText: FancyField!
    
    var posts: [Post] = []
    let imagePicker = UIImagePickerController()
    static var imageCache: NSCache<NSString, UIImage> = NSCache()
    var imageSelected = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        imagePicker.delegate = self
        
        DataService.ds.REF_POSTS.observe(.value, with: { (snapshot) in
            if let snapshots = snapshot.children.allObjects as? [DataSnapshot] {
                self.posts.removeAll()
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
    
    @IBAction func onBtnPostPressed(_ sender: Any) {
        guard let caption = captionText.text, caption != "" else {
            print("JESS: Caption must be entered")
            return
        }
        guard let img = imageAdd.image, imageSelected == true else {
            print("JESS: image must be selected")
            return
        }
        
        uploadImage(img, progressBlock: { value in
            print("progress = \(value)")
        }) { (url, error) in
            if error != nil {
                print("JESS: Unable to upload image to Firebase Storage. -> \(String(describing: error))")
            } else {
                if let downloadUrl = url {
                    print("JESS: Image was sucessfull upload to Firebase Storage. Responce URL -> \(downloadUrl.absoluteString)")
                    self.postToFirebase(imgUrl: downloadUrl.absoluteString)
                }
            }
        }
        
    }
    
    @IBAction func addImagePressed(_ sender: Any) {
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .photoLibrary
        imagePicker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
//        imagePicker.modalPresentationStyle = .popover
        present(imagePicker, animated: true, completion: nil)
//        imagePicker.popoverPresentationController?.barButtonItem = sender as! UIBarButtonItem
    }
    
    // MARK: - Private
    
    func uploadImage(_ image: UIImage, progressBlock: @escaping (_ percentage: Double) -> Void, completionBlock: @escaping (_ url: URL?, _ errorMessage: String?) -> Void) {

        let imgUid = NSUUID().uuidString
        let imageName = "\(imgUid).jpg"
        let imagesReference = DataService.ds.REF_POST_IMAGES.child(imageName)
        
        if let imageData = UIImageJPEGRepresentation(image, 0.5) {
            let metadata = StorageMetadata()
            metadata.contentType = "image/jpeg"
            
            let uploadTask = imagesReference.putData(imageData, metadata: metadata, completion: { (metadata, error) in
                if let metadata = metadata {
                    completionBlock(metadata.downloadURL(), nil)
                } else {
                    completionBlock(nil, error?.localizedDescription)
                }
            })
            
            uploadTask.observe(.progress, handler: { (snapshot) in
                guard let progress = snapshot.progress else {
                    return
                }
                
                let percentage = (Double(progress.completedUnitCount) / Double(progress.totalUnitCount)) * 100
                progressBlock(percentage)
            })
        } else {
            completionBlock(nil, "Image couldn't be converted to Data.")
        }
    }
    
    func postToFirebase(imgUrl: String) {
        let post: [String: AnyObject] = [
            "caption": captionText.text! as AnyObject,
            "imageUrl": imgUrl as AnyObject,
            "likes": 0 as AnyObject
        ]
        
        let fireBasePost = DataService.ds.REF_POSTS.childByAutoId()
        fireBasePost.setValue(post)
        
        captionText.text = ""
        imageSelected = false
        imageAdd.image = UIImage(named: "add-image")
        
//        tableView.reloadData()
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
            imageSelected = true
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
 }
