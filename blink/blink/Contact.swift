//
//  Contact.swift
//  Contact
//
//  Created by Dharmesh Sonani on 09/04/19.
//  Copyright © 2019 Deedcoin Office. All rights reserved.
//

import UIKit
import Contacts

open class Contact {
    
    open var firstName: String
    open var lastName: String
    open var company: String
    open var thumbnailProfileImage: UIImage?
    open var profileImage: UIImage?
    open var birthday: Date?
    open var birthdayString: String?
    open var contactId: String?
    open var city: String = ""
    open var state: String = ""
    open var phoneNumbers = [(phoneNumber: String, phoneLabel: String)]()
    open var emails = [(email: String, emailLabel: String )]()
    open var rating : String = ""
	
    public init (contact: CNContact) {
        firstName = contact.givenName
        lastName = contact.familyName
        company = contact.organizationName
        contactId = contact.identifier
        
        if contact.postalAddresses.count > 0{
            
            if let addressString = (((contact.postalAddresses[0] as AnyObject).value(forKey: "labelValuePair") as AnyObject).value(forKey: "value")) as? CNPostalAddress {
                city = addressString.city
                state = addressString.state
            }
        }
      
        
        if let thumbnailImageData = contact.thumbnailImageData {
            
            thumbnailProfileImage = UIImage(data:thumbnailImageData)
        }
        
        if let imageData = contact.imageData {
            profileImage = UIImage(data:imageData)
        }
        
        if let birthdayDate = contact.birthday {
            
            birthday = Calendar(identifier: Calendar.Identifier.gregorian).date(from: birthdayDate)
            let dateFormatter = DateFormatter()
            let birdtdayDateFormat = "MMM d"
            dateFormatter.dateFormat = birdtdayDateFormat
            //Example Date Formats:  Oct 4, Sep 18, Mar 9
            birthdayString = dateFormatter.string(from: birthday!)
        }
        
		for phoneNumber in contact.phoneNumbers {
            		var phoneLabel = "phone"
            		if let label = phoneNumber.label {
            		    phoneLabel = label
            		}
			let phone = phoneNumber.value.stringValue
			
			phoneNumbers.append((phone,phoneLabel))
		}
        
        if UserDefaults.standard.object(forKey: "ImageContact") != nil
        {
            let dic = NSKeyedUnarchiver.unarchiveObject(with: UserDefaults.standard.object(forKey: "ImageContact") as! Data) as! NSMutableDictionary
            
            if dic.value(forKey: phoneNumbers[0].phoneNumber) != nil{
               
                self.profileImage = dic.value(forKey: phoneNumbers[0].phoneNumber) as? UIImage
            }
            else{
                
            }
        }
        else{
            
        }
        
        if UserDefaults.standard.object(forKey: "rateDetails") != nil
        {
            let dic = UserDefaults.standard.object(forKey: "rateDetails") as! NSMutableDictionary
            
            if dic.value(forKey: phoneNumbers[0].phoneNumber) != nil{
                self.rating = dic.value(forKey: phoneNumbers[0].phoneNumber) as! String
            }
            else{
                self.rating = "\(0.0)"
            }
        }
        else{
            self.rating = "\(0.0)"
        }
		
		for emailAddress in contact.emailAddresses {
			guard let emailLabel = emailAddress.label else { continue }
			let email = emailAddress.value as String
			
			emails.append((email,emailLabel))
		}
    }
	
    open func displayName() -> String {
        return firstName + " " + lastName
    }
    
    open func contactInitials() -> String {
        var initials = String()
		
		if let firstNameFirstChar = firstName.characters.first {
			initials.append(firstNameFirstChar)
		}
		
		if let lastNameFirstChar = lastName.characters.first {
			initials.append(lastNameFirstChar)
		}
		
        return initials
    }
    
}
