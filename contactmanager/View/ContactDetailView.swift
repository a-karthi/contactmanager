//
//  ContactDetailView.swift
//  contactmanager
//
//  Created by @karthi on 14/01/22.
//

import UIKit

class ContactDetailView: UIView {

    //MARK:- Properties
    @IBOutlet weak var  profileImage: UIImageView!
    
    @IBOutlet weak var  nameLabel: UILabel!
    
    @IBOutlet weak var  companyLabel: UILabel!
    
    @IBOutlet weak var  callButton: UIButton!
    
    @IBOutlet weak var  mailButton: UIButton!
    
    @IBOutlet weak var  deleteButton: UIButton!
    
    @IBOutlet weak var  editButton: UIButton!
    
    @IBOutlet weak var  phoneLabel: UILabel!
    
    @IBOutlet weak var  emailLabel: UILabel!
    
    @IBOutlet weak var  addressLabel: UILabel!
    
    private var picker = UIImagePickerController()
    
    private lazy var viewController:ContactDetailViewController = {
        return ContactDetailViewController()
    }()
    
    //MARK:- Life Cycle
    public func viewDidLoad(_ forController:ContactDetailViewController) {
        
        self.viewController = forController
        
        self.setUpViews()
        
    }
    
    //MARK:- Private functions
    private func setUpViews() {
        
        profileImage.isUserInteractionEnabled = true
        
        editButton.layer.cornerRadius = 10
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(showAlert))
        
        self.profileImage.addGestureRecognizer(tap)
        
        self.picker.delegate = self
        
        self.profileImage.layer.cornerRadius = 55
        
        self.profileImage.layer.borderWidth = 1
        
        self.profileImage.layer.borderColor = UIColor.link.cgColor
        
        self.nameLabel.text = self.viewController.contactDetail.name
        
        self.companyLabel.text = self.viewController.contactDetail.company
        
        if let data = self.viewController.contactDetail.photo {
            
            self.profileImage.image = UIImage(data: data)
            
        }
        
        self.emailLabel.text = self.viewController.contactDetail.email
        
        self.phoneLabel.text = self.viewController.contactDetail.phone
        
        self.addressLabel.text = getForMattedAddress()
    }
    
    private func getForMattedAddress() -> String {
        
        var str = ""
        if let address = self.viewController.contactDetail.address,
           let country = self.viewController.contactDetail.country,
           let zip = self.viewController.contactDetail.zip {
            str = address + " , " + country + " - " + zip
        }
        return str
        
    }
    
    //MARK:- UI Interactions
    @IBAction func callAction(_ sender:UIButton) {
        let strNumber = self.viewController.contactDetail.phone?.removeHypens().removeParanthesis()
        if let number = strNumber?.removeWhitespace(),
            let phoneCallURL = URL(string: "tel://\(number)") {
            print(number)
            let application:UIApplication = UIApplication.shared
            if (application.canOpenURL(phoneCallURL)) {
                application.open(phoneCallURL, options: [:], completionHandler: nil)
            }
        }
        
    }
    
    @IBAction func editAction(_ sender:Any) {
        
        self.showAlert()
        
    }
    
    
    @IBAction func mailAction(_ sender:UIButton) {
        
        if let email = self.viewController.contactDetail.email,
           let url = URL(string: "mailto:\(email)") {
          if #available(iOS 10.0, *) {
            UIApplication.shared.open(url)
          } else {
            UIApplication.shared.openURL(url)
          }
        }
        
    }
    
    @IBAction func deleteAction(_ sender:UIButton) {
        
        let alert = UIAlertController(title: "Delete Contact", message: "Are you sure you want to delete this contact?", preferredStyle: .alert)

        let deleteAction = UIAlertAction(title: "Delete", style: .destructive, handler: { (action) in
            self.viewController.deleteContact()
        })
        alert.addAction(deleteAction)

        let cancelAction = UIAlertAction(title: "Cancel", style: .default)
        alert.addAction(cancelAction)

        self.viewController.present(alert, animated: true, completion: nil)
        
    }
}

//MARK:- Image picker controller delegate

extension ContactDetailView: UINavigationControllerDelegate,UIImagePickerControllerDelegate {
    
    @objc func showAlert() {
            let alert = UIAlertController(title: "Choose Image", message: nil, preferredStyle: .actionSheet)
            alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { _ in
                self.openCamera()
            }))
            
            alert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { _ in
                self.openGallery()
            }))
            
            alert.addAction(UIAlertAction.init(title: "Cancel", style: .destructive, handler: nil))
            self.viewController.present(alert, animated: true, completion: nil)
    }
    
    func openCamera() {
        
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerController.SourceType.camera)) {
            picker.sourceType = UIImagePickerController.SourceType.camera
            picker.allowsEditing = true
            self.viewController.present(picker, animated: true, completion: nil)
        } else {
            let alert  = UIAlertController(title: "Warning", message: "You don't have camera", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.viewController.present(alert, animated: true, completion: nil)
        }
        
    }
    
    func openGallery() {
        
        picker.sourceType = UIImagePickerController.SourceType.photoLibrary
        picker.allowsEditing = true
        self.viewController.present(picker, animated: true, completion: nil)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[.originalImage] as? UIImage,
           let name = self.viewController.contactDetail.name,
           let localContact = Contact.fetchParticularContact(for: name) {
            self.profileImage.image = pickedImage
            let data = pickedImage.pngData()
            localContact.photo = data
            CoreDataHandler.shared.saveContext()
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
}




extension String {
    func replace(string:String, replacement:String) -> String {
            return self.replacingOccurrences(of: string, with: replacement)
    }

    func removeWhitespace() -> String {
        return self.replace(string: " ", replacement: "")
    }
    
    func removeHypens() -> String {
        return self.replace(string: "-", replacement: "")
    }
    
    func removeParanthesis() -> String {
        return self.replacingOccurrences(of: "(", with: "").replacingOccurrences(of: ")", with: "")
    }
}
