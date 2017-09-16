
import UIKit

class Profissional: NSObject
{
    var id:String!
    var funcao:String!
    var nome:String!
    
    init(id:String, funcao:String, nome:String)
    {
        self.id = id;
        self.funcao = funcao;
        self.nome = nome;
        
        print("\nCreated Profissional with Id: \(id), nome: \(nome), funcao: \(funcao)")
    }
    
    deinit
    {
        self.id = nil;
        self.funcao = nil;
        self.nome = nil;
    }
}
