//
//  ViewController.swift
//  Hinds_Justin_CE9
//
//  Created by Justin Hinds on 10/19/16.
//  Copyright © 2016 Justin Hinds. All rights reserved.
//

import UIKit
import MessageUI
import ContactsUI

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, CNContactPickerDelegate, CNContactViewControllerDelegate, MFMailComposeViewControllerDelegate {
    // contact store variable
    var contactStore : CNContactStore?
    //tableView reference
    @IBOutlet weak var myTableView: UITableView!
    //array for emails
    var emails = [Email]()
    var lastEmail : Email?
    
    @IBAction func displayContacts(_ sender: UIBarButtonItem) {
        let picker = CNContactPickerViewController()
        picker.delegate = self
        present(picker, animated: true, completion: nil)
    }

    @IBAction func newContact(_ sender: UIBarButtonItem) {
        let newContact = CNContactViewController(forNewContact: nil)
        newContact.delegate = self
        newContact.contactStore = contactStore
        navigationController?.pushViewController(newContact, animated: true)
    }
    let cellIdentifier = "cell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let status = CNContactStore.authorizationStatus(for: .contacts)
        if status == .authorized{
            contactStore = CNContactStore()
            
        }else if status == .notDetermined{
            contactStore = CNContactStore()
            contactStore?.requestAccess(for: .contacts, completionHandler: { (granted, error) in
                if let error = error{
                    print("error : \(error)")
                    return
                }
            })
            
        }else if status == .denied{
            
        }
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        cell.textLabel?.text = emails[indexPath.row].recipient
        cell.detailTextLabel?.text = emails[indexPath.row].time
        return cell
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return emails.count
    }
    //MARK: - CNContactPickerDelegate
    
    func contactPicker(_ picker: CNContactPickerViewController, didSelect contactProperty: CNContactProperty) {
        if contactProperty.key == "emailAddresses" {
            print("email slected")

            if MFMailComposeViewController.canSendMail(){
                dismiss(animated: true, completion: {
                    let composeMail = MFMailComposeViewController()
                    composeMail.mailComposeDelegate = self
                    let recipient = contactProperty.value as! String
                    var recipientEmails = [String]()
                    recipientEmails.append(recipient)
                    
                    //composeMail.setr
                    composeMail.setToRecipients(recipientEmails)
                    self.lastEmail = Email(toAddress: recipient, currentTime: Date())
                    
                    self.present(composeMail, animated: true, completion: nil)
                    
                })
            }
        }
    }
    //MARK: - MailCompseDelegate
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        if let error = error{
            print("error occured\(error)")
        }
        if result == .sent{
            emails.append(lastEmail!)
            navigationController?.popToRootViewController(animated: true)
        }
        
        dismiss(animated: true, completion: {
       self.myTableView.reloadData()
        })
    }
    //MARK: - CNContactViewController delegate
    
    func contactViewController(_ viewController: CNContactViewController, didCompleteWith contact: CNContact?) {
        if contact == nil{
            print("Canceled")
        }
        navigationController?.popToRootViewController(animated: true)
    }
    
}

