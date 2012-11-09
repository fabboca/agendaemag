select * from agendamento
    where agendamento.data = :data
      and (agendamento.horainicio <= :horaini and agendamento.horafinal  >= :horafim)
       or (agendamento.horainicio >= :horaini and agendamento.horafinal  >= :horafim and agendamento.horainicio <= :horafim)
       or (agendamento.horainicio >= :horaini and agendamento.horafinal  <= :horafim and agendamento.horainicio <= :horafim)
       or (agendamento.horainicio <= :horaini and agendamento.horafinal  <= :horafim and agendamento.horafinal  <= :horafim)
