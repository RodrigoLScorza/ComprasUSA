//
//  EstadoViewController.swift
//  RafaelAlessandro
//
//  Created by RafaelAlessandro on 15/10/17.
//  Copyright © 2017 ComprasUSA. All rights reserved.
//

import UIKit
import CoreData

enum StateType {
    case add
    case edit
}

class EstadoViewController: UIViewController {

    @IBOutlet weak var tfCotacao: UITextField!
    @IBOutlet weak var tfIof: UITextField!
    @IBOutlet weak var tableView: UITableView!
    var dataSource: [State] = []
    var produto: Product!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        loadState()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tfCotacao.text = UserDefaults.standard.string(forKey: "dolar_preference")!
        tfIof.text = UserDefaults.standard.string(forKey: "iof_preference")!
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        UserDefaults.standard.set(Double(tfCotacao.text!), forKey: "dolar_preference")
        UserDefaults.standard.set(Double(tfIof.text!), forKey: "iof_preference")
    }

    func loadState() {
        let fetchRequest: NSFetchRequest<State> = State.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "nome", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        do {
            dataSource = try context.fetch(fetchRequest)
            tableView.reloadData()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    
    @IBAction func add(_ sender: Any) {
        showAlert(type: .add, estado: nil)
    }
    
    func showAlert(type: StateType, estado: State?) {
        let title = (type == .add) ? "Adicionar" : "Editar"
        let alert = UIAlertController(title: "\(title) Adicionar Estado", message: nil, preferredStyle: .alert)
        
        alert.addTextField { (textStateField: UITextField) in
            textStateField.placeholder = "Nome do estado"
            if let name = estado?.nome {
                textStateField.text = name
            }
        }
        
        alert.addTextField { (textImpostoField: UITextField) in
            textImpostoField.placeholder = "Imposto"
            if let imposto = estado?.imposto {
                textImpostoField.text = String( imposto )
            }
        }
        
        alert.addAction(UIAlertAction(title: title, style: .default, handler: { (action: UIAlertAction) in
            let state = estado ?? State(context: self.context)
            state.nome = alert.textFields?.first?.text
            let valeu = alert.textFields![1].text
            state.imposto = Double( valeu! )!
            do {
                try self.context.save()
                self.loadState()
            } catch {
                print(error.localizedDescription)
            }
        }))
        alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}


extension EstadoViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // let state = dataSource[indexPath.row]
        let cell = tableView.cellForRow(at: indexPath)!
        if cell.accessoryType == .none {
            //cell.accessoryType = .checkmark
        } else {
            //cell.accessoryType = .none
        }
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: .destructive, title: "Excluir") { (action: UITableViewRowAction, indexPath: IndexPath) in
            let estado = self.dataSource[indexPath.row]
            self.context.delete(estado)
            try! self.context.save()
            self.dataSource.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
        
        let editAction = UITableViewRowAction(style: .normal, title: "Editar") { (action: UITableViewRowAction, indexPath: IndexPath) in
            let estado = self.dataSource[indexPath.row]
            tableView.setEditing(false, animated: true)
            self.showAlert(type: .edit, estado: estado)
        }
        editAction.backgroundColor = .blue
        return [editAction, deleteAction]
    }
        
        
}

extension EstadoViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! EstadoTableViewCell
        let estado = dataSource[indexPath.row]
        cell.lbNomeEstado?.text = estado.nome
        cell.lbImposto?.text = String( estado.imposto )
        return cell
    }
}




