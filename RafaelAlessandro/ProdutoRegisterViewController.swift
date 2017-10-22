//
//  ProdutoRegisterViewController.swift
//  RafaelAlessandro
//
//  Created by RafaelAlessandro on 15/10/17.
//  Copyright © 2017 ComprasUSA. All rights reserved.
//

import UIKit
import CoreData


class ProdutoRegisterViewController: UIViewController {

    @IBOutlet weak var tfNomeProduto: UITextField!
    @IBOutlet weak var ivRotulo: UIImageView!
    @IBOutlet weak var tfEstadoProduto: UITextField!
    @IBOutlet weak var tfValor: UITextField!
    @IBOutlet weak var swCartao: UISwitch!
    @IBOutlet weak var btCadastrar: UIButton!
    
    var pickerView: UIPickerView!
    var produto: Product!
    var smallImage: UIImage!
    var dataSource: [State] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        btCadastrar.isEnabled = false
        btCadastrar.backgroundColor = .gray
        
        tfNomeProduto.addTarget(self, action: #selector(editingChanged), for: .editingChanged)
        tfEstadoProduto.addTarget(self, action: #selector(editingChanged), for: .editingChanged)
        tfValor.addTarget(self, action: #selector(editingChanged), for: .editingChanged)
        
        if produto != nil{
            tfNomeProduto.text = produto.nome
            tfEstadoProduto.text = produto.states?.nome
            tfValor.text = String( produto.valor )
            swCartao.setOn(produto.cartao, animated: false)
            btCadastrar.setTitle("Atualizar", for: .normal)
            if let image = produto.rotulo as? UIImage {
                ivRotulo.image = image
            }
        }
        setupPickerView()

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(ProdutoRegisterViewController.handleTap))
        ivRotulo.addGestureRecognizer(tapGesture)
        
    }
    
    deinit {
        tfNomeProduto.removeTarget(self, action: #selector(editingChanged), for: .editingChanged)
        tfEstadoProduto.removeTarget(self, action: #selector(editingChanged), for: .editingChanged)
        tfValor.removeTarget(self, action: #selector(editingChanged), for: .editingChanged)
    }
    
    func editingChanged(_ textField: UITextField) {
        guard
            let nomeProduto = tfNomeProduto.text, !nomeProduto.isEmpty,
            let estadoProduto = tfEstadoProduto.text, !estadoProduto.isEmpty,
            let valor = tfValor.text, !valor.isEmpty
            else {
                btCadastrar.isEnabled = false
                btCadastrar.backgroundColor = .gray
                return
        }
        btCadastrar.isEnabled = true
        btCadastrar.backgroundColor = .blue
    }
    
    func close() {
        navigationController?.popViewController(animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadState()
    }
    
    func loadState() {
        let fetchRequest: NSFetchRequest<State> = State.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "nome", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        do {
            dataSource = try context.fetch(fetchRequest)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func setupPickerView() {
        pickerView = UIPickerView()
        pickerView.backgroundColor = .white
        pickerView.delegate = self
        pickerView.dataSource = self
        
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 44))
        let btCancel = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancel))
        let btSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let btDone = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
        toolbar.items = [btCancel, btSpace, btDone]

        tfEstadoProduto.inputView = pickerView
        tfEstadoProduto.inputAccessoryView = toolbar
    }
    
    func cancel() {
        tfEstadoProduto.resignFirstResponder()
    }
    
    func done() {
        tfEstadoProduto.text = dataSource[pickerView.selectedRow(inComponent: 0)].nome
        cancel()
    }

    func handleTap() {
        let alert = UIAlertController(title: "Selecionar poster", message: "De onde você quer escolher o poster?", preferredStyle: .actionSheet)
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let cameraAction = UIAlertAction(title: "Câmera", style: .default, handler: { (action: UIAlertAction) in
                self.selectPicture(sourceType: .camera)
            })
            alert.addAction(cameraAction)
        }
        
        let libraryAction = UIAlertAction(title: "Biblioteca de fotos", style: .default) { (action: UIAlertAction) in
            self.selectPicture(sourceType: .photoLibrary)
        }
        alert.addAction(libraryAction)
        
        let photosAction = UIAlertAction(title: "Álbum de fotos", style: .default) { (action: UIAlertAction) in
            self.selectPicture(sourceType: .savedPhotosAlbum)
        }
        alert.addAction(photosAction)
        
        let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    func selectPicture(sourceType: UIImagePickerControllerSourceType) {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = sourceType
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
    }
   
    @IBAction func addProduto(_ sender: Any) {
        if produto == nil { produto = Product(context: context) }
        produto.nome = tfNomeProduto.text
        produto.rotulo = ivRotulo.image
        if let indexState = dataSource.index(where: { $0.nome  == tfEstadoProduto.text!}) {
            produto.states = dataSource[indexState]
        }
        produto.valor = Double( tfValor.text! )!
        produto.cartao = swCartao.isOn
        if smallImage != nil {
            produto.rotulo = smallImage
        }
        do {
            try context.save()
            close()
        } catch {
            print(error.localizedDescription)
            close()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func addEstado(_ sender: Any) {}
}

extension ProdutoRegisterViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String: AnyObject]?) {
        
        let smallSize = CGSize(width: 300, height: 280)
        UIGraphicsBeginImageContext(smallSize)
        image.draw(in: CGRect(x: 0, y: 0, width: smallSize.width, height: smallSize.height))
        smallImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        ivRotulo.image = smallImage
        dismiss(animated: true, completion: nil)
    }
}

extension ProdutoRegisterViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return dataSource[row].nome
    }
}

extension ProdutoRegisterViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return dataSource.count
    }
}
