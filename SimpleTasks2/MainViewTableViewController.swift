//
//  MainViewTableViewController.swift
//  SimpleTasks2
//
//  Created by Tema Sysoev on 30/04/2019.
//  Copyright © 2019 Tema Sysoev. All rights reserved.
//

import UIKit
import UserNotifications
import CoreData


struct Public {
    static var tasks: [String] = []
    static var newTaskPublic = String()
    static var updated = false
    static var darkMode = false
}



class MainViewTableViewController: UITableViewController {
    
    
    
    @IBOutlet weak var toolBar: UIToolbar!
    @IBOutlet weak var navBar: UINavigationItem!
    @IBOutlet weak var addButtonItem: UIBarButtonItem!
    
    
    let center = UNUserNotificationCenter.current()
    
    
    
    
    
    let userDefults = UserDefaults.standard
    let darkModeColor = UIColor(red:0.12, green:0.13, blue:0.14, alpha:1.0)//UIColor(red:0.00, green:0.08, blue:0.14, alpha:1.0)
    func saveTasks(tasks:Array<Any>) {
        UserDefaults.standard.set(Public.tasks, forKey: "tasksKey")
        //print("Stored karma is ", Public.tasks)
    }
    func loadTasks() -> Array<Any>{
        if UserDefaults.standard.array(forKey:"tasksKey") != nil {
            return UserDefaults.standard.array(forKey:"tasksKey")!
        } else {return ["Hello"]}
        
    }
    
    
    
    @IBAction func showAddTask(_ sender: Any) {
        
        self.saveTasks(tasks: Public.tasks)
        //SPStorkController.updatePresentingController(modal: controller)
    }
        
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.hidesBackButton = true
        
        
        self.navigationController!.navigationBar.isTranslucent = false
        
         if UIScreen.main.brightness < CGFloat(0.3) {
            self.navigationController!.navigationBar.tintColor = darkModeColor
            self.navigationController?.navigationBar.barTintColor = darkModeColor
            self.navigationController?.navigationBar.tintColor = .white
            self.navigationController?.navigationBar.barStyle = .black
            self.tableView.backgroundColor = darkModeColor
            self.tableView.tintColor = darkModeColor
            tableView.separatorColor = darkModeColor
            addButtonItem.tintColor = .white
            toolBar.barTintColor = darkModeColor
        }
        toolBar.clipsToBounds = true
        
        
        Public.tasks = loadTasks() as! [String]
        if Public.tasks.isEmpty == true{
            let simple1 = "Swipe left to Done"
            let simple2 = "Swipe right to Prioritize task"
            let simple3 = "Tap + to add new tasks"
            Public.tasks.append(simple1)
            Public.tasks.append(simple2)
            Public.tasks.append(simple3)
            saveTasks(tasks: Public.tasks)
        }
        tableView.dataSource = self
        tableView.delegate = self
        
        
        center.requestAuthorization(options: [.alert, .badge, .sound]) { (granted, error) in
            if granted {
                print("Yay!")
            } else {
                print("D'oh")
            }
        }

        
        //navigationItem.rightBarButtonItem?.setTitlePositionAdjustment(.init(horizontal: 10, vertical: 20), for: UIBarMetrics.default)
        
    }
    

    // MARK: - Table view data source


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        return Public.tasks.count
        
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       // print("Num", Public.tasks.count)
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
        let task = Public.tasks[indexPath.row]
       
        cell.textLabel?.text = task
        if UIScreen.main.brightness < CGFloat(0.5) {
            cell.backgroundColor = darkModeColor
            cell.textLabel?.textColor = .white
        }
        //cell.layer.cornerRadius = 6
       // cell.layer.borderWidth = 3.0
        //cell.layer.borderColor = UIColor.white.cgColor
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        //print(task, indexPath.row)
        saveTasks(tasks: Public.tasks)
        return cell
    }
    

    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        
        return true
    }
    

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            //tableView.deleteRows(at: [indexPath], with: .fade)
            self.tableView.beginUpdates()
            Public.tasks.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
            self.tableView.endUpdates()
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
        
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let done = doneAction(at: indexPath)
        userDefults.set(Public.tasks, forKey: "TasksKey")
        userDefults.synchronize()
        return UISwipeActionsConfiguration(actions: [done])
    }
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let pushUp = pushUpAction(at: indexPath)
        return UISwipeActionsConfiguration(actions: [pushUp])
    }

    func pushUpAction(at indexPath: IndexPath) -> UIContextualAction {
        let action = UIContextualAction(style: .normal, title: "↑"){_,_,_ in
            
            let movingElement = Public.tasks.remove(at: indexPath.row)
            let index = IndexPath(row: 0, section: 0)
            Public.tasks.insert(movingElement, at: 0)
            Public.tasks[0] = "❕" + Public.tasks[0]
            self.tableView.reloadData()
            //self.tableView.cellForRow(at: index)?.backgroundColor = UIColor(red:0.76, green:0.76, blue:0.76, alpha:1.0)
            
            self.tableView.cellForRow(at: index)?.textLabel!.font = UIFont.boldSystemFont(ofSize: 18.0)
            
            self.saveTasks(tasks: Public.tasks)
        }
        action.backgroundColor = UIColor(red:0.50, green:0.50, blue:0.50, alpha:1.0)
        
        
        return action
    }
    func doneAction(at indexPath: IndexPath) -> UIContextualAction {
        let action = UIContextualAction(style: .normal, title: "✓"){_,_,_ in
           
            Public.tasks.remove(at: indexPath.row)
            //print(indexPath)
            self.tableView.reloadData()
            
            self.saveTasks(tasks: Public.tasks)
        }
        action.backgroundColor = UIColor(red:0.30, green:0.30, blue:0.30, alpha:1.0)
        return action
    }
    
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    

    
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let addVC = segue.destination as! AddTaskViewController
        addVC.mainVC = self
    }
    

}
