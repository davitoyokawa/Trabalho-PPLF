:- use_module(library(plunit)).
:- include('base_dados.pl').

:- nl, tab(60), write("Bem-vindo ao Diagn�stico de Sa�de!").
:- nl, nl, write("Sua sa�de geral engloba todos os aspectos do seu bem-estar f�sico e mental. Ela influencia como voc� se sente, pensa e age, afetando sua qualidade de vida e suas intera��es di�rias. Manter uma boa sa�de � fundamental para desfrutar plenamente da vida.").
:- nl, write("Muitos fatores contribuem para a sua sa�de geral, como: ").
:- nl, tab(5), write("H�bitos de vida, como dieta, tempo de sono, rotina e exerc�cios f�sicos").
:- nl, tab(5), write("Fatores gen�ticos").
:- nl, tab(5), write("Sa�de mental").
:- nl, tab(5), write("Ambiente f�sico e social.").
:- nl, write("Problemas de sa�de geral podem variar desde condi��es comuns, como resfriados e gripes, at� condi��es cr�nicas mais s�rias, como diabetes e hipertens�o arterial.").
:- nl, write("A boa not�cia � que muitas condi��es de sa�de geral podem ser prevenidas ou controladas com h�bitos saud�veis e cuidados adequados.").
:- nl, nl, write("O objetivo do Diagn�stico de Sa�de � ajudar a identificar poss�veis problemas de sa�de com base nos sintomas relatados pelo usu�rio e dar recomenda��es sobre o que fazer. Ele n�o substitui a consulta a um profissional de sa�de qualificado, mas pode fornecer informa��es �teis para discuss�o durante uma consulta m�dica.").
:- nl, nl, write("Para iniciar o sistema, digite 'iniciar.' e pressione Enter.").

% Fun��o de inicializa��o
iniciar :-
write('Digite a op��o do menu com um ponto no final, j� para as informa��es do paciente, pode digitar normalmente sem essas considera��es'),nl,
menu.

% Menu
menu :- write('\n--- Sistema m�dico --- \n'),
        write('0. - Sair\n'),
        write('1. - Cadastrar paciente\n'),
        write('2. - Alterar dados paciente\n'),
        write('3. - Vizualizar dados paciente\n'),
        write('4. - Remover paciente\n'),
        write('5. - Listar pacientes\n'),
        write('6. - Diagn�stico m�dico\n'),
        read(Op),
        selectOp(Op).

% Gerenciador do Menu
selectOp(Op):-
Op =@= 0, write('Programa encerrado.\n');
Op =@= 1, cadastrarPaciente, menu;
Op =@= 2, alterarPaciente, menu;
Op =@= 3, consultarPaciente, menu;
Op =@= 4, removerPaciente, menu;
Op =@= 5, listarPacientes, menu;
Op =@= 6, obter_sintomas, tab(10), write('\nEste resultado � apenas uma probabilidade baseado nos seus sintomas, consulte um m�dico para obter um diagn�stico correto e preciso.\n\n'), menu.

% FUN��ES AUXILIARES
% Fun��o para ler entradas do usuario sem ponto final
ler_input(Var) :-
    get_char(_),
    read_string(user_input, "\n", "\r\t", _, Var).

% Fun��o para printar uma lista de pacientes
printaListPaciente([]).

printaListPaciente([X|Y]) :-
    split_string(X, ",", "", Z),
    printaPaciente(Z),
    printaListPaciente(Y).

printaPaciente(List) :-
    length(List, 1), !;
    nl, write('Nome: '),
    nth0(0, List, Nome),
    write(Nome), nl,
    nth0(1, List, DataNasc),
    nth0(2, List, Cpf),
    write('Data de nascimento: '),
    write(DataNasc), nl,
    write('CPF: '),
    write(Cpf), nl.

% Fun��o para escrever uma lista no arquivo
escrever_arquivo(Lista) :-
    working_directory(CWD, CWD),
    PacienteFile = '/pacientes.txt',
    atom_concat(CWD, PacienteFile, Arquivo),
    open(Arquivo, write, Pfile),
    write_file(Lista, Pfile),
    close(Pfile).

% Fun��o para escrever uma lista no arquivo
write_file([P | Pacientes], Out) :-
    length(Pacientes, 0), !;
    split_string(P, ",", "", [Nome, Data, Cpf]),
    write(Out,'\''),
    write(Out,Nome),
    write(Out,','),
    write(Out,Data),
    write(Out,','),
    write(Out,Cpf),
    write(Out,'\''),
    write(Out,'.'),
    write(Out,'\n'),
    write_file(Pacientes, Out).

write_file([], _).

% Fun��o para verificar se existe um paciente
check_paciente_existe([X | Y], Nome, Paciente) :-
    split_string(X, ",", "", [NomeP, DataP, CpfP]),
    Nome == NomeP ->
    Paciente = X,
    write('\nPaciente encontrado no sistema:\n'),nl,
    write('Nome: '), write(NomeP), nl,
    write('Data de nascimento: '), write(DataP), nl,
    write('Cpf do paciente: '), write(CpfP), nl;
    check_paciente_existe(Y, Nome, Paciente).

check_paciente_existe([], _, '') :- write('\nPaciente n�o encontrado\n'), !.

% Fun��o para ler o arquivo de pacientes e salvar em uma lista
ler_arquivo_pacientes(Stream,[]) :-
    at_end_of_stream(Stream).

ler_arquivo_pacientes(Stream,[X|L]) :-
    \+ at_end_of_stream(Stream),
    read(Stream,X),
    ler_arquivo_pacientes(Stream,L).


% FUN��ES CRUD
% Fun��o para alterar dados do paciente
alterarPaciente :-
    write('Digite o Nome do paciente que deseja alterar (Sem ".")'),
    ler_input(Nome),
    get_paciente(Nome, Paciente),
    Paciente \== '' ->
    get_all_pacientes(Pacientes), nl,
    write('Qual dado deseja alterar?: '),
    quest_alterar_paciente(Pacientes, Paciente); menu.

% Menu para altera��o de dados do paciente
quest_alterar_paciente(Pacientes, Paciente) :-
    split_string(Paciente, ",", "", [Nome, Data, Cpf]), nl,
    write('0. Voltar\n'),
    write('1. Nome\n'),
    write('2. Data de nascimento\n'),
    write('3. CPF\n'),
    read(Opcao),
    alterar_opcao(Opcao,Pacientes, Paciente, Nome, Data, Cpf).

% Alterar Nome
alterar_opcao(1, Pacientes, Paciente, _ ,Data, Cpf) :-
    write('Digite o novo nome do paciente(Sem "."): '),
    ler_input(NovoNome),
    delete(Pacientes, Paciente, Result),
    escrever_arquivo(Result),
    inserir_paciente(NovoNome, Data, Cpf),
    write('\nPaciente atualizado com sucesso!\n').

% Alterar Data de nascimento
alterar_opcao(2, Pacientes, Paciente, Nome, _, Cpf) :-
    write('Digite a nova data de nascimento do paciente(Sem "."): '),
    ler_input(NovaData),
    delete(Pacientes, Paciente, Result),
    escrever_arquivo(Result),
    inserir_paciente(Nome, NovaData, Cpf),
    write('\nPaciente atualizado!\n').

% Alterar CPF
alterar_opcao(3, Pacientes, Paciente, Nome, Data, _) :-
    write('Digite o novo CPF do paciente(Sem "."): '),
    ler_input(NovoCpf),
    delete(Pacientes, Paciente, Result),
    escrever_arquivo(Result),
    inserir_paciente(Nome, Data, NovoCpf),
    write('\nPaciente atualizado!\n').

% Fun��o para inserir um paciente no arquivo pacientes.txt
inserir_paciente(Nome, Data, Cpf) :-
    working_directory(CWD, CWD),
    PacienteFile = '/pacientes.txt',
    atom_concat(CWD, PacienteFile, Arquivo),
    open(Arquivo, append, X),
    write(X, '\''),
    write(X, Nome),
    write(X, ','),
    write(X, Data),
    write(X, ','),
    write(X, Cpf),
    write(X, '\''),
    write(X, '.'),
    write(X, '\n'),
    close(X).

% Fun��o para cadastrar um paciente no arquivo pacientes.txt
cadastrarPaciente :-
    write('Digite o nome do paciente(Sem "."): '),
    ler_input(Nome),
    write('Digite a data de nascimento do paciente(Sem "."): '),
    ler_input(Data),
    write('Digite o CPF do paciente(Sem "."): '),
    ler_input(Cpf),
    inserir_paciente(Nome, Data, Cpf),
    write('\nPaciente cadastrado com sucesso!\n').


% Listar todos os pacientes
listarPacientes :-
    write('\n--- Lista de todos os pacientes cadastrados ---\n'),
    get_all_pacientes(Pacientes),
    printaListPaciente(Pacientes).

% Fun��o para consultar um paciente
consultarPaciente :-
    get_nome_paciente(Nome),
    get_paciente(Nome, _).

% Fun��o para remover um paciente
removerPaciente :-
    write('Digite o nome do paciente que deseja remover(Sem "."): '),
    ler_input(NomePaciente),
    get_paciente(NomePaciente, Paciente),
    Paciente \== '' ->
    get_all_pacientes(Pacientes),
    delete(Pacientes, Paciente, Result),
    write('\nPaciente removido com sucesso!\n'),
    escrever_arquivo(Result); menu.

% Fun��o para perguntar o nome do paciente
get_nome_paciente(Nome) :-
    write('Digite o nome do paciente a ser consultado: (Sem ponto no final)'),
    ler_input(Nome).

% Fun��o para encontrar o paciente
get_paciente(Nome, Paciente) :-
    get_all_pacientes(Pacientes),
    check_paciente_existe(Pacientes, Nome, Paciente).

% Fun��o para retornar uma lista de todos os pacientes
get_all_pacientes(Pacientes) :-
    working_directory(CWD, CWD),
    PacienteFile = '/pacientes.txt',
    atom_concat(CWD, PacienteFile, Arquivo),
    open(Arquivo, read, Pfile),
    current_input(Stream),
    set_input(Pfile),
    ler_arquivo_pacientes(Pfile, Pacientes), !,
    close(Pfile),
    set_input(Stream).

% FUN��ES PARA O DIAGN�STICO
% Fun��o para adicionar um elemento a uma lista
adicionar_elemento(Elemento, Lista, NovaLista) :-
    append(Lista, [Elemento], NovaLista).

% Fun��o para obter os sintomas do usu�rio
obter_sintomas :-
write('Responda as seguintes perguntas com "s" se ter o sintoma, "n" caso contr�rio, seguido de ".":'), nl,
    Sintomas = [nausea, calafrios, febre, tosse, dor_de_garganta, nariz_entupido, dores_no_corpo, fadiga, diarreia, vomito,
            congest�o_nasal, dor_de_cabe�a, espirros, coriza, coceira_no_nariz, sensibilidade_a_luz, sensibilidade_ao_som,
            coceira_na_pele, urtic�ria, incha�o, c�licas, falta_de_ar, chiado_no_peito, produ��o_de_catarro, aperto_no_peito,
            ardor_ao_urinar, aumento_da_frequ�ncia_urin�ria, urg�ncia_urin�ria, dor_abdominal, sensa��o_de_ouvido_cheio,
            perda_auditiva, secre��o_nasal_espessa, dor_facial, rigidez, diminui��o_da_for�a_muscular, vermelhid�o, fraqueza,
            diminui��o_da_mobilidade, queima��o_no_est�mago, falta_de_apetite, sangramento_g�strico, sangue_nas_fezes,
            urg�ncia_defecat�ria, dor_nas_costas, dor_nas_articula��es, dor_no_ouvido, dor_na_regi�o_afetada,
            manchas_vermelhas_na_pele, sudorese, dor_muscular, tontura, vis�o_emba�ada, dor_no_peito, palidez,
            ganho_de_peso, sensibilidade_ao_frio, pele_seca, cabelos_quebradi�os, pris�o_de_ventre],
    obter_sintomas_aux(Sintomas, [], Paciente),
    diagnosticar_todas_doencas(Paciente).

obter_sintomas_aux([], Paciente, Paciente).
obter_sintomas_aux([Sintoma|Resto], PacienteAtual, Paciente) :-
    obter_sintoma(Sintoma, PacienteAtual, NovaLista),
    obter_sintomas_aux(Resto, NovaLista, Paciente).

% Fun��o para obter a resposta do usu�rio para um sintoma espec�fico
obter_sintoma(Sintoma, Paciente, NovaLista) :-
    write('Voc� est� sentindo '), write(Sintoma), write('? (s/n)'), nl, nl,
    read(Resposta),nl,
    (Resposta == 's' -> adicionar_elemento(Sintoma, Paciente, NovaLista); NovaLista = Paciente).

% Fun��o para fazer o diagn�stico para todas as doen�as conhecidas
diagnosticar_todas_doencas(Paciente) :-
    findall([Doenca, Porcentagem], (doen�a(Doenca), verificar_doenca_pela_porcentagem(Paciente, Doenca, Porcentagem)), ListaDiagn�sticos),
    sort(2, @>=, ListaDiagn�sticos, ListaOrdenada), % Ordena a lista de diagn�sticos pela porcentagem em ordem decrescente
    tab(20), write('Avaliando seus sintomas e calculando as probabilidades das doen�as...'), nl, nl,
    sleep(2),
    imprimir_diagn�sticos(Paciente, ListaOrdenada).

% Fun��o para imprimir os diagn�sticos ordenados por probabilidade
imprimir_diagn�sticos(_, []).
imprimir_diagn�sticos(Paciente, [[Doenca, Porcentagem]|Resto]) :-
    sintomas_da_doenca(Doenca, Sintomas),
    tratamento_da_doenca(Doenca, Tratamento),
    tab(60), write('\e[34m'), write(Doenca), write('\e[0m'), nl,
    tab(20), write('Sintomas da doen�a '), write(Doenca), write(': '), imprimir_sintomas(Sintomas), nl,
    tab(20), sintomas_da_doenca(Doenca, SintomasDaDoenca),
    imprimir_sintomas_comuns(Paciente, SintomasDaDoenca), nl,
    (Porcentagem > 15 ->
        (Porcentagem >= 60 ->
            tab(40), ansi_format([bold,fg(red)],'Voc� est� em risco para ~w. Probabilidade: ~w%',[Doenca, Porcentagem]), nl, nl,
            write('Tratamento: '), write(Tratamento), nl, nl, sleep(2), !;
            tab(40), ansi_format([bold,fg(yellow)],'Pouco risco para ~w. Probabilidade: ~w%',[Doenca, Porcentagem]),
            nl, nl, sleep(1), !
        );
        tab(40), ansi_format([bold,fg(green)],'Sem riscos para ~w. Probabilidade: menor que 15%',[Doenca]), nl, nl, sleep(0.5), !
    ),
    write('----------------------------------------------------------------------------------------------------------------------------------------------------------------------'),
    imprimir_diagn�sticos(Paciente, Resto).

% Fun��o para fazer intersec��o dos sintomas do paciente e da doen�a
imprimir_sintomas_comuns(Paciente, SintomasDaDoenca) :-
    intersection(Paciente, SintomasDaDoenca, SintomasComuns),
    write('Sintomas que voc� apresenta da doen�a: '),
    imprimir_sintomas(SintomasComuns),
    nl.

imprimir_sintomas([]) :- write('Nenhum.').
imprimir_sintomas([Sintoma]) :- write(Sintoma).
imprimir_sintomas([Primeiro|Resto]) :-
    write(Primeiro), write(', '),
    imprimir_sintomas(Resto).

contar_intersecoes([], _, 0).
contar_intersecoes([Elemento|Resto], Lista, Total) :-
    member(Elemento, Lista),
    contar_intersecoes(Resto, Lista, N),
    Total is N + 1,
    !.
contar_intersecoes([_|Resto], Lista, Total) :-
    contar_intersecoes(Resto, Lista, Total).

% Fun��o que verifica a % do paciente ter uma doen�a
verificar_doenca_pela_porcentagem(Paciente, Doenca, Porcentagem) :-
    sintomas_da_doenca(Doenca, SintomasDoenca),
    contar_intersecoes(Paciente, SintomasDoenca, TotalRespostasS),
    length(SintomasDoenca, TotalSintomasConhecidos),
    Porcentagem is (TotalRespostasS / TotalSintomasConhecidos) * 100, !.

:- begin_tests(contar_intersecoes).

test(contar_intersecoes_vazio) :-
    contar_intersecoes([], [a, b, c], 0).

test(contar_intersecoes_presente) :-
    contar_intersecoes([a, b], [b, c, d], 1).

test(contar_intersecoes_duplo) :-
    contar_intersecoes([a, b, c], [a, b, c, d, e], 3).

test(contar_intersecoes_nao_presente) :-
    contar_intersecoes([x, y, z], [a, b, c], 0).

:- end_tests(contar_intersecoes).


:- begin_tests(verificar_doenca_pela_porcentagem).

test(verificar_doenca_pela_porcentagem_100) :-
    verificar_doenca_pela_porcentagem([febre, calafrios,dor_de_garganta, tosse, congest�o_nasal, dores_no_corpo, fadiga, dor_de_cabe�a],gripe, 100).

test(verificar_doenca_pela_porcentagem_50) :-
    verificar_doenca_pela_porcentagem([febre, dor_de_cabe�a, tosse, calafrios], gripe, 50.0).

test(verificar_doenca_pela_porcentagem_25) :-
    verificar_doenca_pela_porcentagem([febre, dor_de_cabe�a], gripe, 25.0).

test(verificar_doenca_pela_porcentagem_0) :-
    verificar_doenca_pela_porcentagem([tontura, n�usea], gripe, 0).

:- end_tests(verificar_doenca_pela_porcentagem).

meus_tests :-
    run_tests(contar_intersecoes),
    run_tests(verificar_doenca_pela_porcentagem).









