//
//  HorarioDisponivel.swift
//  agendar
//
//  Created by EDILBERTO DA SILVA RAMOS JUNIOR on 31/10/16.
//  Copyright © 2016 EDILBERTO DA SILVA RAMOS JUNIOR. All rights reserved.
//

import UIKit

class HorarioDisponivel: NSObject
{
    
    var horario:String!
    var marcado:Bool!
    var habilitado:Bool!
    //var profissionais:[Profissional]
    
    init(horario:String, marcado: Bool, habilitado: Bool)//, profissionais:[Profissional])
    {
        self.horario = horario;
        self.marcado = marcado;
        self.habilitado = habilitado;
        print("\nCreated Servico with Horario: \(horario), Marcado: \(marcado), Habilitado: \(habilitado)")
        
    }
    
    func edit(marcado:Bool)
    {
        self.marcado = marcado
        
        print("\nEdited Servico with Horario: \(horario), Marcado: \(marcado)")
    }
    func editHabilitado(habilitado:Bool)
    {
        self.habilitado = habilitado
        
        print("\nEdited Servico with Horario: \(horario), Marcado: \(marcado)")
    }
    
    deinit
    {
        
        self.horario = nil
        self.marcado = nil
        self.habilitado = nil
        
        print("\nRemove Servico with Horario: \(horario), Marcado: \(marcado)")


    }

}
