//
//  HistoryViewController.swift
//  blink
//
//  Created by Dharmesh Sonani on 09/04/19.
//  Copyright © 2019 Deedcoin Office. All rights reserved.
//

import UIKit
import Contacts


class HistoryViewController: UITableViewController,ABCellMenuViewDelegate {
    
    @IBOutlet var lblSort : UILabel!
    
    var isSortByRate : Bool = false
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    let addressBook = APAddressBook()
    var contacts = [APContact]()
    var dicContact = NSMutableDictionary()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.isSortByRate = false
        self.lblSort.text = "By Date"
        
        self.loadContacts(showProgress: true)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.refreshContact), name: NSNotification.Name(rawValue: "reloadContact"), object: nil)
    }
    
    @objc func refreshContact()
    {
        self.loadContacts(showProgress: false)
    }
    
    // MARK: - life cycle
    
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder);
        addressBook.fieldsMask = .all
        addressBook.sortDescriptors = [NSSortDescriptor(key: "recordDate.creationDate", ascending: false)]
        addressBook.filterBlock =
            {
                (contact: APContact) -> Bool in
                if let phones = contact.phones
                {
                    return phones.count > 0
                }
                return false
        }
        addressBook.startObserveChanges
            {
                [unowned self] in
                self.loadContacts(showProgress: true)
        }
    }
    
    
    // MARK: - private
    
    func loadContacts(showProgress:Bool)
    {
        SVProgressHUD.show()
        addressBook.loadContacts
            {
                [unowned self] (contacts: [APContact]?, error: Error?) in
                
                SVProgressHUD.dismiss()
                self.contacts = [APContact]()
                if let contacts = contacts
                {
                    self.contacts = contacts
                    
                    let sort24hours = SortDate.sortContactLast24hours(self.contacts)
                    let sortLastWeek = SortDate.sortContactLastWeek(self.contacts)
                    let sortContacts = SortDate.sortContact(self.contacts)
                    
                    self.dicContact.setObject(sort24hours, forKey: NSNumber.init(value: 0))
                    self.dicContact.setObject(sortLastWeek, forKey: NSNumber.init(value: 1))
                    self.dicContact.setObject(sortContacts, forKey: NSNumber.init(value: 2))
                    
                    self.tableView.reloadData()
                }
                else if let error = error
                {
                    
                }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.navigationController?.navigationBar.isHidden = true
        self.tableView.reloadData()
    }
    
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return self.dicContact.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        return (self.dicContact.object(forKey: NSNumber.init(value: section)) as! NSArray).count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if self.isSortByRate{
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "RateCell", for: indexPath) as! RateCell
            
            let lblName = cell.contentView.viewWithTag(1001) as! UILabel
            let lblCity = cell.contentView.viewWithTag(1002) as! UILabel
            let rateView = cell.contentView.viewWithTag(1003) as! HCSStarRatingView
            let btnDetail = cell.contentView.viewWithTag(1004) as! UIButton
            
            let contact : APContact!
            
            let arrContacts = self.dicContact.object(forKey: NSNumber.init(value: indexPath.section)) as! [APContact]
            
            contact = arrContacts[indexPath.row]
            
            lblName.text = contactName(contact)
            lblCity.text = contactAddress(contact)
            rateView.value = CGFloat((contact.rating! as NSString).floatValue)
            
            cell.selectionStyle = .none
            
            btnDetail.addTarget(self, action: #selector(self.clickOnDetail(sender:)), for: UIControl.Event.touchUpInside)
            
            rateView.addTarget(self, action: #selector(self.rateChange(rateView:)), for: UIControl.Event.valueChanged)
            
            return cell
        }
        else{
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "DateCell", for: indexPath) as! ABMenuTableViewCell
            
            let contact : APContact!
            
            let lblName = cell.contentView.viewWithTag(1001) as! UILabel
            let lblCity = cell.contentView.viewWithTag(1002) as! UILabel
            let lblTime = cell.contentView.viewWithTag(1003) as! UILabel
            let lblDate = cell.contentView.viewWithTag(1004) as! UILabel
            let btnDetail = cell.contentView.viewWithTag(1005) as! UIButton
            
            let arrContacts = self.dicContact.object(forKey: NSNumber.init(value: indexPath.section)) as! [APContact]
            
            contact = arrContacts[indexPath.row]
            
            lblName.text = contactName(contact)
            lblCity.text = contactAddress(contact)
            
            let strDate = contactDates(contact)
            let arrDate = strDate.components(separatedBy: " ")
            
            lblDate.text = arrDate[0]
            lblTime.text = arrDate[1]
            
            let menuView = ABCellMenuView.initWithNib("ABCellMailStyleMenuView", bundle: nil)
            menuView?.delegate  = self
            menuView?.indexPath = indexPath
            menuView!.rateView.value = CGFloat((contact.rating! as NSString).floatValue)
            cell.rightMenuView = menuView
            
            btnDetail.addTarget(self, action: #selector(self.clickOnDetail(sender:)), for: UIControl.Event.touchUpInside)
            
            cell.selectionStyle = .none
            
            return cell
        }
        
    }
    
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView = Bundle.main.loadNibNamed("HeaderView", owner: self, options: [:])?.last as! HeaderView
        
        if section == 0{
            
            headerView.lblName.text = "Last 24hrs"
        }
        else if section == 1{
            headerView.lblName.text = "Last Week"
        }
        else{
            headerView.lblName.text = "More Than 30 Days"
        }
        
        return headerView
        
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 25
    }
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 55
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        
        return CGFloat.leastNormalMagnitude
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        
        if !self.isSortByRate{
            return true
        }
        else{
            return false
        }
        
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        // Remove seperator inset
        if cell.responds(to: #selector(setter: UITableViewCell.separatorInset)) {
            cell.separatorInset = .zero
        }
        // Prevent the cell from inheriting the Table View's margin settings
        if cell.responds(to: #selector(setter: UITableViewCell.preservesSuperviewLayoutMargins)) {
            cell.preservesSuperviewLayoutMargins = false
        }
        // Explictly set your cell's layout margins
        if cell.responds(to: #selector(setter: UITableViewCell.layoutMargins)) {
            cell.layoutMargins = .zero
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if self.isSortByRate{
            
            let cell = self.tableView.cellForRow(at: indexPath)
            let rateView = cell!.contentView.viewWithTag(1003) as! HCSStarRatingView
            
            rateView.backgroundColor = UIColor.clear
            
            for index in 0..<self.dicContact.count
            {
                var arrContacts = self.dicContact.object(forKey: NSNumber.init(value: index)) as! [APContact]
                
                arrContacts.sort { (a, b) -> Bool in
                    
                    return a.rating!.localizedCaseInsensitiveCompare(b.rating!) == .orderedDescending
                }
                
                dicContact.setObject(arrContacts, forKey: NSNumber.init(value: index))
            }
            
            self.tableView.reloadData()
        }
    }
    
    func cellMenuViewMoreBtnTapped(_ menuView: ABCellMenuView!) {
        
        let contact : APContact!
        
        let arrContacts = self.dicContact.object(forKey: NSNumber.init(value: menuView.indexPath.section)) as! [APContact]
        
        contact = arrContacts[menuView.indexPath.row]
        
        contact.rating = "\(menuView.rateView.value)"
        let strPhone = self.contactPhones(contact)
        
        if UserDefaults.standard.object(forKey: "rateDetails") != nil
        {
            let dic = UserDefaults.standard.object(forKey: "rateDetails") as! NSMutableDictionary
            
            if dic.value(forKey: strPhone) != nil{
                
                let newDic = NSMutableDictionary.init(dictionary: UserDefaults.standard.object(forKey: "rateDetails") as! [AnyHashable:Any])
                newDic.setValue("\(menuView.rateView.value)", forKey: strPhone)
                
                UserDefaults.standard.setValue(newDic, forKey: "rateDetails")
                UserDefaults.standard.synchronize()
            }
            else{
                let dic = NSMutableDictionary.init(dictionary: UserDefaults.standard.object(forKey: "rateDetails") as! [AnyHashable:Any])
                dic.setValue("\(menuView.rateView.value)", forKey: strPhone)
                UserDefaults.standard.setValue(dic, forKey: "rateDetails")
                UserDefaults.standard.synchronize()
            }
            
        }
        else{
            
            let dic = NSMutableDictionary()
            dic.setValue("\(menuView.rateView.value)", forKey: strPhone)
            UserDefaults.standard.setValue(dic, forKey: "rateDetails")
            UserDefaults.standard.synchronize()
            
        }
        
    }
    
    @objc func rateChange(rateView:HCSStarRatingView)
    {
        rateView.backgroundColor = UIColor.init(red: 68.0/255.0, green: 91.0/255.0, blue: 167.0/255.0, alpha: 1.0)
        
        let cell = rateView.superview?.superview as! UITableViewCell
        let indexPath = self.tableView.indexPath(for: cell)
        
        var contact : APContact!
        
        let arrContacts = self.dicContact.object(forKey: NSNumber.init(value: (indexPath?.section)!)) as! [APContact]
        
        contact = arrContacts[(indexPath?.row)!]
        
        contact.rating = "\(rateView.value)"
        let strPhone = self.contactPhones(contact)
        
        if UserDefaults.standard.object(forKey: "rateDetails") != nil
        {
            let dic = UserDefaults.standard.object(forKey: "rateDetails") as! NSMutableDictionary
            
            if dic.value(forKey: strPhone) != nil{
                
                let newDic = NSMutableDictionary.init(dictionary: UserDefaults.standard.object(forKey: "rateDetails") as! [AnyHashable:Any])
                newDic.setValue("\(rateView.value)", forKey: strPhone)
                
                UserDefaults.standard.setValue(newDic, forKey: "rateDetails")
                UserDefaults.standard.synchronize()
            }
            else{
                let dic = NSMutableDictionary.init(dictionary: UserDefaults.standard.object(forKey: "rateDetails") as! [AnyHashable:Any])
                dic.setValue("\(rateView.value)", forKey: strPhone)
                UserDefaults.standard.setValue(dic, forKey: "rateDetails")
                UserDefaults.standard.synchronize()
            }
            
        }
        else{
            
            let dic = NSMutableDictionary()
            dic.setValue("\(rateView.value)", forKey: strPhone)
            UserDefaults.standard.setValue(dic, forKey: "rateDetails")
            UserDefaults.standard.synchronize()
            
        }
    }
    
    @objc func clickOnDetail(sender:UIButton)
    {
        var cell = self.isSortByRate ? sender.superview?.superview as! RateCell : sender.superview?.superview as! ABMenuTableViewCell
        
        let indexPath = self.tableView.indexPath(for: cell)
        
        let contactVC = self.storyboard?.instantiateViewController(withIdentifier: "ContactsViewController") as! ContactsViewController
        contactVC.hidesBottomBarWhenPushed  = true
        
        let arrContacts = self.dicContact.object(forKey: NSNumber.init(value: indexPath!.section)) as! [APContact]
        
        let contact = arrContacts[indexPath!.row]
        contactVC.contact = contact
        
        self.navigationController?.pushViewController(contactVC, animated: true)
    }
    
    @IBAction func clickOnSort(sender:UIButton)
    {
        if self.isSortByRate{
            
            self.isSortByRate = false
            self.lblSort.text = "By Date"
            
            let sort24hours = SortDate.sortContactLast24hours(self.contacts)
            let sortLastWeek = SortDate.sortContactLastWeek(self.contacts)
            let sortContacts = SortDate.sortContact(self.contacts)
            
            self.dicContact.setObject(sort24hours, forKey: NSNumber.init(value: 0))
            self.dicContact.setObject(sortLastWeek, forKey: NSNumber.init(value: 1))
            self.dicContact.setObject(sortContacts, forKey: NSNumber.init(value: 2))
            
        }
        else{
            
            self.isSortByRate = true
            self.lblSort.text = "By Rank"
            
            for index in 0..<self.dicContact.count
            {
                var arrContacts = self.dicContact.object(forKey: NSNumber.init(value: index)) as! [APContact]
                
                arrContacts.sort { (a, b) -> Bool in
                    
                    return a.rating!.localizedCaseInsensitiveCompare(b.rating!) == .orderedDescending
                }
                
                dicContact.setObject(arrContacts, forKey: NSNumber.init(value: index))
            }
            
        }
        self.tableView.reloadData()
        
        
    }
    
    // MARK: - prviate
    
    func contactName(_ contact :APContact) -> String {
        if let firstName = contact.name?.firstName, let lastName = contact.name?.lastName {
            return "\(firstName) \(lastName)"
        }
        else if let firstName = contact.name?.firstName {
            return "\(firstName)"
        }
        else if let lastName = contact.name?.lastName {
            return "\(lastName)"
        }
        else {
            return "Unnamed contact"
        }
    }
    
    func contactPhones(_ contact :APContact) -> String {
        if let phones = contact.phones {
            var phonesString = ""
            phonesString = phones[0].number!
            //            for phone in phones {
            //                if let number = phone.number {
            //                    phonesString = phonesString + " " + number
            //                }
            //            }
            return phonesString
        }
        return "No phone"
    }
    
    func contactDates(_ contact :APContact) -> String {
        
        let date = contact.recordDate?.creationDate
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy hh:mma"
        
        let strDate = dateFormatter.string(from: date!)
        
        print(strDate)
        
        return strDate
    }
    
    func contactAddress(_ contact :APContact) -> String
    {
        if let addresses = contact.addresses {
            var city = ""
            for address in addresses {
                if let strState = address.state {
                    city = strState
                }
                if let strCity = address.city {
                    city = city + " " + strCity
                }
            }
            return city
        }
        return "No Address"
    }
}
