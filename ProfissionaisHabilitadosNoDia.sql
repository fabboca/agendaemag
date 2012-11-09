select

    profissionalporsessao.idprofissional,
    profissional.nomeprofissional,
    diadasemana.descricaodiasemana,
    escalaprofissional.idescalatrabalho,
    escalatrabalho.entrada1,
    escalatrabalho.saida1,
    escalatrabalho.entrada2,
    escalatrabalho.saida2,
    escalatrabalho.entrada3,
    escalatrabalho.saida3,
    escalatrabalho.entrada4,
    escalatrabalho.saida4

    from profissionalporsessao

   inner join escalaprofissional on escalaprofissional.idprofissional = profissionalporsessao.idprofissional
   inner join profissional on profissional.idprofissional = profissionalporsessao.idprofissional
   inner join escalaprofissional on (escalaprofissional.idprofissional = profissionalporsessao.idprofissional)
   inner join diadasemana on diadasemana.iddiadasemana = escalaprofissional.iddiadasemana
   inner join escalatrabalho on escalatrabalho.idescalatrabalho = escalaprofissional.idescalatrabalho

   where profissionalporsessao.idsessao = :idSessao
     and escalaprofissional.iddiadasemana = :diaSemana
