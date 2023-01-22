//
//  cellA.swift
//  faiaz_rahman_30024_LOCAL_PERSISTENT
//
//  Created by Faiaz Rahman on 8/1/23.
//

import UIKit

class cellA: UITableViewCell {

    @IBOutlet weak var name: UILabel!
    
    @IBOutlet weak var album: UILabel!
    
    @IBOutlet weak var cellViewC: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
