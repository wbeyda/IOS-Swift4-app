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
    var contactsStore: CNContactStore?
    var arrContactsLess30Days = [Contact]()
    var arrContactsMore30Days = [Contact]()
    var arrContactsLess30DaysByDate = [Contact]()
    var arrContactsMore30DaysByDate = [Contact]()
    var arrFinalContact : [Contact] = []
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.isSortByRate = true
        self.lblSort.text = "By Rank"
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.setupContact), name: NSNotification.Name(rawValue: "reloadContact"), object: nil)
        
        if appDelegate.arrContacts.count == 0{
            
            appDelegate.getContacts( {(contacts, error) in
                if (error == nil) {
                    DispatchQueue.main.async(execute: {
                        
                        self.appDelegate.arrContacts = contacts
                        self.setupContact()
                    })
                }
            })
        }
        else{
            self.setupContact()
        }
        
    }
    
    
    
    @objc func setupContact()
    {
        self.arrFinalContact = []
        
        for index in 0..<appDelegate.arrContacts.count{
            
            let contact = Contact.init(contact: appDelegate.arrContacts[index])
            self.arrFinalContact.append(contact)
        }
        
        self.arrContactsLess30Days =  Array(self.arrFinalContact.prefix(4))
        self.arrContactsLess30DaysByDate = Array(self.arrFinalContact.prefix(4))
        
        self.arrContactsLess30Days.sort { (a, b) -> Bool in
            
            return a.rating.localizedCaseInsensitiveCompare(b.rating) == .orderedDescending
            
        }
        
        self.arrContactsMore30Days =  Array(self.arrFinalContact[4..<self.arrFinalContact.count])
        self.arrContactsMore30DaysByDate = Array(self.arrFinalContact[4..<self.arrFinalContact.count])
        
        self.arrContactsMore30Days.sort { (a, b) -> Bool in
            
            return a.rating.localizedCaseInsensitiveCompare(b.rating) == .orderedDescending
            
        }
        
        self.tableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.navigationController?.navigationBar.isHidden = true
        self.tableView.reloadData()
    }
    
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        if section == 0{
            
            return self.arrContactsLess30Days.count
            
        }
        else{
            return self.arrContactsMore30Days.count
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if self.isSortByRate{
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "RateCell", for: indexPath) as! RateCell
            
            let btnDetail = cell.contentView.viewWithTag(1005) as! UIButton
            
            let contact : Contact!
            
            if indexPath.section == 0{
                
                contact = self.arrContactsLess30Days[indexPath.row]
                
                cell.lblName.text = "\(contact.firstName) \(contact.lastName)"
                cell.lblCity.text = "\(contact.state) \(contact.city)"
            }
            else{
                contact = self.arrContactsMore30Days[indexPath.row]
                
                cell.lblName.text = "\(contact.firstName) \(contact.lastName)"
                cell.lblCity.text = "\(contact.state) \(contact.city)"
            }
            
            cell.rateView.value = CGFloat((contact.rating as! NSString).floatValue)
            cell.selectionStyle = .none
            
             btnDetail.addTarget(self, action: #selector(self.clickOnDetail(sender:)), for: UIControl.Event.touchUpInside)
           
            return cell
        }
        else{
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "DateCell", for: indexPath) as! ABMenuTableViewCell
            
            let contact : Contact!
            
            let lblName = cell.contentView.viewWithTag(1001) as! UILabel
            let lblCity = cell.contentView.viewWithTag(1002) as! UILabel
            let btnDetail = cell.contentView.viewWithTag(1005) as! UIButton

            if indexPath.section == 0{
                
                contact = self.arrContactsLess30DaysByDate[indexPath.row]
                
                lblName.text = "\(contact.firstName) \(contact.lastName)"
                lblCity.text = "\(contact.state) \(contact.city)"
            }
            else{
                contact = self.arrContactsMore30DaysByDate[indexPath.row]
                
                lblName.text = "\(contact.firstName) \(contact.lastName)"
                lblCity.text = "\(contact.state) \(contact.city)"
            }
            
            let menuView = ABCellMenuView.initWithNib("ABCellMailStyleMenuView", bundle: nil)
            menuView?.delegate  = self
            menuView?.indexPath = indexPath
            menuView!.rateView.value = CGFloat((contact.rating as! NSString).floatValue)
            cell.rightMenuView = menuView
            
            btnDetail.addTarget(self, action: #selector(self.clickOnDetail(sender:)), for: .touchUpInside)
            
            cell.selectionStyle = .none
            
            return cell
        }
        
    }
    
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView = Bundle.main.loadNibNamed("HeaderView", owner: self, options: [:])?.last as! HeaderView
        
        if section == 0{
            
            headerView.lblName.text = "Last 30 days"
        }
        else{
            headerView.lblName.text = "More than 30 days"
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
    
   
    func cellMenuViewMoreBtnTapped(_ menuView: ABCellMenuView!) {
        
        let contact : Contact!
        
        if menuView.indexPath.section == 0{
            
            contact = self.arrContactsLess30DaysByDate[menuView.indexPath.row]
        }
        else{
            contact = self.arrContactsMore30DaysByDate[menuView.indexPath.row]
        }
        
        contact.rating = "\(menuView.rateView.value)"
        let strPhone = contact.phoneNumbers[0].phoneNumber
        
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
    
    @objc func clickOnDetail(sender:UIButton)
    {
        var cell = self.isSortByRate ? sender.superview?.superview as! RateCell : sender.superview?.superview as! ABMenuTableViewCell
        
        let indexPath = self.tableView.indexPath(for: cell)
        
        let contactVC = self.storyboard?.instantiateViewController(withIdentifier: "ContactsViewController") as! ContactsViewController
        contactVC.hidesBottomBarWhenPushed  = true
        
        if self.isSortByRate{
            
            if indexPath!.section == 0{
                contactVC.contact = self.arrContactsLess30Days[indexPath!.row]
            }
            else{
                contactVC.contact = self.arrContactsMore30Days[indexPath!.row]
            }
        }
        else{
            if indexPath!.section == 0{
                contactVC.contact = self.arrContactsLess30DaysByDate[indexPath!.row]
            }
            else{
                contactVC.contact = self.arrContactsMore30DaysByDate[indexPath!.row]
            }
        }
        
        self.navigationController?.pushViewController(contactVC, animated: true)
    }
    
    @IBAction func clickOnSort(sender:UIButton)
    {
        if self.isSortByRate{
            
            self.isSortByRate = false
            self.lblSort.text = "By Date"
        }
        else{
            self.isSortByRate = true
            self.lblSort.text = "By Rank"
        }
        
        self.setupContact()
    }
}
