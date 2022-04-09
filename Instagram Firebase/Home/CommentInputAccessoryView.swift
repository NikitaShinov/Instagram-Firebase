//
//  CommentInputAccessoryView.swift
//  Instagram Firebase
//
//  Created by max on 09.04.2022.
//

import UIKit

protocol CommentInputAccessoryViewDelegate {
    func didSubmit(for comment: String)
}

class CommentInputAccessoryView: UIView {
    
    var delegate: CommentInputAccessoryViewDelegate?
    
    func clearCommentTextField() {
        commentTextField.text = nil
        commentTextField.placeholderLabel.isHidden = false
    }
    
    fileprivate let submitButton: UIButton = {
        let submitButton = UIButton(type: .system)
        submitButton.setTitle("Submit", for: .normal)
        submitButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        submitButton.setTitleColor(.black, for: .normal)
        submitButton.addTarget(self, action: #selector(submitComment), for: .touchUpInside)
        return submitButton
    }()
    
    fileprivate let commentTextField: CommentInputTextView = {
        let text = CommentInputTextView()
//        text.placeholder = "Enter comment"
        text.isScrollEnabled = false
        text.font = UIFont.systemFont(ofSize: 18)
        return text
    }()
    
    
    override init(frame: CGRect) {
        super .init(frame: frame)
        
        autoresizingMask = .flexibleHeight
        backgroundColor = .white
    
        addSubview(submitButton)
        submitButton.anchor(top: topAnchor, left: nil, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 12, width: 50, height: 50)
        
        addSubview(commentTextField)
        commentTextField.anchor(top: topAnchor, left: leftAnchor, bottom: safeAreaLayoutGuide.bottomAnchor, right: submitButton.leftAnchor, paddingTop: 8, paddingLeft: 12, paddingBottom: 8, paddingRight: 0, width: 0, height: 0)
        
        setupLineSeparator()
    }
    
    override var intrinsicContentSize: CGSize {
        return .zero
    }
    
    fileprivate func setupLineSeparator() {
        let lineSeparatorView = UIView()
        lineSeparatorView.backgroundColor = UIColor.rgb(red: 230, green: 230, blue: 230)
        addSubview(lineSeparatorView)
        lineSeparatorView.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 1)
    }
    
    @objc func submitComment() {
        guard let comment = commentTextField.text else { return }
        delegate?.didSubmit(for: comment)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
