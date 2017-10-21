//
//  EstadoTableViewCell.swift
//  RafaelAlessandro
//
//  Created by Rafael Valverde on 19/10/17.
//  Copyright © 2017 ComprasUSA. All rights reserved.
//

import UIKit

class EstadoTableViewCell: UITableViewCell {

    @IBOutlet weak var lbNomeEstado: UILabel!
    @IBOutlet weak var lbImposto: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
