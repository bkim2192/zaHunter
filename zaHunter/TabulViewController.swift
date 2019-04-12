//
//  TabulViewController.swift
//  zaHunter
//
//  Created by Brandon Kim on 4/8/19.
//  Copyright © 2019 Brandon Kim. All rights reserved.
//

import UIKit

class TabulViewController: UIViewController {
    var currentView = TabulViewController.self
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var label: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func action(_ sender: Any) {
        let defaults = UserDefaults.standard
        
        if let name = defaults.string(forKey: "name") {
            label.text = "\(name)"
        }
        
        
        
        
        if let name = defaults.string(forKey: "name"), let number = defaults.string(forKey: "number") {
            label.text = "\(name) /n \(number)"
        }
        
        
        
    }
    
    
    
    
    
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
