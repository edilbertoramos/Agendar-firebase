
import UIKit

class Servico: NSObject
{
    var id:String!
    var blocos:NSNumber!
    var nome:String!
    var valor:NSNumber!
    var profissionais:[Profissional]
    
    init(id:String, nome:String, blocos:NSNumber, valor:NSNumber, profissionais:[Profissional])
    {
        self.id = id;
        self.nome = nome;
        self.blocos = blocos;
        self.valor = valor;
        self.profissionais = profissionais;
        print("\nCreated Servico with Id: \(id), nome: \(nome), blocos: \(blocos), valor: \(valor), profisisonalId: \(profissionais)")

    }
    
    deinit
    {
        self.id = nil;
        self.nome = nil;
        self.blocos = nil;
        self.valor = nil;
        self.profissionais = [];
    }
}
