
import UIKit
import Firebase

class ViewController: UIViewController
{

    @IBOutlet weak var btLogin: UIButton!
    override func viewDidLoad()
    {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool)
    {
        if let user = FIRAuth.auth()?.currentUser
        {
            logout()
        }
        else
        {
            login()
        }

    }
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    

    @IBAction func logout(_ sender: AnyObject)
    {
        if let user = FIRAuth.auth()?.currentUser
        {
            do{
                try FIRAuth.auth()?.signOut()
                login()
            }catch{
            }
        }
        else
        {
            self.performSegue(withIdentifier: "SegueLoginExtern", sender: self)
        }
    }
    
    func login()
    {
        btLogin.setTitle("Login", for: .normal)
        btLogin.tintColor  = UIColor(colorLiteralRed: 0.17, green: 0.28, blue: 0.59, alpha: 1.0)
    }
    func logout()
    {
        btLogin.setTitle("Sair", for: .normal)
        btLogin.tintColor  = UIColor.red
    }
    
    

}

