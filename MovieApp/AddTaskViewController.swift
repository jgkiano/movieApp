//
//  AddTaskViewController.swift
//  MovieApp
//
//  Created by Julius Kiano on 3/15/17.
//  Copyright © 2017 Julius Kiano. All rights reserved.
//

import UIKit

class AddTaskViewController: UIViewController {

    @IBOutlet weak var textFeild: UITextField!
    
    @IBOutlet weak var isImp: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func btnPress(_ sender: Any) {
        
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        let task = Task(context: context)
        
        task.name = textFeild.text!
        task.isImportant = isImp.isOn
        
        //save data to coredata
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
    }
    

}
