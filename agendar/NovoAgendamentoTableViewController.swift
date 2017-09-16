
import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth

class NovoAgendamentoTableViewController: UITableViewController, UITextFieldDelegate,UIPickerViewDelegate, UIPickerViewDataSource, UICollectionViewDataSource, UICollectionViewDelegate
{
    @IBOutlet weak var tfServico: UITextField!
    @IBOutlet weak var tfData: UITextField!
    @IBOutlet weak var tfProfissional: UITextField!
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var btAgendar: UIButton!
    @IBOutlet weak var btItemAgendar: UIBarButtonItem!
    
    @IBOutlet weak var lbDuracao: UILabel!
    
    var servicos:[Servico] = []
    
    //array de horários
    private var horarioDisponivel:[HorarioDisponivel] = []
    private var horarioDisponivel_aux:[HorarioDisponivel] = []
    private var hr_select = ""
    
    //numero de serviços
    var rowServico = 0
    var rowProfissional = 0
    var rowData = 0
    
    //pickers
    var pickerViewServico =  UIPickerView()
    var pickerViewProfissional =  UIPickerView()
    var pickerViewData = UIDatePicker()
    let toolBar = UIToolbar()

    static var agendar = false
    
    var ref: FIRDatabaseReference!

    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        //NotificationCenter.default.addObserver(self, selector: Selector(("atualizaProfissional:")), name: NSNotification.Name(rawValue: "test"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(NovoAgendamentoTableViewController.atualizaProfissional), name: NSNotification.Name(rawValue: "test"), object: nil)

    
        horarioDisponivel = NSDate().gera_horarios(hr_inicio: "08:00", hr_fim: "19:00")

        
        self.ref = FIRDatabase.database().reference()

        self.ref.child("servico").observe(.value, with: { (snapServico) in
            
            for servicoId in ((snapServico.valueInExportFormat() as? NSDictionary)?.allKeys)!
            {
                let servico = ((snapServico.valueInExportFormat() as? NSDictionary)?.value(forKey: servicoId as! String)) as! NSDictionary
               
                let nomeServico = servico["nome"] as! String
                let blocos = servico["blocos"] as! NSNumber
                let valor = servico["valor"] as! NSNumber
                let profissionaisId = (servico["profissionais"] as! NSDictionary).allKeys as! NSArray
                let objectServico = Servico(id: servicoId as! String, nome: nomeServico, blocos: blocos, valor: valor, profissionais: [])
                
                self.servicos.append(objectServico)
                self.servicos.sort(by: { $0.nome < $1.nome })
                for profissionalId in profissionaisId
                {

                    self.ref.child("profissional/\(profissionalId)").observe(.value, with: { (snap) in
                        
                        let profissional = snap.valueInExportFormat() as! NSDictionary
                        let nomeProfisional = profissional["nome"] as! String
                        let funcao = profissional["funcao"] as! String
                        
                        objectServico.profissionais.append(Profissional(id: profissionalId as! String, funcao: funcao, nome: nomeProfisional))
                        
                        self.pickerViewServico.reloadInputViews()
                    })
                }
            }
        })
        setProperties()
    }
    
    func test()
    {
        print("\n\n\ntest\n\n\n")
        if tfData.text != "" && tfProfissional.text != "" && tfServico.text != ""
        {
            print("\n\n\nCampos Preenchidos\n\n\n")

            ref.child("agendamento").queryOrdered(byChild: "data").queryEqual(toValue: self.tfData.text!).observe(.value, with: { (snap) in
                if snap.exists()
                {
                    print("\n\n\nHá agendamentos hoje\n\n\n")
                    
                    for agendamentoId in ((snap.valueInExportFormat() as? NSDictionary)?.allKeys)!
                    {
                        let agendamento = ((snap.valueInExportFormat() as? NSDictionary)?.value(forKey: agendamentoId as! String)) as! NSDictionary
                        
                        let hr_inicio = agendamento["hr_inicio"] as! String
                        let profissionalId = agendamento["profissional"] as! NSNumber
                        let servicoId = agendamento["servico"] as! NSNumber
                        self.horarioDisponivel_aux = []
                        
                        if profissionalId.stringValue == self.servicos[self.rowServico].profissionais[self.rowProfissional].id
                        {
                            print("\n\n\nHá agendamentos com esse profissional\n\n\n")
                         
                            for servico in self.servicos
                            {
                                if servico.id == servicoId.stringValue
                                {
                                    let blocos = servico.blocos
                                    self.horarioDisponivel = NSDate().edita_horarios(hr_inicio_ag: hr_inicio, blocos_ag: blocos!, horarios: self.horarioDisponivel, blocos_servico: self.servicos[self.rowServico].blocos)
                                    
                                    print("\n\n\n\n\n\n")
                                    print(hr_inicio)
                                    print(NSDate().hr_final(hr_inicial: hr_inicio, blocos: blocos!))
                                    
                                    self.collectionView.reloadData()
                                }
                            }
                        }
                        else
                        {
                            print("\n\n\nNão há agendamentos com esse profissional\n\n\n")
                            self.reloadHorarios()
                        }
                    }
                }
                else
                {
                    print("Nenhum agendamento nesta data")
                    self.reloadHorarios()
                }
            })
        }
        else
        {
            print("\n\n\nCampos Vazios\n\n\n")
            
        }
    }
    
    func reloadHorarios()
    {
        horarioDisponivel = NSDate().gera_horarios(hr_inicio: "08:00", hr_fim: "19:00")
        collectionView.reloadData()
    }
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    func setProperties()
    {
        //ordena arrray
        horarioDisponivel.sort(by: { $0.horario < $1.horario })

        //Propriedades
        tfServico.delegate = self
        tfProfissional.delegate = self
        tfData.delegate = self
        tfServico.inputView = pickerViewServico
        tfProfissional.inputView = pickerViewProfissional
        tfData.inputView = pickerViewData
        tfServico.inputAccessoryView = toolBar
        tfProfissional.inputAccessoryView = toolBar
        tfData.inputAccessoryView = toolBar
        pickerViewServico.delegate = self
        pickerViewServico.dataSource = self
        pickerViewProfissional.delegate = self
        pickerViewProfissional.dataSource = self
        
        pickerViewData.locale = Locale(identifier: "PT-br")
        pickerViewData.datePickerMode = UIDatePickerMode(rawValue: 1)!
//        pickerViewData.minimumDate = NSDate.
        tfServico.layer.cornerRadius = 5
        tfProfissional.layer.cornerRadius = 5
        tfData.layer.cornerRadius = 5
        pickerViewServico.backgroundColor = UIColor.white
        pickerViewProfissional.backgroundColor = UIColor.white
        pickerViewData.backgroundColor = UIColor.white
        //btAgendar.backgroundColor = UIColor.blue

        //create toolbar
        let okButton = UIBarButtonItem(title: "OK", style: UIBarButtonItemStyle.plain, target: self, action: #selector(NovoAgendamentoTableViewController.okPicker))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.sizeToFit()
        toolBar.setItems([spaceButton, okButton], animated: false)
        toolBar.isUserInteractionEnabled = true

        //add tap
        pickerViewData.addTarget(self, action: #selector(NovoAgendamentoTableViewController.scrollData), for: .valueChanged)
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(NovoAgendamentoTableViewController.dismissKeyboard)))
    }

    
    // MARK: - PickerView
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int
    {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
    {
        
        if pickerView ==  pickerViewServico
        {
            tfServico.text = servicos[rowServico].nome
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "test"), object: nil)
            return servicos.count
        }
        if pickerView ==  pickerViewProfissional
        {
            tfProfissional.text = servicos[rowServico].profissionais[rowProfissional].nome
            return servicos[rowServico].profissionais.count
        }
        
        return 0
    }
    
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if pickerView ==  pickerViewServico
        {
            rowServico = row
            tfServico.text = servicos[row].nome
            lbDuracao.text = NSDate().duracao(blocos: servicos[row].blocos)
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "test"), object: nil)
        }
        if pickerView ==  pickerViewProfissional
        {
            rowProfissional = row
            tfProfissional.text = servicos[rowServico].profissionais[row].nome
        }

    }
    
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString?
    {

        var titleData = ""
        if pickerView ==  pickerViewServico
        {
            titleData = servicos[row].nome
            lbDuracao.text = NSDate().duracao(blocos: servicos[row].blocos)
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "test"), object: nil)
        }
        if pickerView ==  pickerViewProfissional
        {
            titleData = servicos[rowServico].profissionais[row].nome
        }

        return NSAttributedString(string: titleData, attributes: [NSFontAttributeName:UIFont(name: "Courier", size: 15.0)!,NSForegroundColorAttributeName:UIColor(colorLiteralRed: 0, green: 0, blue: 0, alpha: 0.5)])
    }
    
    func scrollData()
    {
        atualizaData()
    }
    
    func atualizaData()
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        dateFormatter.locale = Locale(identifier: "PT-br")
        let strDate = dateFormatter.string(from: pickerViewData.date)
        self.tfData.text = strDate.capitalized
        test()
        
    }
    
    func atualizaProfissional()
    {
        pickerViewProfissional.reloadAllComponents()
        test()
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        
        pickerViewServico.isHidden = true
        pickerViewProfissional.isHidden = true
        pickerViewData.isHidden = true
    }
    
    // essa função remove a pickerView e a toolbar quando o usuario escolhe a opcao desejada
    func okPicker()
    {
        
        pickerViewServico.removeFromSuperview()
        pickerViewProfissional.removeFromSuperview()
        pickerViewData.removeFromSuperview()
        toolBar.removeFromSuperview()
        tfServico.resignFirstResponder()
        tfData.resignFirstResponder()
        atualizaData()
    }
    
    
    
    
    // MARK: - TextField
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        return true
    }
    
    func dismissKeyboard()
    {
        view.endEditing(true)
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {return 1}
    func numberOfComponents(in pickerView: UIPickerView) -> Int {return 1}
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {return 4}
    

    
    // MARK: - CollectionView ---------------
    
    func numberOfSections(in collectionView: UICollectionView) -> Int
    {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return horarioDisponivel.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HoraDisponivelCell", for: indexPath) as! HorarioDisponivelCollectionViewCell
        let tapGestureRecognizer = UITapGestureRecognizer(target:self, action:#selector(NovoAgendamentoTableViewController.selectHour))
        
        cell.layer.borderWidth = 0
        cell.layer.cornerRadius = 3
        cell.layer.borderColor = UIColor.blue.cgColor
        cell.lbHorario.text = horarioDisponivel[indexPath.row].horario
        cell.lbHorario.isUserInteractionEnabled = true
        cell.lbHorario.addGestureRecognizer(tapGestureRecognizer)
        
        
        if horarioDisponivel[indexPath.row].marcado == true
        {
            cell.backgroundColor = UIColor(red:0.17, green:0.41, blue:0.61, alpha:1.0)
            cell.lbHorario.textColor = UIColor.white
        }
        else
        {
            cell.backgroundColor = UIColor.white
            cell.lbHorario.textColor = UIColor.black
        }
        if horarioDisponivel[indexPath.row].habilitado == false
        {
            print(horarioDisponivel[indexPath.row].habilitado)
            cell.backgroundColor = UIColor.red
            cell.lbHorario.textColor = UIColor.white
        }

        
        return cell
    }
    
    func selectHour(sender: UITapGestureRecognizer)
    {
        let indexPath = indexPah(sender: sender.view!)
        self.hr_select = (self.collectionView.cellForItem(at: indexPath as IndexPath) as! HorarioDisponivelCollectionViewCell).lbHorario.text!
        if horarioDisponivel[indexPath.row].habilitado == true
        {        
            horarioDisponivel = HorarioDisponivelStore().habilita(array: horarioDisponivel, marcado: horarioDisponivel[indexPath.row])
            collectionView.reloadData()
        }
    }
    
    func indexPah(sender: AnyObject) -> NSIndexPath
    {
        let position: CGPoint = sender.convert(CGPoint.zero, to: self.collectionView)
        return self.collectionView.indexPathForItem(at: position)! as NSIndexPath
    }

    @IBAction func btItemAgendarAction(_ sender: AnyObject)
    {
        
    }
    
    @IBAction func btAgendarAction(_ sender: AnyObject)
    {
        let user = FIRAuth.auth()?.currentUser
        
        if user != nil
        {
            print("\n\n\n\n---")
            print(user)

            agenda(user: user!)
        } else
        {
            NovoAgendamentoTableViewController.agendar = true
            self.performSegue(withIdentifier: "SegueLogin", sender: nil)
        }
    }
    
    func agenda(user:FIRUser)
    {
        let hr_inicio:String = self.hr_select
        let p:Int = Int(self.servicos[self.rowServico].profissionais[self.rowProfissional].id)!
        let s:Int = Int(self.servicos[self.rowServico].id)!
        let data:String = self.tfData.text!
       
        
        let post = ["cliente": user.uid,
                    "data": data,
                    "hr_inicio": hr_inicio,
                    "profissional":  p,
                    "servico": s] as [String : Any]
        
        self.ref.child("agendamento").childByAutoId().setValue(post, andPriority: nil) { (error, ref) in
            
            if error == nil
            {
                let alert = UIAlertController.init(title: "Obrigado", message: "Agendamento bem sucedido", preferredStyle: UIAlertControllerStyle.alert)
                
      
                let ok = UIAlertAction.init(title: "Ok", style: .default, handler: { (action) in
                    self.navigationController?.popViewController(animated: true)
                })
                alert.addAction(ok)
                self.present(alert, animated: true, completion: nil)
            }
            
        }
    }
    

     // MARK: - Navigation
     
     override func prepare(for segue: UIStoryboardSegue, sender: Any?)
     {
     }
}
