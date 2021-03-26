//
//  NewsTableViewCell.swift
//  TableViewTestTask
//
//  Created by  Vitalii on 25.03.2021.
//

import UIKit
import SDWebImage
import JGProgressHUD

class NewsTableViewCell: UITableViewCell {

    private let spinner = JGProgressHUD(style: .light)
    static let identifier = "newsTableViewCell"
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var urlImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    public func fill(with model: NewsModel) {
        titleLabel.text = model.title
        authorLabel.text = model.author
        descriptionLabel.text = model.description
        nameLabel.text = model.name
        idLabel.text = model.id ?? "No id"
        if let imageUrl = URL(string: model.urlToImage) {
            DispatchQueue.main.async {
                self.spinner.show(in: self.urlImageView)
                self.urlImageView.sd_setImage(with: imageUrl, completed: nil)
                self.spinner.dismiss()
            }
        }
    }
    
}
