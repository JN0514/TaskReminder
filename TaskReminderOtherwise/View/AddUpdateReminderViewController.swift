//
//  AddUpdateReminderViewController.swift
//  TaskReminderOtherwise
//
//  Created by JAYA$URYA on 06/11/23.
//

import UIKit
import WidgetKit

class AddUpdateReminderViewController: UIViewController {

    let createUpdateTaskVM: CreateUpdateTaskViewModel
    let addUpdateReminderView = AddUpdateReminderView()
    
    init(createUpdateTaskVM: CreateUpdateTaskViewModel) {
        self.createUpdateTaskVM = createUpdateTaskVM
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        self.view = addUpdateReminderView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        _setUpTopBar()
        addUpdateReminderView.setValues(createUpdateTaskVM: createUpdateTaskVM)
    }
    
    private func _setUpTopBar(){
        self.title = "Task Detail"

        self.navigationController?.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.label,
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18, weight: .semibold)
        ]
        
        let doneBtn = UIBarButtonItem(
                        title: "\(createUpdateTaskVM.taskDetail == nil ? "Create": "Update")",
                        style: .done,
                        target: self,
                        action: #selector(_doneBtnTapped))
        self.navigationController?.navigationBar.topItem?.rightBarButtonItem = doneBtn
        let cancelBtn = UIBarButtonItem(
                        title: "Cancel",
                        style: .done,
                        target: self,
                        action: #selector(_cancelBtnTapped))
        self.navigationController?.navigationBar.topItem?.leftBarButtonItem = cancelBtn
    }
    

    @objc
    private func _doneBtnTapped(){
        self.createUpdateTaskVM.createOrUpdateTask(
            with: addUpdateReminderView.titleTextView.text,
            desc: addUpdateReminderView.descriptionTextView.text,
            date: addUpdateReminderView.datePicker.date,
            time: addUpdateReminderView.timePicker.date) {
                [weak self] success, msg in
                guard let self = self else {return}
                if success{
                    self._cancelBtnTapped()
                    WidgetCenter.shared.reloadTimelines(ofKind: "TaskReminderWidget")
                    
                } else{
                    let alert = UIAlertController(
                        title: "Alert",
                        message: msg,
                        preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Okay", style: .cancel))
                    self.present(alert, animated: true)
                }
                
            }
    }
    
    @objc
    private func _cancelBtnTapped(){
        self.dismiss(animated: true)
    }
}
