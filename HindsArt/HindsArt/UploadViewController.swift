//
//  UploadViewController.swift
//  HindsArt
//
//  Created by Justin Hinds on 11/5/16.
//  Copyright © 2016 Justin Hinds. All rights reserved.
//

import UIKit
import Firebase

class UploadViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var newPaintingImg: UIImageView!
    @IBOutlet weak var paintingTitle: UITextField!
    @IBOutlet weak var paintingPrice: UITextField!
    @IBAction func uploadPaintingButton(_ sender: UIButton) {
        if let img = newPaintingImg.image{
            uploadImageToFirebase(img)
        }else{
            print("UPLOAD FAILED")
        }
     //   handleUpload()
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        newPaintingImg.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector( handleUpload))
        tap.numberOfTapsRequired = 1
        newPaintingImg.addGestureRecognizer(tap)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    fileprivate func uploadImageToFirebase(_ img: UIImage){
        let imageName = UUID().uuidString
        let storageRef = FIRStorage.storage().reference().child("paintings_images").child(imageName)
        if let uploadData = UIImageJPEGRepresentation(img, 0.5){
            storageRef.put(uploadData, metadata: nil, completion: { (metadata, error) in
                if error != nil{
                    print(error!)
                    return
                }
                if let imageUrl = metadata?.downloadURL()?.absoluteString{
                    self.uploadPainting(imageUrl, img: img)
                }
            })
            
        }
        
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    func handleUpload(){
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        var selectedImageFromPicker = UIImage()
        if let originalImage = info["UIImagePickerControllerOriginalImage"]{
            selectedImageFromPicker = (originalImage as! UIImage)
        }
        let selectedImage = selectedImageFromPicker
        uploadImageToFirebase(selectedImage )
        newPaintingImg.image = selectedImage
        dismiss(animated: true, completion: nil)
        
        
    }

    fileprivate func uploadPainting(_ imgURL: String, img: UIImage){
        let ref = FIRDatabase.database().reference().child("paintings")
        let childRef = ref.childByAutoId()
        
        print(FIRAuth.auth()?.currentUser! as Any)
        let senderId = FIRAuth.auth()!.currentUser!.uid
        //let time: NSNumber = NSNumber(Int(Date().timeIntervalSince1970))
        let values = ["imgURL": imgURL, "imgHeight": img.size.height, "imgWidth": img.size.width] as [String : Any]
        childRef.updateChildValues(values) { (error, ref) in
            if error != nil{
                print(error!)
                return
            }
            let artistPaintingRef = FIRDatabase.database().reference().child("artist_paintings").child(senderId)
            let paintingID = childRef.key
            artistPaintingRef.updateChildValues([paintingID : 1])
            
//            let recipientMessageRef = FIRDatabase.database().reference().child("artist_paintings").child(toId)
//            recipientMessageRef.updateChildValues([paintingID : 1])
        }
    }
   
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
