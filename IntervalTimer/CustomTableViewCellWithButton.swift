//
//  CustomTableViewCellWithButton.swift
//  IntervalTimer
//
//  Created by Jungjin Park on 2024-07-14.
//

import UIKit

class CustomTableViewCellWithButton: UITableViewCell {

    lazy var button: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Submit", for: .normal)
        button.backgroundColor = .systemBrown
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(button)
        
        NSLayoutConstraint.activate([
            button.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            button.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            button.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            button.widthAnchor.constraint(equalToConstant: 100)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
