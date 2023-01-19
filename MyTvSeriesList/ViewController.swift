//
//  ViewController.swift
//  MyTvSeriesList
//
//  Created by Burak Afyonlu on 19.01.2023.
//

import UIKit
import CoreData

class ViewController: UIViewController ,UITableViewDelegate , UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
    
        
        
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
    }


}

