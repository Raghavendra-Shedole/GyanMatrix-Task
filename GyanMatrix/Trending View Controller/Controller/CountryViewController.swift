//
//  CountryViewController.swift
//  GyanMatrix
//
//  Created by Raghavendra Shedole on 27/02/18.
//  Copyright © 2018 Raghavendra Shedole. All rights reserved.
//

import UIKit
import CoreData

class CountryViewController: UIViewController {

    let queue = DispatchQueue(label: "Timer", qos: .background, attributes: .concurrent)
    var timer: Timer?
    
    var countires = [Country]()
    var countiresViewController:CountryListViewController?
//    var timer:Timer!
    
    @IBOutlet weak var trendingListTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchData()
        removeCountry()
        
    }
    
    
    func removeCountry() {
        for country in countires {
            if !compareDates(country: country) {
                trendingListTableView.reloadData()
                break
            }
        }
        setTimer()
    }
        
    /// Setting timer
    func setTimer() {
        
        if countires.count == 0  {
            queue.sync { [unowned self] in
                guard let _ = self.timer else {
                    // error, timer already stopped
                    return
                }
                self.timer?.invalidate()
                self.timer = nil
            }
        }else {
            queue.async { [unowned self] in
                if let _ = self.timer {
                    self.timer?.invalidate()
                    self.timer = nil
                }
                let currentRunLoop = RunLoop.current
                self.timer = Timer(timeInterval: 1.0, target: self, selector:#selector(self.deleteCountry(timer:)) , userInfo: self.countires.first!, repeats: true)
                currentRunLoop.add(self.timer!, forMode: .commonModes)
                currentRunLoop.run()
            }
        }
    }
    
    

    /// Presenting country list
    ///
    /// - Parameter sender: right navigation bar button
    @IBAction func addcountry(_ sender: UIBarButtonItem) {
        if countiresViewController == nil {
            countiresViewController = self.storyboard?.instantiateViewController(withIdentifier: String(describing:CountryListViewController.self)) as?  CountryListViewController
            countiresViewController?.view.frame = self.view.bounds
            countiresViewController?.delegate = self
        }
        self.present(countiresViewController!, animated: true, completion: nil)
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}


// MARK: - UITableVIewDelegate, UITableViewDataSource and add/delete cell methods
extension CountryViewController:UITableViewDataSource,UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countires.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing:CountryTableViewCell.self)) as!CountryTableViewCell
        
        cell.countryFlag.setImage(url: countires[indexPath.row].flagUrl!)
        cell.countryName.text = countires[indexPath.row].name
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    
    func addCell() {
        setTimer()

        if trendingListTableView.numberOfRows(inSection: 0) == 0 {
            trendingListTableView.reloadData()
        }else {
            trendingListTableView.beginUpdates()
            trendingListTableView.insertRows(at: [IndexPath(row: countires.count - 1, section: 0)], with: .none)
            trendingListTableView.endUpdates()
        }
        let indexPath = IndexPath(row: self.trendingListTableView.numberOfRows(inSection: 0) - 1, section: 0)
        self.trendingListTableView.scrollToRow(at: indexPath, at: .bottom, animated: false)
    }
    
    func deleteCell(atIndex index:Int) {
        setTimer()
        
        if self.trendingListTableView.numberOfRows(inSection: 0) > 0 {
            trendingListTableView.beginUpdates()
            trendingListTableView.deleteRows(at: [IndexPath(row: index, section: 0)], with: .none)
            trendingListTableView.endUpdates()
        }
    }
}

//add and delete country in/from core data and
extension CountryViewController:CountryListViewControllerDelegate {
    func selectedcountry(name: String, profilePicUrl: String) {

        addcountry(name: name, addedDate: Date(), imageUrl: profilePicUrl)
        self.addCell()
    }
    
   @objc func deleteCountry(timer:Timer) {
        if let country = timer.userInfo as? Country {
            if compareDates(country: country) {
                DispatchQueue.main.sync {
                    self.deleteCell(atIndex: 0)
                }
            }
        }
    }
    
    /// Compare Dates
    ///
    /// - Parameter country: Country details
    /// - Returns: true when the country added 200 seconds back
    func compareDates(country:Country) -> Bool {
        
        if Date().compare((country.date)! as Date) == .orderedDescending {
            if Calendar.current.dateComponents([.second], from: Date(), to: (country.date)! as Date).second! <= -200 {
                self.deleteData(atIndex: 0)
                return true
            }else {
                return false
            }
        }
        return false
    }
}




// MARK: - Core Data
extension CountryViewController {
    
    func fetchData() {
        let fetchRequest:NSFetchRequest<Country> = Country.fetchRequest()
        do {
            let countires = try PersistentStore.context.fetch(fetchRequest)
            self.countires = countires
        } catch  {
            print(error.localizedDescription)
        }
    }
    
    /// Delete data at a index in core data
    ///
    /// - Parameter index: row index to be deleted
    func deleteData(atIndex index:Int) {
        //Fetch request
        PersistentStore.context.delete(countires[index])
        PersistentStore.saveContext()
        
        self.countires.remove(at: index)
    }
    
    func addcountry(name:String,addedDate:Date,imageUrl:String) {
        let  country = Country(context:PersistentStore.context)
        country.name = name
        country.date = addedDate as NSDate
        country.flagUrl = imageUrl
        PersistentStore.saveContext()
        
        self.countires.append(country)
    }
    
}
