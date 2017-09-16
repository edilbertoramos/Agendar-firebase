
import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth


class AgendamentosTableViewController: UITableViewController
{
    var ref: FIRDatabaseReference!

    private var dadosAgendamento:[Agendamento] = []
    private var aux:[Agendamento] = []

    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.ref = FIRDatabase.database().reference()
        
        ref.child("cliente").queryEqual(toValue: FIRAuth.auth()?.currentUser?.uid).observe(.value, with: { (snap) in

            if let user = FIRAuth.auth()?.currentUser
            {
            
                self.ref.child("agendamento").queryOrdered(byChild: "cliente").queryEqual(toValue: user.uid).observe(.value, with: { (snap) in
                    
                    self.dadosAgendamento = []
                    
                    if snap.valueInExportFormat() as? NSDictionary != nil
                    {
                        for agendamentoId in ((snap.valueInExportFormat() as? NSDictionary)?.allKeys)!
                        {
                            
                            let agendamento = ((snap.valueInExportFormat() as? NSDictionary)?.value(forKey: agendamentoId as! String)) as! NSDictionary
                        
                            let data = agendamento["data"] as! String
                            let hr_inicio = agendamento["hr_inicio"] as! String
                            let profissionalId = agendamento["profissional"] as! NSNumber
                            let servicoId = agendamento["servico"] as! NSNumber
                            
                            
                            self.ref.child("servico/\(servicoId)").observe(.value, with: { (snap) in
                                let servico = snap.valueInExportFormat() as! NSDictionary
                                let nomeServico = servico["nome"] as! String
                                let blocos = servico["blocos"] as! NSNumber
                                let valor = servico["valor"] as! NSNumber
                                
                                
                                self.ref.child("profissional/\(profissionalId)").observe(.value, with: { (snap) in
                                    
                                    let profissional = snap.valueInExportFormat() as! NSDictionary
                                    let nomeProfisional = profissional["nome"] as! String
                                    let funcao = profissional["funcao"] as! String
                                    
                                    
                                    
                                    self.dadosAgendamento.append(Agendamento(id: agendamentoId as! String, data: data, hr_inicio: hr_inicio, servico: Servico(id: servicoId.stringValue, nome: nomeServico, blocos: blocos, valor: valor, profissionais: []), profissional:Profissional(id: profissionalId.stringValue, funcao: funcao, nome: nomeProfisional)))

                                    self.dadosAgendamento.sort(by: { $0.data < $1.data })

                                    self.tableView.reloadData()
                                    
                                })
                            })
                        }
                    }
                    else
                    {
                        self.performSegue(withIdentifier: "SegueNovoAgendamento2", sender: nil)
                    }
                })
            }
            else
            {
                self.performSegue(withIdentifier: "SegueNovoAgendamento2", sender: nil)
            }

        })
    }
    
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return dadosAgendamento.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AgendamentoCell") as! AgendamentosTableViewCell
        
        let dados = dadosAgendamento[indexPath.row]
        
        
        cell.lbData.text = dados.data
        cell.lbServico.text = dados.servico.nome.capitalized
        cell.lbHoraInicial.text = dados.hr_inicio
        cell.lbProfissional.text = dados.profisional.nome
        cell.lbPreco.text = "R$ \(dados.servico.valor.stringValue), 00"
        cell.lbHoraFinal.text = NSDate().hr_final(hr_inicial: dados.hr_inicio, blocos: dados.servico.blocos)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        print(indexPath.row)
    }
    
    override func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String?
    {
        return "123"
    }
    
    @IBAction func novoAction(_ sender: AnyObject)
    {
        performSegue(withIdentifier: "SegueNovoAgendamento2", sender: nil)
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
    }
}
