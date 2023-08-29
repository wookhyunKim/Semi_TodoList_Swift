//
//  KangTableViewCell.swift
//  Semi-Sqlite-TodoList
//
//  Created by 맥찡 on 2023/08/27.
//

import UIKit

class KangTableViewCell: UITableViewCell {

    
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblInsertDate: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
