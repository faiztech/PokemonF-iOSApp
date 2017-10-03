//
//  PokeDexViewController.swift
//  Pokemon F
//
//  Created by Mohammed Faizuddin on 10/3/17.
//  Copyright © 2017 Faiz Tech. All rights reserved.
//

import UIKit

class PokeDexViewController: UIViewController {

   @IBOutlet weak var tableView: UITableView!
   override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

   @IBAction func mapTapped(_ sender: Any) {
      
      dismiss(animated: true, completion: nil)
   }
}
