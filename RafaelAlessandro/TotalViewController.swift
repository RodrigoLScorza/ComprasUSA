//
//  TotalViewController.swift
//  RafaelAlessandro
//
//  Created by Usuário Convidado on 22/10/17.
//  Copyright © 2017 ComprasUSA. All rights reserved.
//

import UIKit
import CoreData

var dataSource: [Product] = []
let DOLLAR_PREFERENCE = "dolar_preference"

class TotalViewController: UIViewController {

    @IBOutlet weak var lbTotalDolar: UILabel!
    @IBOutlet weak var lbTotalReal: UILabel!
    
    var cotacao: Double = 0
    var iof: Double = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // Do any additional setup after loading the view.
        loadProdutos()
        var totalGrossValue: Double = 0
        var totalNetValue: Double = 0
        for product in dataSource {
            totalGrossValue += product.valor
            totalNetValue += calculateNetValue(product)
        }
        
        lbTotalDolar.text = String( totalGrossValue )
        lbTotalReal.text = String( totalNetValue )
    }
    
    func loadProdutos() {
        let fetchRequest: NSFetchRequest<Product> = Product.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "nome", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        do {
            dataSource = try context.fetch(fetchRequest)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func calculateNetValue(_ product: Product) -> Double {
        let cotacao = UserDefaults.standard.double(forKey: DOLLAR_PREFERENCE)
        let iof = UserDefaults.standard.double(forKey: "iof_preference")
        let realValue = (product.valor * cotacao)
        let netValue = realValue * (1 + product.states!.imposto/100)
        
        return product.cartao ? netValue * (1 + iof/100) : netValue
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
