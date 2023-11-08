//
//  TextViewEmbeddedTableViewCell.swift
//  TaskReminderOtherwise
//
//  Created by JAYA$URYA on 07/11/23.
//

import UIKit

protocol TextViewEmbeddedTableViewCellDelegate: AnyObject{
    func reload(_ cell: TextViewEmbeddedTableViewCell)
}

class TextViewEmbeddedTableViewCell: UITableViewCell {
    
    static let identifier = "TextViewEmbeddedTableViewCell"
    
    weak var textView: UITextView!
    weak var delegate: TextViewEmbeddedTableViewCellDelegate?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        _initializeUITextViewEmbeddedTableViewCell()
        _setUpConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func _initializeUITextViewEmbeddedTableViewCell(){
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.backgroundColor = .clear
        textView.textColor = UIColor.label
        textView.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        textView.tintColor = .systemOrange
        textView.isScrollEnabled = false
//        textView.textContainer.lineFragmentPadding = .zero
//        textView.textContainerInset = .zero
        textView.delegate = self
        self.textView = textView
        self.contentView.addSubview(textView)
    }
    
    private func _setUpConstraints(){
        setPadding(
            for: self.textView,
            in: self.contentView,
            with: 5)
        
        setPadding(
            for: self.contentView,
            in: self,
            with: 0)
    }
    
    private func setPadding(for a: UIView, in b: UIView, with inset: CGFloat){
        let nsConstraints: [NSLayoutConstraint] = [
            a.topAnchor.constraint(
                equalTo: b.topAnchor,
                constant: inset),
            a.bottomAnchor.constraint(
                equalTo: b.bottomAnchor,
                constant: -inset),
            a.leadingAnchor.constraint(
                equalTo: b.leadingAnchor,
                constant: inset),
            a.trailingAnchor.constraint(
                equalTo: b.trailingAnchor,
                constant: -inset)
        ]
        
        NSLayoutConstraint.activate(nsConstraints)
    }
}

extension TextViewEmbeddedTableViewCell: UITextViewDelegate{
    func textViewDidChange(_ textView: UITextView) {
        adjustTextViewHeight(textView)
    }
    
    func adjustTextViewHeight(_ textView: UITextView) {

        let newSize = textView.sizeThatFits(CGSize(width: textView.frame.size.width, height: .greatestFiniteMagnitude))

        if (newSize.height+10) > self.frame.size.height{
            delegate?.reload(self)
        }
    }
}
