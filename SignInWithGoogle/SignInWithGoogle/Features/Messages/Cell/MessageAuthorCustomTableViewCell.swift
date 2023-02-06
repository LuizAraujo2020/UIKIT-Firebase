//
//  MessageAuthorCustomTableViewCell.swift
//  SignInWithGoogle
//
//  Created by Luiz Araujo on 03/02/23.
//

import UIKit

class MessageAuthorCustomTableViewCell: UITableViewCell {
    
    static let identifier = "MessageAuthorCustomTableViewCell"
    
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var subtitle: UILabel!
    @IBOutlet weak var background: UIView!
    @IBOutlet weak var backgroundDetail: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.addRoundedCornerToView(targetView: background)
        backgroundDetail.transform = CGAffineTransform(rotationAngle: 15.0)

    }
    
    static func nib() -> UINib {
        return UINib(nibName: "MessageAuthorCustomTableViewCell", bundle: nil)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(title: String, subtitle: String) {
        self.title.text = title
        self.subtitle.text = subtitle
    }
}
