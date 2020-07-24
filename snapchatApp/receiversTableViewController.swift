//
//  receiversTableViewController.swift
//  snapchatApp
//
//  Created by El nino Cholo on 2020/07/23.
//  Copyright © 2020 El nino Cholo. All rights reserved.
//

import UIKit
import Firebase
import ChameleonFramework

class receiversTableViewController: UITableViewController {

    
    var listUser:[User] = [User]()
    
    let database = Database.database().reference().child("Users")
    var ImageName:String?
    var downloadURl:String?
    var messageField:String?
    var nameofimage:String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
      
        self.tableView.rowHeight = 80
        self.tableView.separatorColor = UIColor.flatOrange()
         loadData()
        
        if let myimagesname = ImageName
        {
            nameofimage = myimagesname
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listUser.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let currentuser = listUser[indexPath.row]
        if let currentsession = Auth.auth().currentUser?.email
        {
            if currentsession != currentuser.email
            {
                cell.textLabel?.text = currentuser.email
            }
        }
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
             let currentuser = listUser[indexPath.row]
        
            if let email = Auth.auth().currentUser?.email
            {
                if let imageURL = downloadURl
                {
                    if let mydesciption = messageField
                    {
                        let snap = ["desc": mydesciption ,"From": email,"ImgURL": imageURL,"imageName" : self.nameofimage] as [String:Any]
                        database.child(currentuser.userId).child("snaps").childByAutoId().setValue(snap) { (error, reference) in
                            if error != nil
                            {
                                print("There was an error \(error!.localizedDescription)")
                                self.alertmessage(title: "Error", message: error!.localizedDescription)
                            }else
                            {
                                self.alertmessage(title: "Snap!!!", message: "Sent Successfully :)")
                                self.navigationController?.popToRootViewController(animated: true)
                            }
                        }
                    }
                    
                }
            }
        
    }
    
    
    func loadData()
    {
        Database.database().reference().child("Users").observe(DataEventType.childAdded) { (snapshot) in
            
            if let userinfos = snapshot.value
            {
                if let userdatainfo = userinfos as? [String:Any]
                {
                    let user = User()
                    if let useremail = userdatainfo["email"] as? String
                    {
                        user.email = useremail
                        user.userId = snapshot.key
                        self.listUser.append(user)
                        self.tableView.reloadData()
                    }
                }
                
            }
            
        }
        
    }
    
    func alertmessage(title: String,message: String)
       {
           let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
           let action = UIAlertAction(title: "ok", style: .default) { (erickhendler) in
               print("I love you so much")
           }
           alert.addAction(action)
           self.present(alert, animated: true, completion: nil)
       }

}
