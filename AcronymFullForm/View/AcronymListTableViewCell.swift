//
//  AcronymListTableViewCell.swift
//  AcronymFullForm
//
//  Created by hscuser on 02/06/21.
//

import UIKit

class AcronymListTableViewCell: UITableViewCell {

    @IBOutlet weak var lblFullForm: UILabel!
    var indexPath: IndexPath?
    var acronymModel: AcronymModel? {
        didSet{
            setFullForm()
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    static var identifier: String {
        return String(describing: self)
    }
    static var nib: UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
    func setFullForm()  {
        lblFullForm.text = acronymModel?.lfs![indexPath?.row ?? 0].lf
    }
}
