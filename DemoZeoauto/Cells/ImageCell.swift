//
//  ImageCell.swift
//  DemoZeoauto
//
//  Created by Jeegnesh Solanki on 08/03/25.
//

import UIKit

class ImageCell: UICollectionViewCell {

    
    @IBOutlet weak var actLoader: UIActivityIndicatorView!
    @IBOutlet weak var imgView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        imgView.contentMode = .scaleAspectFill
        imgView.clipsToBounds = true
        actLoader.hidesWhenStopped = true
    }
}

