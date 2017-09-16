
import UIKit
import FirebaseDatabase
import FirebaseAuth
import Firebase

class CadastroViewController: UIViewController
{
    var ref: FIRDatabaseReference!

    @IBOutlet weak var tfNome: UITextField!
    @IBOutlet weak var tfTelefone: UITextField!
    
    @IBOutlet weak var tfEmail: UITextField!
    @IBOutlet weak var tfSenha: UITextField!
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.ref = FIRDatabase.database().reference()

    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }

    @IBAction func actionCadastrar(_ sender: Any)
    {
        
        if tfTelefone.text != "" && tfTelefone.text != "" && tfTelefone.text != ""
        {
        
            FIRAuth.auth()?.createUser(withEmail: tfEmail.text!, password: tfSenha.text!) { (user, error) in
                if let user = user
                {
                
                    let email:String = user.email!
                    let nome:String = self.tfNome.text!
                    let telefone:String = self.tfTelefone.text!
                
                    let post = ["email": email,
                                "nome": nome,
                                "telefone": telefone]
                 
                    self.ref.child("cliente").child(user.uid).setValue(post, andPriority: nil) { (error, ref) in
                    
                    let alertView = UIAlertController(title: "Obrigado!", message: "Realizado com sucesso", preferredStyle: .alert)
                        alertView.addAction(UIAlertAction(title: "OK", style: .default) { (action) -> Void in

                            self.dismiss(animated: true, completion: nil)
                        })
                        self.present(alertView, animated: true, completion: nil)

                    }
                }
                else
                {

                }
            }
        
            self.navigationController?.popViewController(animated: true)
        
        }
        
        else
        {
            let alertView = UIAlertController(title: "Erro!", message: "Campos Vazios", preferredStyle: .alert)
            alertView.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            self.present(alertView, animated: true, completion: nil)
        }
        
    }
    
    @IBAction func actionCancelar(_ sender: Any)
    {
        dismiss(animated: true, completion: nil)
    }
    
}
