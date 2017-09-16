
import UIKit
import FirebaseDatabase
import FirebaseAuth
import Firebase

class LoginViewController: UIViewController
{

    @IBOutlet weak var tfEmail: UITextField!
    @IBOutlet weak var senhaEmail: UITextField!
    
    var ref: FIRDatabaseReference!

    override func viewDidLoad()
    {
        self.ref = FIRDatabase.database().reference()

        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func logginAction(_ sender: AnyObject)
    {
        
        FIRAuth.auth()?.signIn(withEmail: tfEmail.text!, password: senhaEmail.text!, completion: { (user, error) in
            
            if let user = user
            {
                let email:String = user.email!
                let post = ["email": email, "nome": "Nome", "telefone": "(92) 99009-9009"]
                
                self.ref.child("cliente").child(user.uid).setValue(post, andPriority: nil) { (error, ref) in
                    self.navigationController?.popToRootViewController(animated: true)
                }
            }
            else
            {
                print("\n\n\ngfgfgfgf\n\n\n\n")
                print(user?.email)
            }
            self.navigationController?.popViewController(animated: true)

        })
        
        /*
        FIRAuth.auth()?.createUser(withEmail: tfEmail.text!, password: senhaEmail.text!) { (user, error) in
            if let user = user {
                let email:String = user.email!
                let post = ["email": email,
                            "nome": "Nome",
                            "telefone": "(92) 99009-9009"]
                
                self.ref.child("cliente").child(user.uid).setValue(post, andPriority: nil) { (error, ref) in
                    self.navigationController?.popToRootViewController(animated: true)
                }
            }
            else
            {
                print("\n\n\ngfgfgfgf\n\n\n\n")
                print(user?.email)
            }
        }
        self.navigationController?.popViewController(animated: true)
        */
    }

    @IBAction func resetPassword(_ sender: AnyObject)
    {
        var email: UITextField?
        let alertView = UIAlertController(title: "Recuperação de Senha", message: "Informe seu email de acesso:", preferredStyle: .alert)
        alertView.addTextField { (text) -> Void in
            email = text
            email?.text = self.tfEmail.text
            email!.placeholder = "email@email.com"
            email!.keyboardType = UIKeyboardType.emailAddress
        }
        alertView.addAction(UIAlertAction(title: "Cancelar", style: .cancel, handler: nil))
        alertView.addAction(UIAlertAction(title: "OK", style: .default) { (action) -> Void in
            FIRAuth.auth()?.sendPasswordReset(withEmail: (email?.text)!, completion: { (error) in
                    
                    var message: String = ""
                    if error == nil
                    {
                        message = "Verifique seu email:\n\n"+email!.text!
                    }
                    else
                    {
                        message = "Erro"
                    }
                    let alertView = UIAlertController(title: "Recuperação de Senha", message: message, preferredStyle: .alert)
                    alertView.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                    self.present(alertView, animated: true, completion: nil)
                })

            })
        self.present(alertView, animated: true, completion: nil)

        }
    
    @IBAction func actionCadastro(_ sender: Any)
    {
        performSegue(withIdentifier: "SegueCadastro", sender: nil)
    }
    
}
