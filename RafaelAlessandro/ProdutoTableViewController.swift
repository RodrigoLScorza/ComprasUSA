//
//  ProdutoTableViewController.swift
//  RafaelAlessandro
//
//  Created by RafaelAlessandro on 15/10/17.
//  Copyright © 2017 ComprasUSA. All rights reserved.
//

import UIKit
import CoreData

class ProdutoTableViewController: UITableViewController {
    
    var label = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 22))
    var fetchedResultController: NSFetchedResultsController<Product>!

    override func viewDidLoad() {
        super.viewDidLoad()
        loadProdutos()
        
        tableView.estimatedRowHeight = 106
        tableView.rowHeight = UITableViewAutomaticDimension
        
        label.text = "Sua lista está vazia!"
        label.textAlignment = .center
        label.textColor = .white

    }
    
    func loadProdutos() {
        let fetchRequest: NSFetchRequest<Product> = Product.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "nome", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        fetchedResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultController.delegate = self
        do {
            try fetchedResultController.performFetch()
        } catch {
            print(error.localizedDescription)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 148
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let count = fetchedResultController.fetchedObjects?.count {
            tableView.backgroundView = (count == 0) ? label : nil
            return count
        } else {
            tableView.backgroundView = label
            return 0
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "produtoCell", for: indexPath) as! ProdutoTableViewCell
        let produto = fetchedResultController.object(at: indexPath)

        cell.lbNomeProduto.text = produto.nome
        cell.lbValor.text =  produto.valor.description
        cell.lbEstado.text = produto.states?.nome
        cell.swCartao.setOn(produto.cartao, animated: false)
        if let image = produto.rotulo as? UIImage {
            cell.ivRotulo.image = image
        } else {
            cell.ivRotulo.image = nil
        }
        return cell
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        let produto = fetchedResultController.object(at: indexPath)
        context.delete(produto)
        do {
            try context.save()
        } catch {
            print(error.localizedDescription)
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? ProdutoRegisterViewController {
            if tableView.indexPathForSelectedRow != nil {
                vc.produto = fetchedResultController.object(at: tableView.indexPathForSelectedRow!)
            }
        }
    }

}
extension ProdutoTableViewController: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.reloadData()
    }
}
