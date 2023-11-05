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
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.reusableTable, for: indexPath) as! messageViewCell
        cell.mssg.text=messages[indexPath.row].body
        return cell
    }
    
    
}
extension ChatViewController: UITableViewDelegate {
    
}
