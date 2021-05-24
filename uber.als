module uberUFCG

--------------------- CORRIDA ---------------------
sig Corrida {
--pelo menos um passageiro
	passageiros: some Usuario,
	motorista: one Usuario,
	ida: one Ida,
	horarioIda: one HorarioIda,
	volta: one Volta,
	horarioVolta: one HorarioVolta
}

sig Ida {
	regiao: one Regiao
}

sig Volta {
	regiao: one Regiao
}

--------------------- USUÁRIO ---------------------
sig Usuario {
	credito: set Credito,
	debito: set Debito
}

sig Servidor extends Usuario {

}

sig Aluno extends Usuario {

}

sig Professor extends Usuario {

}

--------------------- PAGAMENTO ---------------------
sig Credito {

}

sig Debito {

}
--------------------- REGIÃO ---------------------
abstract sig Regiao {

}

one sig CENTRO, NORTE, LESTE, OESTE, SUL extends Regiao {

}

--------------------- HORÁRIO ---------------------
abstract sig HorarioIda {

}

one sig _7_30, _9_30, _13_30, _15_30 extends HorarioIda {

}

abstract sig HorarioVolta{

}

one sig _10_00, _12_00, _16_00, _18_00 extends HorarioVolta {

}

--------------------- FATOS ---------------------
fact RegrasCorrida {
	#Corrida > 4
	#Usuario > 3

--qualquer corrida tem no maximo 3 passageiros
	all c: Corrida | #(c.passageiros) <= 3
--toda corrida deve haver um motorista
	all motorista: Usuario | one motorista
--uma corrida so pode ter uma ida
	all c: Corrida | #(c.ida) <= 1
--uma corrida so pode ter uma volta
	all c: Corrida | #(c.volta) <= 1
--corridas com o mesmo motorista possuem horario diferente
	all c1: Corrida, c2: Corrida | (c1 != c2) and ((c1.motorista = c2.motorista) or #(c1.passageiros & c2.passageiros) != 0) implies c1.horarioIda != c2.horarioIda and c1.horarioVolta != c2.horarioVolta
--caso o motorista seja passageiro de outra corrida, essas corridas devem ocorrer em horários diferentes
	all c1: Corrida, c2: Corrida | (c1 != c2) and  ((c1.motorista in c2.passageiros) or (c2.motorista in c1.passageiros))  implies c1.horarioIda != c2.horarioIda and c1.horarioVolta != c2.horarioVolta
--quantidade de vezes que foi motorista é o crédito e a quantidade de vezes que foi passageiro é o débito
	all p: Usuario | (#motorista.p = #p.credito) and (#passageiros.p = #p.debito)
--o motorista não pode ser um dos passageiros
	all c: Corrida | c.motorista not in c.passageiros
--credito único
	all ce: Credito | #credito.ce = 1
}

--------------------- SHOW ---------------------
pred show[]{}
run show for 5
