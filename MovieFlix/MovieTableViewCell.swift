//
//  MovieTableViewCell.swift
//  MovieFlix
//
//  Created by Yeasir Arefin Tusher on 27/12/22.
//

import UIKit

class MovieTableViewCell: UITableViewCell {
    
    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var movieDescription: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(title: String?, description: String?) {
        movieTitle.text = title
        movieDescription.text = description
    }
}
