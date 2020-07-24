//
//  sendsnapViewController.swift
//  snapchatApp
//
//  Created by El nino Cholo on 2020/07/23.
//  Copyright © 2020 El nino Cholo. All rights reserved.
//

import UIKit
import Firebase
import ChameleonFramework


class sendsnapViewController: UIViewController ,UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    
  
    var imagename:String = "\(NSUUID().uuidString).jpeg"
    @IBOutlet weak var imagesnap: UIImageView!
    var metadata:StorageMetadata = StorageMetadata()
    var addedImage:Bool = false
    var imagePicker = UIImagePickerController()
    @IBOutlet weak var messagefield: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        
        
        
    }
    
    @IBAction func getimagefromfiles(_ sender: Any)
    {
        imagePicker.sourceType = .photoLibrary
        self.present(imagePicker, animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        {
            imagesnap.image = image
            addedImage = true
        }
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func nextbutton(_ sender: Any)
    {
        if addedImage && messagefield.text?.count != 0
        {
            //Upload image
            
            let imagesFolder = Storage.storage().reference().child("Images").child(imagename)
            
            if let image = imagesnap.image
            {
                let imageData = image.jpegData(compressionQuality: 0.1)
                
                    imagesFolder.putData(imageData!, metadata: nil) { (Metadata, error) in
                        
                        imagesFolder.downloadURL { (url, error) in
                            if let myurl = url
                            {
                                print("url \(myurl.absoluteString)")
                                self.performSegue(withIdentifier: "erickelnino", sender: myurl.absoluteString)
                            }
                        }
                }
                    
                }
        }else
        {
            alert(title: "Error", message: "Please select an image and add a message to proceed")
        }
    }
   
    @IBAction func cameraimages(_ sender: Any)
    {
        imagePicker.sourceType = .camera
        self.present(imagePicker, animated: true, completion: nil)
    }
    func alert(title:String , message:String)
    {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "ok", style: .default) { (erickaction) in
            
        }
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func send(_ sender: Any)
    {
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
           
           if segue.identifier == "erickelnino"
           {
               let secondVC = segue.destination as! receiversTableViewController
               if let downloadURl = sender as? String
               {
                if let message = messagefield?.text
                {
                    secondVC.downloadURl = downloadURl
                    secondVC.messageField = message
                    secondVC.ImageName = imagename
                }
               }
               
           }
       }

}
