//
//  SearchListSectionHeader.swift
//  GoogleBook_jaeseung
//
//  Created by jaeseung lim on 2022/08/17.
//

import UIKit
import SnapKit

class SearchListSectionHeader: UITableViewHeaderFooterView {
    
    static let identifier = "SearchListSectionHeader"
    
    private let resultcountLabel: UILabel = {
       
        let label = UILabel()
        label.text = "Result (0)"
        
        
        return label
    }()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)

        contentView.addSubview(resultcountLabel)
        
        resultcountLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(10)
            make.top.equalToSuperview().inset(10)
            make.bottom.equalToSuperview().inset(10)
        }
        
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
}
