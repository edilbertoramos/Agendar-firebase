//
//  HorarioDisponivelStore.swift
//  agendar
//
//  Created by EDILBERTO DA SILVA RAMOS JUNIOR on 31/10/16.
//  Copyright © 2016 EDILBERTO DA SILVA RAMOS JUNIOR. All rights reserved.
//

import UIKit

class HorarioDisponivelStore: NSObject
{
    
    func habilita(array: [HorarioDisponivel], marcado:HorarioDisponivel) -> [HorarioDisponivel]
    {
        var t:[HorarioDisponivel] = []
        for h in array
        {
            
            if h.horario == marcado.horario
            {
                h.marcado = true
            }
            else
            {
                h.marcado = false
            }
            
            t.append(h)
        }
        
        return t
    }

}
