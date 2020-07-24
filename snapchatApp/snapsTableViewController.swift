//
//  snapsTableViewController.swift
//  snapchatApp
//
//  Created by El nino Cholo on 2020/07/23.
//  Copyright © 2020 El nino Cholo. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import ChameleonFramework

class snapsTableViewController: UITableViewController {

    override func viewWillAppear(_ animated: Bool) {
        self.tableView.reloadData()
        
    }
    var listSnaps:[DataSnapshot] = [DataSnapshot]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.rowHeight = 80
        self.tableView.separatorColor = UIColor.flatOrange()
        getcurrentuser()
//        Timer.scheduledTimer(withTimeInterval: 2, repeats: true) { (Timer) in
//            self.tableView.reloadData()
//        }

    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if listSnaps.count  == 0
        {
            return 1
        }else
        {
        return listSnaps.count
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "snapcell", for: indexPath)
        
        if listSnaps.count == 0
        {
            cell.textLabel?.text = "You have no snaps 😒"
        }else
        {
            let item = listSnaps[indexPath.row]
            
            if let usersnap = item.value
            {
                if let snap =  usersnap as? [String:Any]
                {
                    if let imagesFrom = snap["From"] as? String
                    {
                        
                        cell.textLabel?.text = imagesFrom
                    }
                }
                
            }
            
        }
        
        return cell
        
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if listSnaps.count == 0
        {
            alertmessage(title: "No Snaps", message: "You have no snpas 😒")
            
        }else
        {
            let currentsnap = listSnaps[indexPath.row]
            
            performSegue(withIdentifier: "viewsnap", sender: currentsnap)
        }
       
    
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "viewsnap"
        {
            let secondVC = segue.destination as! ViewSnapViewController
            if let currentsnap = sender as? DataSnapshot
            {
                secondVC.mySnapshot = currentsnap
            }
            
        }
    }
    @IBAction func logOut(_ sender: Any)
    {
        do
        {
            try Auth.auth().signOut()
            
        }catch let error as NSError
        {
            
            alertmessage(title: "Error", message: error.localizedDescription)
        }
        
       guard (navigationController?.dismiss(animated: true, completion: nil)) != nil
        else
       {
        self.alertmessage(title: "Error", message: "There was no view to pop")
        self.dismiss(animated: true, completion: nil)
        return
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
    
    func getcurrentuser()
    {
        if let currentuserid = Auth.auth().currentUser?.uid
        {
            Database.database().reference().child("Users").child(currentuserid).child("snaps").observe(.childAdded) { (snapshot) in
                
                self.listSnaps.append(snapshot)
                self.tableView.reloadData()
                
                Database.database().reference().child("Users").child(currentuserid).child("snaps").observe(.childRemoved) { (yosnapshot) in
                   
                    var index = 0
                    for snaps in self.listSnaps
                    {
                        if snaps.key == yosnapshot.key
                        {
                            self.listSnaps.remove(at: index)
                         
                        }
                        
                        index += 1
                    }
                       self.tableView.reloadData()
                }
            }
            
        }

        
    }
}
