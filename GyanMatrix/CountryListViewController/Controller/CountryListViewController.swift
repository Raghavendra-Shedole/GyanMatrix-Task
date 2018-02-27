//
//  countriesListViewController.swift
//  GyanMatrix
//
//  Created by Raghavendra Shedole on 27/02/18.
//  Copyright © 2018 Raghavendra Shedole. All rights reserved.
//

import UIKit

protocol CountryListViewControllerDelegate {
    func selectedcountry(name:String, profilePicUrl:String)
}

class CountryListViewController: UIViewController {

   
    
    @IBOutlet weak var countriesListTableView: UITableView!
    var arrayOfcountries = [[String:String]]()
    var delegate:CountryListViewControllerDelegate?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setData()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.countriesListTableView.reloadData()
    }
    func setData() {
        if let path = Bundle.main.path(forResource: "Countries", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
                if let jsonResult = jsonResult as? [[String:String]] {
                    // do stuff
                    arrayOfcountries = jsonResult
                    print(jsonResult)
                }
            } catch {
                print("error : %@",  error.localizedDescription)
                // handle error
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension CountryListViewController:UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        dismiss(animated: true, completion: nil)
        if let delegate = delegate {
            delegate.selectedcountry(name: arrayOfcountries[indexPath.row]["country"]!, profilePicUrl: arrayOfcountries[indexPath.row]["flag"]!)
        }
    }
    
}

extension CountryListViewController:UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayOfcountries.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing:CountryListTableViewCell.self)) as! CountryListTableViewCell
        cell.countryName.text =  arrayOfcountries[indexPath.row]["country"]
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing:CountryListTableViewCell.self)) as! CountryListTableViewCell
        
        cell.countryName.text =  "Countries"
        cell.countryName.textColor = UIColor.white
        cell.contentView.backgroundColor = UIColor(displayP3Red: 1.0, green: 0.0, blue: 0.0, alpha: 1.0)
        return cell.contentView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45
    }
}



