//
//  ChatViewController.swift
//  Flash Chat iOS13
//
//  Created by Angela Yu on 21/10/2019.
//  Copyright © 2019 Angela Yu. All rights reserved.
//

import UIKit
import Firebase
class ChatViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageTextfield: UITextField!
    
    let db = Firestore.firestore()
    
    var messages: [Message] = [
    Message(sender: "jhojan_54_56@hotmail.com", body: "hello")
    ]
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource=self
        navigationItem.hidesBackButton = true
        tableView.register(UINib(nibName: "messageViewCell", bundle: nil),forCellReuseIdentifier: "ReusableCell")
        loadMessage()
    }
    
    func loadMessage(){
        db.collection("messages").order(by:"date").addSnapshotListener {
            (querySnapshot,error) in
            
            self.messages = []

            if let e = error {
                print("There was an issue retrieving data from Firestore\(e)")
            } else {
                if let snapshotDocuments = querySnapshot?.documents{
                    for doc in snapshotDocuments {
                        let data = doc.data()
                        if let mssgsender = data["sender"] as? String,let mssgBody  = data["body"] as? String{
                            let newMessage = Message(sender: mssgsender, body: mssgBody)
                            self.messages.append(newMessage)
                            
                            DispatchQueue.main.async {
                                self.tableView.reloadData()
                                let indexPath = IndexPath(row: self.messages.count-1, section: 0)
                                self.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
                            }
                        }
                     }
                }
            }
        }
    }
    
    @IBAction func sendPressed(_ sender: UIButton) {
      if  let mssgBody = messageTextfield.text,
        let messageSender = Auth.auth().currentUser?.email
        {
          db.collection("messages").addDocument(data: ["sender":messageSender,"body":mssgBody,"date":Date().timeIntervalSince1970]){
              (error) in if let e = error{
                  print("there was a issue saving data")
              }else{
                  print("Successfully saved data")
                  DispatchQueue.main.async {
                      self.messageTextfield.text=""
                  }
              }
          }
        }
    }
    
    @IBAction func LogOut(_ sender: UIBarButtonItem) {
        let firebaseAuth = Auth.auth()
        do{
            try firebaseAuth.signOut()
            navigationController?.popToRootViewController(animated: true)
        } catch let signOutError as NSError{
            print("Error signing out:",signOutError)
        }
        
    }
    
}


extension ChatViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let message = messages[indexPath.row]

        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.reusableTable, for: indexPath) as! messageViewCell
        
        cell.mssg.text=messages[indexPath.row].body
        if message.sender == Auth.auth().currentUser?.email{
            cell.leftphotouser.isHidden=true
            cell.photouser.isHidden=false
            cell.messageBundle.backgroundColor = UIColor(named: "BrandBlue")
            cell.mssg.textColor = UIColor.black
        }
        else {
            cell.leftphotouser.isHidden=false
            cell.photouser.isHidden=true
            cell.messageBundle.backgroundColor = UIColor(named: "BrandLightBlue")
            cell.mssg.textColor = UIColor.black
        }
        return cell
    }
    
    
}
extension ChatViewController: UITableViewDelegate {
    
}
