//
//  ViewController.swift
//  TaskReminderOtherwise
//
//  Created by JAYA$URYA on 06/11/23.
//

import UIKit

class ReminderHomeViewController: UITableViewController {
//This Controller lists the tasks Reminder.
//Also acts as intermediary for TaskReminderViewModel and EachTaskReminderTableViewCell interact with
    var taskReminderVM = TaskReminderViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.taskReminderVM.getTaskDetails()
        _setupNavBar()
        _setupTable()
    }

    @objc
    private func btnTappedToCreateTaskReminder(){
        var createUpdateVM = CreateUpdateTaskViewModel()
        //Acts as Observer, for creating or updating Task.
        createUpdateVM.notifyAddedOrUpdatedStatus = {
            [weak self] in
            self?.taskReminderVM.getTaskDetails()
        }
        let addReminderVC = AddUpdateReminderViewController(createUpdateTaskVM: createUpdateVM)
        let navVC = UINavigationController(rootViewController: addReminderVC)
        navVC.modalPresentationStyle = .overCurrentContext
        self.present(navVC, animated: true)
    }
    
    private func _setupNavBar(){
        self.title = "Reminder"
        self.overrideUserInterfaceStyle = ThemeColor.shared.userInterfaceStyle
        self.navigationController?.overrideUserInterfaceStyle = ThemeColor.shared.userInterfaceStyle
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationController?.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.systemOrange,
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18, weight: .semibold)
        ]
        self.navigationController?.navigationBar.largeTitleTextAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.systemOrange,
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 38, weight: .bold)
        ]
        
        let addBtn = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(btnTappedToCreateTaskReminder))
        addBtn.tintColor = UIColor.orange
        
        let img = UIImage(systemName: "\(ThemeColor.shared.isDark ? "lightbulb.fill" : "lightbulb.slash.fill")")
        let themeBtn = UIBarButtonItem(image: img, style: .done, target: self, action: #selector(themeTransitionBtnTapped))
        themeBtn.tintColor = UIColor.orange
        self.navigationController?.navigationBar.topItem?.leftBarButtonItems = [addBtn, themeBtn]

        self.navigationController?.navigationBar.topItem?.rightBarButtonItem = editButtonItem
        self.navigationController?.navigationBar.topItem?.rightBarButtonItem?.setTitleTextAttributes([
            NSAttributedString.Key.font : UIFont.systemFont(ofSize: 20, weight: .medium),
            NSAttributedString.Key.foregroundColor: UIColor.orange
        ], for: .normal)
    }
    
    private func _setupTable(){
        self.tableView.register(EachTaskReminderTableViewCell.self, forCellReuseIdentifier: EachTaskReminderTableViewCell.identifier)
        self.taskReminderVM.performActionForTaskDetailValueChange = {[weak self] in
            guard let self = self else{return}
            DispatchQueue.main.async {
                self.tableView.reloadSections(IndexSet(integer: 0), with: .fade)
            }
        }
    }
    
    
    @objc
    private func themeTransitionBtnTapped(){
        ThemeColor.shared.isDark.toggle()
        if let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate{
            sceneDelegate.window?.rootViewController = UINavigationController(rootViewController: ReminderHomeViewController())
        }
    }
}

// MARK: - UITableViewDataSource
extension ReminderHomeViewController{
    override func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        taskReminderVM.taskDetails.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: EachTaskReminderTableViewCell.identifier,
            for: indexPath) as! EachTaskReminderTableViewCell
        cell.setValues(taskReminderVM: taskReminderVM, index: indexPath.row)
        return cell
    }
    
}

// MARK: - UITableViewDelegate
extension ReminderHomeViewController{
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        //Creating View model with initializer of TaskDetail for task updation.
        var createUpdateTaskVM = CreateUpdateTaskViewModel(taskDetail: self.taskReminderVM.taskDetails[indexPath.row])
        createUpdateTaskVM.notifyAddedOrUpdatedStatus = {
            [weak self] in
            self?.taskReminderVM.getTaskDetails()
        }
        let addReminderVC = AddUpdateReminderViewController(createUpdateTaskVM: createUpdateTaskVM)
        let navigationVC = UINavigationController(rootViewController: addReminderVC)
        navigationVC.modalPresentationStyle = .overCurrentContext
        self.present(navigationVC, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            self.taskReminderVM.deleteTaskDetail(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
}
