//
//  ViewSnapViewController.swift
//  snapchatApp
//
//  Created by El nino Cholo on 2020/07/24.
//  Copyright © 2020 El nino Cholo. All rights reserved.
//

import UIKit
import Firebase
import SDWebImage
import ChameleonFramework


class ViewSnapViewController: UIViewController {

    var mySnapshot:DataSnapshot?
    
    var myimageName:String = ""
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var Messages: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        extractingData()
    }
    
    func extractingData()
    {
        if let snapshot = mySnapshot?.value as? [String:Any]
        {
                if let imagesFrom = snapshot["From"] as? String
                {
                    print(imagesFrom)
                    
                    if let imageURl = snapshot["ImgURL"] as? String
                    {
                        if let descipt = snapshot["desc"] as? String
                        {
                         
                            if let url = URL(string: imageURl)
                            {
                                   Messages.text = descipt
                                   imageView.sd_setImage(with: url, completed: nil)
                            }
                            if let image = snapshot["imageName"] as? String
                            {
                                myimageName = image
                            }
                        }
                    }
                }
            }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if let usercurrentUI = Auth.auth().currentUser?.uid
        {
            if let mykey = mySnapshot?.key
            {
                Database.database().reference().child("Users").child(usercurrentUI).child("snaps").child(mykey).removeValue()
                
                Storage.storage().reference().child("images").child(myimageName).delete { (error) in
                    if error != nil
                    {
                        print("There was an error while deleting the snap \(error!.localizedDescription)")
                    }
                }
                
            }
            
            
        }
    }
    
}
