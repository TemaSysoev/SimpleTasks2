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

    @IBOutlet weak var addButton: UIButton! //кнопка Done
    
    var mainVC = MainViewTableViewController() //Главный вью (список задач)
    
   
    
    @IBOutlet weak var nameTextField: UITextField!//ТекстФилд для имени задачи
    
    
   
    let darkModeColor = UIColor(red:0.12, green:0.13, blue:0.14, alpha:1.0)//Темный цвет
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.nameTextField.delegate = self
        nameTextField.becomeFirstResponder()//Включение клавиатуры при входе
        addButton.layer.cornerRadius = 6 //красивы углы у кнопки
       
    
    }
    
    @IBAction func returnButtonTapped(_ sender: Any) {//Добавление задачи по кнопке с клавиатуры
        addTaskAction()
    }
    
    
   @IBAction func addAction(_ sender: Any) { //добавление по обычной Done
        addTaskAction()
    
    }
    
    @IBAction func cancelAction(_ sender: Any) {
        dismissAction()
    }
    
    
    
    func addTaskAction() { //Добаление заадчи
        if nameTextField.text != "" {
            Public.newTaskPublic = "² " + nameTextField.text!
            Public.tasks.append(Public.newTaskPublic) //добавление в массив
            mainVC.tableView.reloadData() //Обновление TableView
            dismissAction() //закрытие экрана
        } else {
           dismissAction()
        }
        
       
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
/*Localisations
 uk
 /* Class = "UIBarButtonItem"; title = "☰"; ObjectID = "37v-7U-nMT"; */
 "37v-7U-nMT.title" = "☰";
 
 /* Class = "UINavigationItem"; title = "Tasks"; ObjectID = "GT0-Fo-P0d"; */
 "GT0-Fo-P0d.title" = "Справи";
 
 /* Class = "UIBarButtonItem"; title = "Total:"; ObjectID = "TcH-u5-GQG"; */
 "TcH-u5-GQG.title" = "Total:";
 
 /* Class = "UIButton"; normalTitle = "Done"; ObjectID = "W2K-Eo-MGa"; */
 "W2K-Eo-MGa.normalTitle" = "Готово";
 
 /* Class = "UITextField"; placeholder = "New task"; ObjectID = "oud-E2-yHc"; */
 "oud-E2-yHc.placeholder" = "Нове завдання";

 
 sp
 
 
 
 /* Class = "UIBarButtonItem"; title = "☰"; ObjectID = "37v-7U-nMT"; */
 "37v-7U-nMT.title" = "☰";
 
 /* Class = "UINavigationItem"; title = "Tasks"; ObjectID = "GT0-Fo-P0d"; */
 "GT0-Fo-P0d.title" = "Tareas";
 
 /* Class = "UIBarButtonItem"; title = "Total:"; ObjectID = "TcH-u5-GQG"; */
 "TcH-u5-GQG.title" = "Total:";
 
 /* Class = "UIButton"; normalTitle = "Done"; ObjectID = "W2K-Eo-MGa"; */
 "W2K-Eo-MGa.normalTitle" = "Hecho";
 
 /* Class = "UITextField"; placeholder = "New task"; ObjectID = "oud-E2-yHc"; */
 "oud-E2-yHc.placeholder" = "Nueva tarea";

 
 ch
 
 /* Class = "UIBarButtonItem"; title = "☰"; ObjectID = "37v-7U-nMT"; */
 "37v-7U-nMT.title" = "☰";
 
 /* Class = "UINavigationItem"; title = "Tasks"; ObjectID = "GT0-Fo-P0d"; */
 "GT0-Fo-P0d.title" = "任务";
 
 /* Class = "UIBarButtonItem"; title = "Total:"; ObjectID = "TcH-u5-GQG"; */
 "TcH-u5-GQG.title" = "Total:";
 
 /* Class = "UIButton"; normalTitle = "Done"; ObjectID = "W2K-Eo-MGa"; */
 "W2K-Eo-MGa.normalTitle" = "完成";
 
 /* Class = "UITextField"; placeholder = "New task"; ObjectID = "oud-E2-yHc"; */
 "oud-E2-yHc.placeholder" = "新任务";

 
 fre
 
 /* Class = "UIBarButtonItem"; title = "☰"; ObjectID = "37v-7U-nMT"; */
 "37v-7U-nMT.title" = "☰";
 
 /* Class = "UINavigationItem"; title = "Tasks"; ObjectID = "GT0-Fo-P0d"; */
 "GT0-Fo-P0d.title" = "Les tâches";
 
 /* Class = "UIBarButtonItem"; title = "Total:"; ObjectID = "TcH-u5-GQG"; */
 "TcH-u5-GQG.title" = "Total:";
 
 /* Class = "UIButton"; normalTitle = "Done"; ObjectID = "W2K-Eo-MGa"; */
 "W2K-Eo-MGa.normalTitle" = "Terminé";
 
 /* Class = "UITextField"; placeholder = "New task"; ObjectID = "oud-E2-yHc"; */
 "oud-E2-yHc.placeholder" = "Nouvelle tâche";

 
 
 
 it
 
 
 /* Class = "UIBarButtonItem"; title = "☰"; ObjectID = "37v-7U-nMT"; */
 "37v-7U-nMT.title" = "☰";
 
 /* Class = "UINavigationItem"; title = "Tasks"; ObjectID = "GT0-Fo-P0d"; */
 "GT0-Fo-P0d.title" = "Compiti";
 
 /* Class = "UIBarButtonItem"; title = "Total:"; ObjectID = "TcH-u5-GQG"; */
 "TcH-u5-GQG.title" = "Total:";
 
 /* Class = "UIButton"; normalTitle = "Done"; ObjectID = "W2K-Eo-MGa"; */
 "W2K-Eo-MGa.normalTitle" = "Fatto";
 
 /* Class = "UITextField"; placeholder = "New task"; ObjectID = "oud-E2-yHc"; */
 "oud-E2-yHc.placeholder" = "Nuovo compito";

 
 
 
 gr
 
 
 /* Class = "UIBarButtonItem"; title = "☰"; ObjectID = "37v-7U-nMT"; */
 "37v-7U-nMT.title" = "☰";
 
 /* Class = "UINavigationItem"; title = "Tasks"; ObjectID = "GT0-Fo-P0d"; */
 "GT0-Fo-P0d.title" = "Καθήκοντα";
 
 /* Class = "UIBarButtonItem"; title = "Total:"; ObjectID = "TcH-u5-GQG"; */
 "TcH-u5-GQG.title" = "Total:";
 
 /* Class = "UIButton"; normalTitle = "Done"; ObjectID = "W2K-Eo-MGa"; */
 "W2K-Eo-MGa.normalTitle" = "Έγινε";
 
 /* Class = "UITextField"; placeholder = "New task"; ObjectID = "oud-E2-yHc"; */
 "oud-E2-yHc.placeholder" = "Νέα εργασία";

 
 
 
 rus
 
 
 /* Class = "UIBarButtonItem"; title = "☰"; ObjectID = "37v-7U-nMT"; */
 "37v-7U-nMT.title" = "☰";
 
 /* Class = "UINavigationItem"; title = "Tasks"; ObjectID = "GT0-Fo-P0d"; */
 "GT0-Fo-P0d.title" = "Список дел";
 
 /* Class = "UIBarButtonItem"; title = "Total:"; ObjectID = "TcH-u5-GQG"; */
 "TcH-u5-GQG.title" = "Всего:";
 
 /* Class = "UIButton"; normalTitle = "Done"; ObjectID = "W2K-Eo-MGa"; */
 "W2K-Eo-MGa.normalTitle" = "Готово";
 
 /* Class = "UITextField"; placeholder = "New task"; ObjectID = "oud-E2-yHc"; */
 "oud-E2-yHc.placeholder" = "Новая задача";

 
 
 */
