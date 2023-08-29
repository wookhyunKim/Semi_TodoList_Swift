//
//  LJU_TableViewCell.swift
//  TodoList_FireBase
//
//  Created by 이종욱 on 2023/08/26.
//

import UIKit

class LJU_TableViewCell: UITableViewCell {

    
    
    @IBOutlet var cell_image: UIImageView!
    
    
    @IBOutlet var cell_title: UILabel!
    
    @IBOutlet var cell_todo: UILabel!
    @IBOutlet var cell_lock: UILabel!
    
    
    @IBOutlet var cell_Btn: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
