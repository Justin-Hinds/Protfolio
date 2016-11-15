//
//  ArtistViewController.swift
//  HindsArt
//
//  Created by Justin Hinds on 11/9/16.
//  Copyright © 2016 Justin Hinds. All rights reserved.
//

import UIKit
import MessageUI
import Firebase

class ArtistViewController: UIViewController, MFMailComposeViewControllerDelegate {
    
    var artist = Artist()
    @IBOutlet weak var profilePicImgView: UIImageView!
    @IBOutlet weak var nameLable: UILabel!
    @IBOutlet weak var birthPlaceLable: UILabel!
    @IBOutlet weak var birthdateLable: UILabel!
    @IBOutlet weak var inspirationTextView: UITextView!
    @IBOutlet weak var bioTextView: UITextView!
    @IBAction func sendRequestButton(_ sender: UIButton) {
        handleRequestOrUpdate()
    }
    @IBOutlet weak var requestButton: UIButton!
    @IBOutlet weak var birthPlaceText: UITextView!
    @IBOutlet weak var birthdayText: UITextView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameLable.text = artist.name
        self.navigationItem.title = artist.name
        
        guard let bio = artist.bio else{
            return
        }
        guard let inspiration = artist.inspiration else{
            return
        }
        guard let birthPlace = artist.birthPlace else{
            return
        }
        guard let birthday = artist.birthday else{
            return
        }
        bioTextView.text = bio
        inspirationTextView.text = inspiration
        birthPlaceText.text = birthPlace
        birthdayText.text = birthday
              // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        profilePicImgView.loadImageUsingCache(artist.profileImageURL!)
        if FIRAuth.auth()?.currentUser?.uid != artist.id{
            bioTextView.isEditable = false
            inspirationTextView.isEditable = false
            birthdayText.isEditable = false
            birthPlaceText.isEditable = false
            requestButton.titleLabel?.text = "Send Request"
        }else if FIRAuth.auth()?.currentUser?.uid == artist.id{
            bioTextView.isEditable = true
            inspirationTextView.isEditable = true
            birthdayText.isEditable = true
            birthPlaceText.isEditable = true
            requestButton.titleLabel?.text = "Update Profile"
        }

    }
    func handleRequestOrUpdate() {
        if FIRAuth.auth()?.currentUser?.uid != artist.id {
            print("SEND REQUEST hit")
            sendPaintingRequest()
        }else if FIRAuth.auth()?.currentUser?.uid == artist.id{
            print("update HIT")
            updateProfile()
        }
    }
    func updateProfile()  {
    let ref = FIRDatabase.database().reference()
    let bio = bioTextView.text
    let inspiration = inspirationTextView.text
    let birthday = birthdayText.text
    let birthPlace = birthPlaceText.text
    let update = ["birthday" : birthday, "birthPlace" : birthPlace, "bio" : bio, "inspiration" : inspiration]
        ref.child("artists").child(artist.id!).updateChildValues(update)
        dismiss(animated: true, completion: nil)
    }
    func sendPaintingRequest() {
        if MFMailComposeViewController.canSendMail(){
            let composeMail = MFMailComposeViewController()
            composeMail.mailComposeDelegate = self
            let recipient = self.artist.email
            var recipientEmails = [String]()
            recipientEmails.append(recipient!)
            composeMail.setSubject("Request for custom painting.")
            composeMail.setToRecipients(recipientEmails)
            self.present(composeMail, animated: true, completion: nil)
        }

    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        if let error = error{
            print("error occured\(error)")
        }
        if result == .sent{
        }
       // navigationController?.popToRootViewController(animated: true)

        dismiss(animated: true, completion: {})
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
