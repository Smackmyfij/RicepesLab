//
//  RicepesTableViewCell.swift
//  RicepesLab
//
//  Created by Dmitriy Yurchenko on 01.09.17.
//  Copyright © 2017 DYFiJ. All rights reserved.
//

import UIKit

class RicepesTableViewCell: UITableViewCell {
    @IBOutlet weak var recipeTitleLabel: UILabel!
    @IBOutlet weak var recipeImage: UIImageView!
    @IBOutlet weak var labelDescription: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        recipeImage.layer.cornerRadius = recipeImage.frame.size.width / 2
        recipeImage.clipsToBounds = true
        recipeImage.contentMode = .scaleAspectFill
                // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
