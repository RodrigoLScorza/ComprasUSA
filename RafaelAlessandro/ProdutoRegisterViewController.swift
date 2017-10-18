//
//  ProdutoRegisterViewController.swift
//  RafaelAlessandro
//
//  Created by RafaelAlessandro on 15/10/17.
//  Copyright © 2017 ComprasUSA. All rights reserved.
//

import UIKit

class ProdutoRegisterViewController: UIViewController {
    
    var produto: Product!
    var smallImage: UIImage!

    @IBOutlet weak var tfNomeProduto: UITextField!
    @IBOutlet weak var ivRotulo: UIImageView!
    @IBOutlet weak var tfEstadoProduto: UITextField!
    @IBOutlet weak var tfValor: UITextField!
    @IBOutlet weak var swCartao: UISwitch!
    @IBOutlet weak var btCadastrar: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if produto != nil{
            tfNomeProduto.text = produto.nome
//            tfEstadoProduto.text = produto.estados?.description
            tfValor.text = String( produto.valor )
            swCartao.setOn(produto.cartao, animated: false)
            btCadastrar.setTitle("Atualizar", for: .normal)
            if let image = produto.rotulo as? UIImage {
                ivRotulo.image = image
            }
        }
//

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(ProdutoRegisterViewController.handleTap))
        ivRotulo.addGestureRecognizer(tapGesture)
        
    }

    func handleTap() {
        //Criando o alerta que será apresentado ao usuário
        let alert = UIAlertController(title: "Selecionar poster", message: "De onde você quer escolher o poster?", preferredStyle: .actionSheet)
        
        //Verificamos se o device possui câmera. Se sim, adicionamos a devida UIAlertAction
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let cameraAction = UIAlertAction(title: "Câmera", style: .default, handler: { (action: UIAlertAction) in
                self.selectPicture(sourceType: .camera)
            })
            alert.addAction(cameraAction)
        }
        
        //As UIAlertActions de Biblioteca de fotos e Álbum de fotos também são criadas e adicionadas
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
        //Criando o objeto UIImagePickerController
        let imagePicker = UIImagePickerController()
        
        //Definimos seu sourceType através do parâmetro passado
        imagePicker.sourceType = sourceType
        
        //Definimos a MovieRegisterViewController como sendo a delegate do imagePicker
        imagePicker.delegate = self
        
        //Apresentamos a imagePicker ao usuário
        present(imagePicker, animated: true, completion: nil)
    }
    
    
    
    @IBAction func addProduto(_ sender: Any) {
        if produto == nil { produto = Product(context: context) }
        
        produto.nome = tfNomeProduto.text
        produto.rotulo = ivRotulo.image
        produto.valor = Double( tfValor.text! )!
        produto.cartao = swCartao.isOn
        if smallImage != nil {
            produto.rotulo = smallImage
        }
        
        do {
            try context.save()
        } catch {
            print(error.localizedDescription)
            closeCadastro()
        }
        
        closeCadastro()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }

    @IBAction func addEstado(_ sender: Any) {
        
    }
    
    func closeCadastro() {
        dismiss(animated: true, completion: nil)
    }
    
}

extension ProdutoRegisterViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    //O método abaixo nos trará a imagem selecionada pelo usuário em seu tamanho original
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String: AnyObject]?) {
        
        //Iremos usar o código abaixo para criar uma versão reduzida da imagem escolhida pelo usuário
        let smallSize = CGSize(width: 300, height: 280)
        UIGraphicsBeginImageContext(smallSize)
        image.draw(in: CGRect(x: 0, y: 0, width: smallSize.width, height: smallSize.height))
        
        //Atribuímos a versão reduzida da imagem à variável smallImage
        smallImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        ivRotulo.image = smallImage //Atribuindo a imagem à ivPoster
        
        //Aqui efetuamos o dismiss na UIImagePickerController, para retornar à tela anterior
        dismiss(animated: true, completion: nil)
    }
}
