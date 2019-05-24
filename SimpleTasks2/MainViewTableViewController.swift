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
import CloudKit

extension CKError {
    public func isRecordNotFound() -> Bool {
        return isZoneNotFound() || isUnknownItem()
    }
    public func isZoneNotFound() -> Bool {
        return isSpecificErrorCode(code: .zoneNotFound)
    }
    public func isUnknownItem() -> Bool {
        return isSpecificErrorCode(code: .unknownItem)
    }
    public func isConflict() -> Bool {
        return isSpecificErrorCode(code: .serverRecordChanged)
    }
    public func isSpecificErrorCode(code: CKError.Code) -> Bool {
        var match = false
        if self.code == code {
            match = true
        }
        else if self.code == .partialFailure {
            guard let errors = partialErrorsByItemID else {
                return false
            }
            for (_, error) in errors {
                if let cke = error as? CKError {
                    if cke.code == code {
                        match = true
                        break
                    }
                }
            }
        }
        return match
    }

    public func getMergeRecords() -> (CKRecord?, CKRecord?) {
        if code == .serverRecordChanged {
            
            return (clientRecord, serverRecord)
        }
        guard code == .partialFailure else {
            return (nil, nil)
        }
        guard let errors = partialErrorsByItemID else {
            return (nil, nil)
        }
        for (_, error) in errors {
            if let cke = error as? CKError {
                if cke.code == .serverRecordChanged {
                    
                    return cke.getMergeRecords()
                }
            }
        }
        return (nil, nil)
    }
}

struct Public {
    static var tasks: [String] = [] //Массив задач
    static var newTaskPublic = String() //Новая задача
    static var doneTasksCouner = 0
}

struct System {
    static func clearNavigationBar(forBar navBar: UINavigationBar) {
        navBar.setBackgroundImage(UIImage(), for: .default)
        navBar.shadowImage = UIImage()
        navBar.isTranslucent = true
    }
}


class MainViewTableViewController: UITableViewController {
    
    
    
    @IBOutlet weak var toolBar: UIToolbar! //Тулбар с кнопкой добавления задачи
    @IBOutlet weak var navBar: UINavigationItem! //Заголовок
    @IBOutlet weak var addButtonItem: UIBarButtonItem! //Кнопка +
    @IBOutlet weak var sortButton: UIBarButtonItem!
    @IBOutlet weak var totalTasks: UIBarButtonItem!
    

    
    let darkModeSwitchBrightness = CGFloat(0.3)
    let userDefults = UserDefaults.standard
    let darkModeColor = UIColor(red:0.12, green:0.13, blue:0.14, alpha:1.0) //Цвет backround для Темной темы
    func saveTasks(tasks:Array<Any>) { //Сохранение массива задач
        UserDefaults.standard.set(Public.tasks, forKey: "tasksKey")
         MKiCloudSync.start(withPrefix: "tasks")
    }
    func loadTasks() -> Array<Any>{ //Чтение массива задач
        if UserDefaults.standard.array(forKey:"tasksKey") != nil {
            MKiCloudSync.start(withPrefix: "tasks")
            return UserDefaults.standard.array(forKey:"tasksKey")!
        } else {return ["Hello"]}
        
    }
    
    func saveDoneCounter(tasks:Int) {
        
        UserDefaults.standard.set(Public.doneTasksCouner, forKey: "tasksCounter")
        MKiCloudSync.start(withPrefix: "tasks")
    }
    func loadDoneCounter() -> Int {
        if UserDefaults.standard.integer(forKey:"tasksCounter") != nil {
             MKiCloudSync.start(withPrefix: "tasks")
            return UserDefaults.standard.integer(forKey:"tasksCounter")
        } else {return 0}
        
    }
    
    
    
    @IBAction func showAddTask(_ sender: Any) {
        self.saveTasks(tasks: Public.tasks) //Сохраниние при добавлении новой задачи
         self.totalTasks.title = ""
    }
        
    @IBAction func sortTasks(_ sender: Any) {
        Public.tasks.sort(by: >)
        self.tableView.reloadData()
        self.saveTasks(tasks: Public.tasks)
         self.totalTasks.title = ""
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.prefersLargeTitles = true //большой красивый заголовк
        navigationItem.hidesBackButton = true //Отключение кнопки Назад
        
        if let navController = navigationController {
            System.clearNavigationBar(forBar: navController.navigationBar)
            navController.view.backgroundColor = .clear
        }
        
     
         if UIScreen.main.brightness < darkModeSwitchBrightness { //Настройка темной темы
            self.navigationController!.navigationBar.tintColor = darkModeColor
            self.navigationController?.navigationBar.barTintColor = darkModeColor
            self.navigationController?.navigationBar.tintColor = .white
            self.navigationController?.navigationBar.barStyle = .black
            self.tableView.backgroundColor = darkModeColor
            self.tableView.tintColor = darkModeColor
            tableView.separatorColor = darkModeColor
            addButtonItem.tintColor = .white
            sortButton.tintColor = .white
            toolBar.barTintColor = darkModeColor
        }
        toolBar.clipsToBounds = true //Привязка тулбара
       
        
        Public.tasks = loadTasks() as! [String] //Загрузка списка задач
        Public.doneTasksCouner = loadDoneCounter()
        self.totalTasks.title = ""
        if Public.doneTasksCouner == 0{ //Наполнение списка, если он пуст ПОПРАВИТЬ
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
        
    }
    

    // MARK: - Table view data source


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        return Public.tasks.count
        
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath) //Создание ячеки и привязка по индентификатору к StoryBoard
        let task = Public.tasks[indexPath.row] //Новый элемент массива
       
        cell.textLabel?.text = task
       
        if UIScreen.main.brightness < darkModeSwitchBrightness {
            cell.backgroundColor = darkModeColor
            cell.textLabel?.textColor = .white
        }
        
        /*Настройки отображения cell (на всякий)
        cell.layer.cornerRadius = 6
        cell.layer.borderWidth = 3.0
        cell.layer.borderColor = UIColor.white.cgColor
        */
        cell.selectionStyle = UITableViewCell.SelectionStyle.none //отключения выбора ячейки
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
            self.tableView.beginUpdates()
            Public.tasks.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
            self.tableView.endUpdates()
        } else if editingStyle == .insert {
            
        }
        
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        //Свайп влево для Завершения
        let done = doneAction(at: indexPath)
        userDefults.set(Public.tasks, forKey: "TasksKey")
        userDefults.synchronize()
        self.totalTasks.title = "\(Public.doneTasksCouner)"
        return UISwipeActionsConfiguration(actions: [done])
    }
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        //Свайп вправо для Приоретета
        let pushUp = pushUpAction(at: indexPath)
        self.totalTasks.title = ""
        return UISwipeActionsConfiguration(actions: [pushUp])
    }

    func pushUpAction(at indexPath: IndexPath) -> UIContextualAction {
        let action = UIContextualAction(style: .normal, title: "↑"){_,_,_ in
            
            let movingElement = Public.tasks.remove(at: indexPath.row)
            let index = IndexPath(row: 0, section: 0) //Первая позиция
            Public.tasks.insert(movingElement, at: 0)
            var task = Array(Public.tasks[0])
           
            
            if task[0] == "⁰" {
              
            }
            if task[0] == "¹" {
                task[0] = "⁰"
            }
            if task[0] == "²" {
                task[0] = "¹"
            }
            
                
               
                
                
                Public.tasks[0] = String(task)
            
            /*
            if task[1] == "!" {
                
                if (task[0] == "9"){
                    task[0] = "0"
                } else{
                    if task[0] == "0" {
                    } else {
                        let x = String(task[0])
                        print(x)
                        let xInt = Int(x)! + 1
                        task[0] = Character("\(xInt)")
                       // task[0] = Character("\u{00B9}")
                    }
                }
    
                Public.tasks[0] = String(task)
            
            }else {
                
                Public.tasks[0] = "1! " + Public.tasks[0] //Добавление ! в название
                
            }
            */
            self.tableView.reloadData()
            
            self.tableView.cellForRow(at: index)?.textLabel!.font = UIFont.boldSystemFont(ofSize: 18.0) //Изменение шрифта задачи
           
            self.saveTasks(tasks: Public.tasks)
        }
        action.backgroundColor = UIColor(red:0.50, green:0.50, blue:0.50, alpha:1.0)//Задание цвета свайпа
        
        return action
    }
    func doneAction(at indexPath: IndexPath) -> UIContextualAction {
        let action = UIContextualAction(style: .normal, title: "✓"){_,_,_ in
           
            Public.tasks.remove(at: indexPath.row)
           
            self.tableView.reloadData()
            Public.doneTasksCouner += 1
            self.totalTasks.title = "\(Public.doneTasksCouner)"
            self.saveDoneCounter(tasks: Public.doneTasksCouner)
            self.saveTasks(tasks: Public.tasks)
        }
        action.backgroundColor = UIColor(red:0.30, green:0.30, blue:0.30, alpha:1.0)//Задание цвета свайпа
        
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
        let addVC = segue.destination as! AddTaskViewController //Ссылка на экран добавления задачи
        addVC.mainVC = self
    }
    

}
