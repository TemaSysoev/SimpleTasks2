//
//  AddTaskViewController.swift
//  SimpleTasks2
//
//  Created by Tema Sysoev on 30/04/2019.
//  Copyright © 2019 Tema Sysoev. All rights reserved.
//

import UIKit

import CoreData

class AddTaskViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var addButton: UIButton!
    
    var mainVC = MainViewTableViewController()
    
    func saveDarkMode(tasks:Bool) {
        UserDefaults.standard.set(Public.tasks, forKey: "darkModeCode")
        print("Dark Mode:", Public.darkMode)
    }
    func loadDarkMode() -> Bool{
        return UserDefaults.standard.bool(forKey:"darkModeCode")
    }
    
    @IBOutlet weak var nameTextField: UITextField!
    
    
   
    let darkModeColor = UIColor(red:0.12, green:0.13, blue:0.14, alpha:1.0)
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        if UIScreen.main.brightness < CGFloat(0.3) {
            view.backgroundColor = darkModeColor
            addButton.tintColor = .white
            nameTextField.textColor = .white
            nameTextField.keyboardAppearance = UIKeyboardAppearance.dark
            
        }
        self.nameTextField.delegate = self
        nameTextField.becomeFirstResponder()
        addButton.layer.cornerRadius = 6
       
       
        // Do any additional setup after loading the view.
        
       
        
        
        
    }
    
    @IBAction func returnButtonTapped(_ sender: Any) {
        addTaskAction()
    }
    
    
   @IBAction func addAction(_ sender: Any) {
        addTaskAction()
    
    }
    
    func addTaskAction() {
        if nameTextField.text != nil {
            //newTaskPublic.name = nameTextField.text!
            Public.newTaskPublic = nameTextField.text!
            Public.updated = true
        } else {
            
        }
        if nameTextField.text == ""{
            Public.newTaskPublic = "New tasks"
        }
        
        Public.tasks.append(Public.newTaskPublic)
        mainVC.tableView.reloadData()
        
        
        //mainVC.defaults.set(mainVC.tasks, forKey: "TasksSaved")
        
        
        
        
        dismissAction()
    }
    
    @objc func dismissAction() {
        self.dismiss(animated: true)
       
       

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
