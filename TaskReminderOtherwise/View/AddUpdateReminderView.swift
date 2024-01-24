//
//  AddUpdateReminderView.swift
//  TaskReminderOtherwise
//
//  Created by JAYA$URYA on 07/11/23.
//

import UIKit

class AddUpdateReminderView: UIView {
//CreateUpdateTaskViewModel exposes data to this view
    
    weak var scrollView: UIScrollView!
    weak var contentView: UIView!
    weak var titleHeadingLbl: UILabel!
    weak var titleTextView: UITextView!
    weak var descriptionHeadingLbl: UILabel!
    weak var descriptionTextView: UITextView!
    
    weak var deadlineLbl: UILabel!
    weak var dateTimeBGView: UIView!
    weak var dateHeadingLbl: UILabel!
    weak var timeHeadlingLbl: UILabel!
    var datePickerHeightConstraint: NSLayoutConstraint!
    weak var datePicker: UIDatePicker!
    var timePickerHeightConstraint: NSLayoutConstraint!
    weak var timePicker: UIDatePicker!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .secondarySystemBackground
        _initializeUIAddUpdateReminderView()
        _setUpConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func _initializeUIAddUpdateReminderView(){
        let scroll = UIScrollView()
        scroll.translatesAutoresizingMaskIntoConstraints = false
        scroll.backgroundColor = .clear
        self.scrollView = scroll
        self.addSubview(scroll)
        
        let contentView = UIView()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.backgroundColor = .clear
        self.contentView = contentView
        self.scrollView.addSubview(contentView)
        
        let titleHeadingLbl = UILabel()
        titleHeadingLbl.backgroundColor = .clear
        titleHeadingLbl.translatesAutoresizingMaskIntoConstraints = false
        titleHeadingLbl.text = "Task Title"
        titleHeadingLbl.textColor = UIColor.secondaryLabel
        titleHeadingLbl.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        titleHeadingLbl.textAlignment = .left
        self.titleHeadingLbl = titleHeadingLbl
        self.contentView.addSubview(titleHeadingLbl)
        
        let toolBar1 = UIToolbar()
        toolBar1.sizeToFit()
        toolBar1.setItems([UIBarButtonItem(systemItem: .flexibleSpace),UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(resignTitleTextView))], animated: true)
        let titleTextView = UITextView()
        titleTextView.translatesAutoresizingMaskIntoConstraints = false
        titleTextView.backgroundColor = .systemBackground
        titleTextView.layer.cornerRadius = 10
        titleTextView.layer.masksToBounds = true
        titleTextView.textColor = UIColor.label
        titleTextView.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        titleTextView.tintColor = .systemOrange
        titleTextView.isScrollEnabled = false
        titleTextView.textContainerInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        titleTextView.inputAccessoryView = toolBar1
        self.titleTextView = titleTextView
        self.contentView.addSubview(titleTextView)
        
        let descriptionHeadingLbl = UILabel()
        descriptionHeadingLbl.backgroundColor = .clear
        descriptionHeadingLbl.translatesAutoresizingMaskIntoConstraints = false
        descriptionHeadingLbl.text = "Task Description"
        descriptionHeadingLbl.textColor = UIColor.secondaryLabel
        descriptionHeadingLbl.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        descriptionHeadingLbl.textAlignment = .left
        self.descriptionHeadingLbl = descriptionHeadingLbl
        self.contentView.addSubview(descriptionHeadingLbl)
        
        let toolBar2 = UIToolbar()
        toolBar2.sizeToFit()
        toolBar2.setItems([UIBarButtonItem(systemItem: .flexibleSpace),UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(resignDescriptionTextView))], animated: true)
        let descTextView = UITextView()
        descTextView.translatesAutoresizingMaskIntoConstraints = false
        descTextView.backgroundColor = .systemBackground
        descTextView.layer.cornerRadius = 10
        descTextView.layer.masksToBounds = true
        descTextView.inputAccessoryView = toolBar2
        descTextView.textColor = UIColor.label
        descTextView.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        descTextView.tintColor = .systemOrange
        descTextView.isScrollEnabled = false
        descTextView.textContainerInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        self.descriptionTextView = descTextView
        self.contentView.addSubview(descTextView)
        
        let deadlineLbl = UILabel()
        deadlineLbl.backgroundColor = .clear
        deadlineLbl.translatesAutoresizingMaskIntoConstraints = false
        deadlineLbl.text = "Task Deadline"
        deadlineLbl.textColor = UIColor.secondaryLabel
        deadlineLbl.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        deadlineLbl.textAlignment = .left
        self.deadlineLbl = deadlineLbl
        self.contentView.addSubview(deadlineLbl)
        
        let dateTimeBGView = UIView()
        dateTimeBGView.translatesAutoresizingMaskIntoConstraints = false
        dateTimeBGView.backgroundColor = .systemBackground
        dateTimeBGView.layer.cornerRadius = 10
        dateTimeBGView.layer.masksToBounds = true
        self.dateTimeBGView = dateTimeBGView
        self.contentView.addSubview(dateTimeBGView)
        
        let dateHeadingTapGesture = UITapGestureRecognizer(target: self, action: #selector(showHideDatePicker))
        let dateHeadingLbl = UILabel()
        dateHeadingLbl.isUserInteractionEnabled = true
        dateHeadingLbl.translatesAutoresizingMaskIntoConstraints = false
        dateHeadingLbl.text = "Date"
        dateHeadingLbl.textColor = UIColor.label
        dateHeadingLbl.backgroundColor = .clear
        dateHeadingLbl.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        dateHeadingLbl.textAlignment = .left
        dateHeadingLbl.addGestureRecognizer(dateHeadingTapGesture)
        self.dateHeadingLbl = dateHeadingLbl
        self.dateTimeBGView.addSubview(dateHeadingLbl)
        
        let datePicker = UIDatePicker()
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        datePicker.isHidden = true
        datePicker.locale = Locale.current
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .inline
        datePicker.addTarget(self, action: #selector(setDate(_:)), for: .valueChanged)
        self.datePicker = datePicker
        self.dateTimeBGView.addSubview(datePicker)
        
        let timeHeadingTapGesture = UITapGestureRecognizer(target: self, action: #selector(showHideTimePicker))
        let timeHeadingLbl = UILabel()
        timeHeadingLbl.isUserInteractionEnabled = true
        timeHeadingLbl.translatesAutoresizingMaskIntoConstraints = false
        timeHeadingLbl.text = "Time"
        timeHeadingLbl.textColor = UIColor.label
        timeHeadingLbl.backgroundColor = .clear
        timeHeadingLbl.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        timeHeadingLbl.textAlignment = .left
        timeHeadingLbl.addGestureRecognizer(timeHeadingTapGesture)
        self.timeHeadlingLbl = timeHeadingLbl
        self.dateTimeBGView.addSubview(timeHeadingLbl)
        
        let timePicker = UIDatePicker()
        timePicker.translatesAutoresizingMaskIntoConstraints = false
        timePicker.isHidden = true
        timePicker.locale = Locale.current
        timePicker.datePickerMode = .time
        timePicker.preferredDatePickerStyle = .wheels
        self.timePicker = timePicker
        self.dateTimeBGView.addSubview(timePicker)
    }
    
    @objc
    private func setDate(_ datePicker: UIDatePicker){
        self.dateHeadingLbl.text = getDateInStr(date: datePicker.date)
    }
    
    private func getDateInStr(date: Date) -> String{
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "MMM d, yyyy"
        let dateStr = dateFormat.string(from: datePicker.date)
        return "Date:      \(dateStr)"
    }
    
    private func _setUpConstraints(){
        let scrollViewConstraints: [NSLayoutConstraint] = [
            self.scrollView.topAnchor.constraint(equalTo: self.topAnchor),
            self.scrollView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            self.scrollView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.scrollView.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ]
        NSLayoutConstraint.activate(scrollViewConstraints)

        let contentViewConstraints: [NSLayoutConstraint] = [
            self.contentView.topAnchor.constraint(equalTo: self.scrollView.topAnchor),
            self.contentView.bottomAnchor.constraint(equalTo: self.scrollView.bottomAnchor),
            self.contentView.leadingAnchor.constraint(equalTo: self.scrollView.leadingAnchor),
            self.contentView.trailingAnchor.constraint(equalTo: self.scrollView.trailingAnchor),
            self.contentView.widthAnchor.constraint(equalTo: self.widthAnchor)
        ]
        NSLayoutConstraint.activate(contentViewConstraints)

        let titleHeadingLblConstraints: [NSLayoutConstraint] = [
            self.titleHeadingLbl.topAnchor.constraint(
                equalTo: self.contentView.topAnchor,
                constant: 30),
            self.titleHeadingLbl.leadingAnchor.constraint(
                equalTo: self.contentView.leadingAnchor,
                constant: 25),
            self.titleHeadingLbl.heightAnchor.constraint(equalToConstant: 25)
        ]
        NSLayoutConstraint.activate(titleHeadingLblConstraints)

        let titleTextViewConstraints: [NSLayoutConstraint] = [
            self.titleTextView.topAnchor.constraint(
                equalTo: self.titleHeadingLbl.bottomAnchor,
                constant: 3),
            self.titleTextView.leadingAnchor.constraint(
                equalTo: self.contentView.leadingAnchor,
                constant: 20),
            self.titleTextView.trailingAnchor.constraint(
                equalTo: self.contentView.trailingAnchor,
                constant: -20)
        ]
        NSLayoutConstraint.activate(titleTextViewConstraints)

        
        let descHeadingLblConstraints: [NSLayoutConstraint] = [
            self.descriptionHeadingLbl.topAnchor.constraint(
                equalTo: self.titleTextView.bottomAnchor,
                constant: 30),
            self.descriptionHeadingLbl.leadingAnchor.constraint(equalTo: self.titleHeadingLbl.leadingAnchor),
            self.descriptionHeadingLbl.heightAnchor.constraint(equalToConstant: 30)
        ]
        NSLayoutConstraint.activate(descHeadingLblConstraints)

        let descTextViewConstraints: [NSLayoutConstraint] = [
            self.descriptionTextView.topAnchor.constraint(
                equalTo: self.descriptionHeadingLbl.bottomAnchor,
                constant: 3),
            self.descriptionTextView.leadingAnchor.constraint(equalTo: self.titleTextView.leadingAnchor),
            self.descriptionTextView.trailingAnchor.constraint(equalTo: self.titleTextView.trailingAnchor)
        ]
        NSLayoutConstraint.activate(descTextViewConstraints)

        let deadlineConstraints: [NSLayoutConstraint] = [
            self.deadlineLbl.topAnchor.constraint(
                equalTo: self.descriptionTextView.bottomAnchor,
                constant: 30),
            self.deadlineLbl.leadingAnchor.constraint(equalTo: self.titleHeadingLbl.leadingAnchor),
            self.deadlineLbl.heightAnchor.constraint(equalToConstant: 30)
        ]
        NSLayoutConstraint.activate(deadlineConstraints)
        
        let dateTimeBGViewConstraints: [NSLayoutConstraint] = [
            self.dateTimeBGView.topAnchor.constraint(
                equalTo: self.deadlineLbl.bottomAnchor,
                constant: 3),
            self.dateTimeBGView.leadingAnchor.constraint(equalTo: self.descriptionTextView.leadingAnchor),
            self.dateTimeBGView.trailingAnchor.constraint(equalTo: self.descriptionTextView.trailingAnchor),
            self.dateTimeBGView.bottomAnchor.constraint(
                equalTo: self.contentView.bottomAnchor,
                constant: -20)
        ]
        NSLayoutConstraint.activate(dateTimeBGViewConstraints)

        let dateHeadingLblConstraints: [NSLayoutConstraint] = [
            self.dateHeadingLbl.topAnchor.constraint(
                equalTo: self.dateTimeBGView.topAnchor,
                constant: 10),
            self.dateHeadingLbl.leadingAnchor.constraint(
                equalTo: self.dateTimeBGView.leadingAnchor,
                constant: 20),
            self.dateHeadingLbl.trailingAnchor.constraint(
                equalTo: self.dateTimeBGView.trailingAnchor,
                constant: -10),
            self.dateHeadingLbl.heightAnchor.constraint(equalToConstant: 40)
        ]
        NSLayoutConstraint.activate(dateHeadingLblConstraints)

        let datePickerConstraints: [NSLayoutConstraint] = [
            self.datePicker.topAnchor.constraint(equalTo: self.dateHeadingLbl.bottomAnchor),
            self.datePicker.leadingAnchor.constraint(
                equalTo: self.dateTimeBGView.leadingAnchor,
                constant: 5),
            self.datePicker.trailingAnchor.constraint(
                equalTo: self.dateTimeBGView.trailingAnchor,
                constant: -5),
            self.datePicker.heightAnchor.constraint(equalToConstant: 0)
        ]
        self.datePickerHeightConstraint = datePickerConstraints[3]
        NSLayoutConstraint.activate(datePickerConstraints)

        let timeHeadingLblConstraints: [NSLayoutConstraint] = [
            self.timeHeadlingLbl.topAnchor.constraint(equalTo: self.datePicker.bottomAnchor),
            self.timeHeadlingLbl.leadingAnchor.constraint(equalTo: self.dateHeadingLbl.leadingAnchor),
            self.timeHeadlingLbl.trailingAnchor.constraint(equalTo: self.dateHeadingLbl.trailingAnchor),
            self.timeHeadlingLbl.heightAnchor.constraint(equalToConstant: 40)
        ]
        NSLayoutConstraint.activate(timeHeadingLblConstraints)

        let timePickerConstraints: [NSLayoutConstraint] = [
            self.timePicker.topAnchor.constraint(equalTo: self.timeHeadlingLbl.bottomAnchor),
            self.timePicker.leadingAnchor.constraint(equalTo: self.datePicker.leadingAnchor),
            self.timePicker.trailingAnchor.constraint(equalTo: self.datePicker.trailingAnchor),
            self.timePicker.bottomAnchor.constraint(equalTo: self.dateTimeBGView.bottomAnchor),
            self.timePicker.heightAnchor.constraint(equalToConstant: 0)
        ]
        self.timePickerHeightConstraint = timePickerConstraints[4]
        NSLayoutConstraint.activate(timePickerConstraints)
    }
    
    @objc
    private func showHideDatePicker(){
        UIView.animate(withDuration: 0.3,
                       delay: 0,
                       options: [.curveEaseInOut]){
            if self.datePicker.isHidden{
                self.timePicker.isHidden = true
                self.timePickerHeightConstraint.constant = 0
                self.datePicker.isHidden = false
                self.datePickerHeightConstraint.constant = 300
            } else{
                self.datePickerHeightConstraint.constant = 0
                self.datePicker.isHidden = true
            }
            self.layoutIfNeeded()
        }
    }
    
    @objc
    private func showHideTimePicker(){
        UIView.animate(withDuration: 0.3,
                       delay: 0,
                       options: [.curveEaseInOut]){
            if self.timePicker.isHidden{
                self.datePicker.isHidden = true
                self.datePickerHeightConstraint.constant = 0
                self.timePicker.isHidden = false
                self.timePickerHeightConstraint.constant = 200
            } else{
                self.timePickerHeightConstraint.constant = 0
                self.timePicker.isHidden = true
            }
            self.layoutIfNeeded()
        }
    }
    
    func setValues(createUpdateTaskVM: CreateUpdateTaskViewModel){
        self.titleTextView.text = createUpdateTaskVM.taskTitle
        self.descriptionTextView.text = createUpdateTaskVM.taskDescription
        self.dateHeadingLbl.text = getDateInStr(date: createUpdateTaskVM.date)
        self.datePicker.date = createUpdateTaskVM.date
        self.timePicker.date = createUpdateTaskVM.time
        if Date()>createUpdateTaskVM.date{
            self.backgroundColor = .red
        }
    }
    
    @objc
    private func resignTitleTextView(){
        self.titleTextView.resignFirstResponder()
    }
    
    @objc
    private func resignDescriptionTextView(){
        self.descriptionTextView.resignFirstResponder()
    }
    
}
