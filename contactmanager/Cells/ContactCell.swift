//
//  ContactCell.swift
//  contactmanager
//
//  Created by @karthi on 14/01/22.
//

import UIKit

class ContactCell: UITableViewCell {
    
    //MARK:- Properties
    @IBOutlet weak var parentView:UIView!
    
    @IBOutlet weak var profileImageView:UIImageView!
    
    @IBOutlet weak var nameLabel:UILabel!
    
    @IBOutlet weak var companyLabel:UILabel!
    
    private lazy var viewModel : HomeViewModel = {
        return HomeViewModel()
    }()

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.setUpCell()
    }
    
    //MARK:- Private Functions
    private func setUpCell() {
        
        self.parentView.layer.cornerRadius = 35
        
        self.profileImageView.layer.cornerRadius = 30
        
        self.profileImageView.layer.borderColor = UIColor.link.cgColor
        
        self.profileImageView.layer.borderWidth = 1
        
    }
    
    //Public Functions
    public func populateCell(_ contact:Contact) {
        
        self.nameLabel.text = contact.name
        
        self.companyLabel.text = contact.company
        
        self.profileImageView.image = UIImage(named: "default")
        
        if let imgData = contact.photo {
            
            self.profileImageView.image = UIImage(data: imgData)
            
        } else {
            if let string = contact.photoString,
               let url = URL(string: string),
               let name = contact.name{
                self.viewModel.downloadImage(url, name) { image in
                    self.profileImageView.image = image
                }
            }
        }
        
    }

    
    private func downloadImageFromUrl(url: URL) -> Data? {
        if let data = try? Data(contentsOf: url) {
            return data
        }else {
            return nil
        }
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    //MARK: - Create nib for cell
    class func getNib() -> UINib{
        let nib = UINib(nibName: "ContactCell", bundle: nil)
        return nib
    }
    
}
extension UITableViewCell {
    /// Returns an identifier for reuse the ui element tableview cell
    static var reuseIdentifier: String! {
        let className = String(describing: self)
        return className
    }
}
