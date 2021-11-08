class Linea{
	var packs
	var cantConsumos
	var serviciosRealizados
	var numero
	var tipoLinea
	var hoy = new Date()
	
	method realizarLlamada(duracionSeg){
		serviciosRealizados.add(new ConsumoLlamada(duracion = duracionSeg))
		(self.packsQueSatisfacenConsumo(duracionSeg)).last({pack => pack.consumirPack(duracionSeg)})
	}
	
	method utilizarInternet(cantidadMb){
		serviciosRealizados.add(new ConsumoInternet(cantMb = cantidadMb))
		(self.packsQueSatisfacenConsumo(cantidadMb)).last({pack => pack.consumirPack(cantidadMb)})
	}
	
	
	method puedeRealizarConsumo(tipoConsumo){
		return packs.any({pack => pack.puedeSatisfacerConsumo(tipoConsumo)})
	}
	
	
	method packsQueSatisfacenConsumo(consumo){
		return packs.filter({pack => pack.puedeSatisfacer(consumo)})
	}
	
	
	
	
	method gastoUltimoMes(){
		return self.costoAcumuladoEntre(hoy, hoy.minusDays(30))
	}
	
	method consumoPromedio(fechaInicial, fechaFinal){
		return self.costoAcumuladoEntre(fechaInicial, fechaFinal) / self.cantidadDeConsumosEntre(fechaInicial, fechaFinal)
	}
	
	method costoAcumuladoEntre(fechaInicial, fechaFinal){
		return (self.consumosRealizadosEntre(fechaInicial, fechaFinal)).sum({consumo => consumo.costo()})
	}
    
    method cantidadDeConsumosEntre(fechaInicial, fechaFinal){
    	return (self.consumosRealizadosEntre(fechaInicial, fechaFinal)).size()
    }
	
	method consumosRealizadosEntre(fechaInicial, fechaFinal){
	   return serviciosRealizados.filter({consumo => consumo.estaEntreFechas(fechaInicial, fechaFinal)})
	}
	
}


object pdepfoni{
	const costoLlamada = 0.05
	const costoFijoLlamada = 1
	const costoMb = 0.10
	
	method costoLlamada(duracion){
		return costoFijoLlamada + ((duracion - 30).max(0)*costoLlamada) 
	}
	
	method costoInternet(cantidad){
		return cantidad * costoMb
	}
	
	
	
}

class Consumo{
	const fecha = new Date()
	
	method estaEntreFechas(fechaInicial, fechaFinal) = fecha.between(fechaInicial, fechaFinal)
		
	
}


class ConsumoLlamada inherits Consumo{
	var property duracion
	
	method costo(){
		return pdepfoni.costoLlamada(duracion)
	}
	
	
	
}

class ConsumoInternet inherits Consumo{
	var property cantMb
	
	method costo(){
		return pdepfoni.costoInternet(cantMb)
	}

}


class Pack{
	const fechaDeContratacion 
	var cantidadOfrecida
	var tipoPack /* Puede ser internet, llamadas o credito */
	
	method puedeSatisfacerConsumo(consumo){ 
	 if(!self.estaVencido()){
	 	return tipoPack.cubreConsumo(consumo, cantidadOfrecida)		
	 }
	 throw new DomainException(message = "El pack esta vencido")		
    }
    
    method estaVencido(){
    	return calendario.pasoElPlazo(fechaDeContratacion)
    }
    
    method consumirPack(consumo){
    	 cantidadOfrecida = cantidadOfrecida - consumo
    }
    
}

object calendario{
	const fechaActual = new Date()
	
	method pasoElPlazo(fecha){
		return fecha > fechaActual
	} 
	
	
}


object llamadasEInternet{
	
	method cubreConsumo(consumo, cantidadOfrecida){
		return cantidadOfrecida > consumo
	}
	
}

object credito{
	
	method cubreConsumo(consumo, cantidadOfrecida){
		return cantidadOfrecida > consumo.costo()
	}
	
}
	


