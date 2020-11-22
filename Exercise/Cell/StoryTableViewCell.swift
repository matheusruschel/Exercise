//
//  StoryTableViewCell.swift
//  Exercise
//
//  Created by Matheus Ruschel on 2020-11-21.
//

import UIKit
import SnapKit

class StoryTableViewCell: UITableViewCell {
    
    var titleLabel: UILabel = {
        var label = UILabel()
        label.numberOfLines = 0
        return label
    }()
    
    var descriptionLabel: UILabel = {
        var label = UILabel()
        label.numberOfLines = 0 
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.addSubview(titleLabel)
        self.addSubview(descriptionLabel)
        
        titleLabel.snp.makeConstraints({
            $0.leading.equalTo(self.snp.leading).offset(10)
            $0.top.equalTo(self.snp.topMargin)
            $0.trailing.equalTo(self.snp.trailing).offset(10)
        })
        
        descriptionLabel.snp.makeConstraints({
            $0.leading.equalTo(self.snp.leading).offset(10)
            $0.top.equalTo(titleLabel.snp.bottomMargin).offset(10)
            $0.trailing.equalTo(self.snp.trailing).offset(10)
            $0.bottom.equalTo(self.snp.bottomMargin)
        })
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
