//
//  ProdutoTableViewCell.swift
//  RafaelAlessandro
//
//  Created by RafaelAlessandro on 15/10/17.
//  Copyright © 2017 ComprasUSA. All rights reserved.
//

import UIKit

class ProdutoTableViewCell: UITableViewCell {
    
    @IBOutlet weak var lbNomeProduto: UILabel!
    @IBOutlet weak var lbEstado: UILabel!
    @IBOutlet weak var lbValor: UILabel!
    @IBOutlet weak var lbPagamento: UILabel!
    @IBOutlet weak var ivRotulo: UIImageView!
    @IBOutlet weak var swCartao: UISwitch!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
