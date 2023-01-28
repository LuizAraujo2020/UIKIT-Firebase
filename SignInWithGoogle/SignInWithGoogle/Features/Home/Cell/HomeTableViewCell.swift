//
//  HomeTableViewCell.swift
//  SignInWithGoogle
//
//  Created by Luiz Araujo on 27/01/23.
//

import UIKit

class HomeTableViewCell: UITableViewCell {
    
    static let identifier = "HomeTableViewCell"
    
    /// Stack with the name of the user and the timestamp of the message.
    @IBOutlet weak var stackHeader: UIStackView!
    
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelTime: UILabel!
    @IBOutlet weak var labelText: UILabel!
    
    init(message: Message) {
        super.init(style: .subtitle, reuseIdentifier: HomeTableViewCell.identifier)
        self.labelName.text = message.name
        self.labelTime.text = String(message.id.getDateFromStringTimestamp().debugDescription)
        self.labelText.text = message.text
    }
    
    init(stackHeader: UIStackView!,
         labelName: UILabel!,
         labelTime: UILabel!,
         labelText: UILabel!) {
        super.init(style: .subtitle, reuseIdentifier: HomeTableViewCell.identifier)
        
        self.stackHeader = stackHeader
        self.labelName   = labelName
        self.labelTime   = labelTime
        self.labelText   = labelText
    }
    
    /// Initialization code
    override func awakeFromNib() {
        super.awakeFromNib()
        
        stackHeader.isHidden = true
        Bundle.main.loadNibNamed(HomeTableViewCell.identifier, owner: self)
        
    }

    /// Configure the view for the selected state.
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        stackHeader.isHidden.toggle()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
