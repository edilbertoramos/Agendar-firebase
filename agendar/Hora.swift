//
//  Hora.swift
//  agendar
//
//  Created by EDILBERTO DA SILVA RAMOS JUNIOR on 31/10/16.
//  Copyright © 2016 EDILBERTO DA SILVA RAMOS JUNIOR. All rights reserved.
//

import UIKit

class Hora: NSObject
{

}
extension NSDate
{
    // Comparando datas
    static func menorIgual(lhs: Date, rhs: Date) -> Bool
    {return lhs.timeIntervalSince1970 <= rhs.timeIntervalSince1970}
    
    static func maiorIgual(lhs: Date, rhs: Date) -> Bool
    {return lhs.timeIntervalSince1970 >= rhs.timeIntervalSince1970}
    
    static func maior(lhs: Date, rhs: Date) -> Bool
    {return lhs.timeIntervalSince1970 > rhs.timeIntervalSince1970}
    
    static func menor(lhs: Date, rhs: Date) -> Bool
    {return lhs.timeIntervalSince1970 < rhs.timeIntervalSince1970}
    
    static func igual(lhs: Date, rhs: Date) -> Bool
    {return lhs.timeIntervalSince1970 == rhs.timeIntervalSince1970}
    
    static func dataNoPeriodo(data: Date, inicio: Date, fim:Date) -> Bool
    {return NSDate.maiorIgual(lhs: data, rhs: inicio) && NSDate.menorIgual(lhs: data, rhs: fim)}
    
    //Convertendo datas
    func hr_final(hr_inicial: String, blocos: NSNumber) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"

        let strDate = dateFormatter.date(from: hr_inicial)
        let h = Int(blocos)*30*60
        let i = strDate?.addingTimeInterval(TimeInterval(h))
        
        return dateFormatter.string(from: i!)
    }
    
    func duracao(blocos: NSNumber) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        
        let i = dateFormatter.date(from: "00:00")
        let duracao = i?.addingTimeInterval(TimeInterval(Int(blocos)*30*60))
        
        return dateFormatter.string(from: duracao!)
    }
    
    func gera_horarios(hr_inicio:String, hr_fim:String) -> [HorarioDisponivel]
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        
        var strDate = dateFormatter.date(from: hr_inicio)
        let hf = dateFormatter.date(from: hr_fim)
        var horarios:[HorarioDisponivel] = []
        
        let h = 30*60
        var hi = strDate
        repeat
        {
            
            horarios.append(HorarioDisponivel(horario: dateFormatter.string(from: hi!), marcado: false, habilitado: true))
            hi = strDate?.addingTimeInterval(TimeInterval(h))
            strDate = hi
            
        }while NSDate.menor(lhs: hi!, rhs: hf!)
        
        return horarios
    }
    
    func edita_horarios(hr_inicio_ag:String, blocos_ag:NSNumber, horarios:[HorarioDisponivel], blocos_servico:NSNumber) -> [HorarioDisponivel]
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"

        let i_ag = dateFormatter.date(from: hr_inicio_ag)
        let f_ag = dateFormatter.date(from: NSDate().hr_final(hr_inicial: hr_inicio_ag, blocos: blocos_ag))
        var horarios_disponiveis:[HorarioDisponivel] = []
        
        for hd in horarios
        {
            if hd.habilitado == true
            {
                let hi = dateFormatter.date(from: hd.horario)
                let hf = dateFormatter.date(from: NSDate().hr_final(hr_inicial: hd.horario, blocos: blocos_servico))
            
                if !(NSDate.maiorIgual(lhs: hi!, rhs: f_ag!) || NSDate.menorIgual(lhs: hf!, rhs: i_ag!))
                {
                    hd.habilitado = false
                }
            }
            
            horarios_disponiveis.append(hd)
        }

        return horarios_disponiveis
    }
}
