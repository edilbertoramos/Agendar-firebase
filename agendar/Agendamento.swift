
import UIKit

class Agendamento: NSObject
{
    var id:String!
    var data:String!
    var hr_inicio:String!
    var profisional:Profissional!
    var servico:Servico!
    
    init(id:String, data:String, hr_inicio:String, servico: Servico, profissional:Profissional)
    {
        self.id = id;
        self.data = data;
        self.hr_inicio = hr_inicio;
        self.servico = servico
        self.profisional = profissional;
        
        print("\nCreated Agendamento with Id: \(id), data: \(data), hr_inicio: \(hr_inicio), servicoId: \(servico.id as! String) profisisonalId: \(profissional.id as! String)")
    }
    
    deinit
    {
        self.id = nil;
        self.data = nil;
        self.hr_inicio = nil;
        self.servico = nil;
        //self.profisionalId = nil;
        //self.servicoId = nil;
    }

}
