//
//  EachTaskReminderTableViewCell.swift
//  TaskReminderOtherwise
//
//  Created by JAYA$URYA on 06/11/23.
//

import UIKit

class EachTaskReminderTableViewCell: UITableViewCell {

    let notificationCenter = NotificationCenter.default
    
    static let identifier = "EachTaskReminderTableViewCell"
    
    var timer: Timer!
    weak var titleLbl: UILabel!
    weak var descriptionBGView: UIView!
    weak var descriptionLbl: UILabel!
    weak var timerLbl: UILabel!

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        _initializeUIEachTaskReminderTableViewCell()
        _setUpConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
 
    private func _initializeUIEachTaskReminderTableViewCell(){

        let titlelbl = UILabel()
        titlelbl.translatesAutoresizingMaskIntoConstraints = false
        titlelbl.numberOfLines = 0
        titlelbl.textAlignment = .left
        titlelbl.textColor = UIColor.label
        titlelbl.font = UIFont.systemFont(ofSize: 22, weight: .semibold)
        self.titleLbl = titlelbl
        self.contentView.addSubview(titlelbl)
        
        let descView = UIView()
        descView.translatesAutoresizingMaskIntoConstraints = false
        descView.backgroundColor = .clear
        self.descriptionBGView = descView
        self.contentView.addSubview(descView)
        
        let desclbl = UILabel()
        desclbl.numberOfLines = 0
        desclbl.textAlignment = .left
        desclbl.translatesAutoresizingMaskIntoConstraints = false
        desclbl.textColor = UIColor.label
        desclbl.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        self.descriptionLbl = desclbl
        self.descriptionBGView.addSubview(desclbl)
        
        let timerLbl = UILabel()
        timerLbl.numberOfLines = 0
        timerLbl.translatesAutoresizingMaskIntoConstraints = false
        timerLbl.textAlignment = .left
        timerLbl.textColor = UIColor.tertiaryLabel
        timerLbl.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        self.timerLbl = timerLbl
        self.contentView.addSubview(timerLbl)
    }
    
    private func _setUpConstraints(){
        let titleLblConstratins: [NSLayoutConstraint] = [
            self.titleLbl.topAnchor.constraint(
                equalTo: self.contentView.topAnchor,
                constant: 10),
            self.titleLbl.leadingAnchor.constraint(
                equalTo: self.contentView.leadingAnchor,
                constant: 20),
            self.titleLbl.trailingAnchor.constraint(
                equalTo: self.contentView.trailingAnchor,
                constant: -10)
        ]
        
        let desclblConstraints: [NSLayoutConstraint] = [
            self.descriptionLbl.topAnchor.constraint(equalTo:self.descriptionBGView.topAnchor),
            self.descriptionLbl.bottomAnchor.constraint(equalTo: self.descriptionBGView.bottomAnchor),
            self.descriptionLbl.leadingAnchor.constraint(equalTo: self.descriptionBGView.leadingAnchor),
            self.descriptionLbl.trailingAnchor.constraint(equalTo: self.descriptionBGView.trailingAnchor)
        ]
        
        let descViewContraints: [NSLayoutConstraint] = [
            self.descriptionBGView.topAnchor.constraint(
                equalTo: self.titleLbl.bottomAnchor,
                constant: 5),
            self.descriptionBGView.bottomAnchor.constraint(
                equalTo: self.timerLbl.topAnchor,
                constant: -10),
            self.descriptionBGView.leadingAnchor.constraint(
                equalTo: self.contentView.leadingAnchor,
                constant: 20),
            self.descriptionBGView.trailingAnchor.constraint(
                equalTo: self.contentView.trailingAnchor,
                constant: -10)
        ]
        
        let timerLblConstraints: [NSLayoutConstraint] = [
            self.timerLbl.leadingAnchor.constraint(
                equalTo: self.contentView.leadingAnchor,
                constant: 20),
            self.timerLbl.trailingAnchor.constraint(
                equalTo: self.contentView.trailingAnchor,
                constant: -10),
            self.timerLbl.bottomAnchor.constraint(
                equalTo: self.contentView.bottomAnchor,
                constant: -10)
        ]
        
        let contentViewConstraints: [NSLayoutConstraint] = [
            self.contentView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.contentView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            self.contentView.topAnchor.constraint(equalTo: self.topAnchor),
            self.contentView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ]
        
        NSLayoutConstraint.activate(titleLblConstratins)
        NSLayoutConstraint.activate(desclblConstraints)
        NSLayoutConstraint.activate(descViewContraints)
        NSLayoutConstraint.activate(timerLblConstraints)
        NSLayoutConstraint.activate(contentViewConstraints)
    }
    
    func setValues(taskReminderVM: TaskReminderViewModel, index: Int){
        self.titleLbl.text = taskReminderVM.taskDetails[index].taskTitle
        self.descriptionLbl.text = taskReminderVM.taskDetails[index].taskDescription
        let (time, color) = taskReminderVM.getRemainingTimeFromTaskDetail(at: index)
        self.timerLbl.text = "Remaining Time: \(time)"
        self.timerLbl.textColor = color
        
        self.timer = Timer(fire: taskReminderVM.calculateNextMinuteToStartFireTimer(), interval: 60, repeats: true){ [weak self] timer in
            guard let self = self else{return}
            let (time, color) = taskReminderVM.getRemainingTimeFromTaskDetail(at: index)
            self.timerLbl.text = "Remaining Time: \(time)"
            self.timerLbl.textColor = color
        }
        
        RunLoop.current.add(self.timer, forMode: .default)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.timer.invalidate()
        self.timer = nil
        self.titleLbl.text = nil
        self.descriptionLbl.text = nil
        self.timerLbl.text = nil
    }
    
}
