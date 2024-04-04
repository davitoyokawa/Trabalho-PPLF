:- use_module(library(plunit)).
:- include('base_dados.pl').

:- nl, tab(60), write("Bem-vindo ao Diagnóstico de Saúde!").
:- nl, nl, write("Sua saúde geral engloba todos os aspectos do seu bem-estar físico e mental. Ela influencia como você se sente, pensa e age, afetando sua qualidade de vida e suas interações diárias. Manter uma boa saúde é fundamental para desfrutar plenamente da vida.").
:- nl, write("Muitos fatores contribuem para a sua saúde geral, como: ").
:- nl, tab(5), write("Hábitos de vida, como dieta, tempo de sono, rotina e exercícios físicos").
:- nl, tab(5), write("Fatores genéticos").
:- nl, tab(5), write("Saúde mental").
:- nl, tab(5), write("Ambiente físico e social.").
:- nl, write("Problemas de saúde geral podem variar desde condições comuns, como resfriados e gripes, até condições crônicas mais sérias, como diabetes e hipertensão arterial.").
:- nl, write("A boa notícia é que muitas condições de saúde geral podem ser prevenidas ou controladas com hábitos saudáveis e cuidados adequados.").
:- nl, nl, write("O objetivo do Diagnóstico de Saúde é ajudar a identificar possíveis problemas de saúde com base nos sintomas relatados pelo usuário e dar recomendações sobre o que fazer. Ele não substitui a consulta a um profissional de saúde qualificado, mas pode fornecer informações úteis para discussão durante uma consulta médica.").
:- nl, nl, write("Para iniciar o sistema, digite 'iniciar.' e pressione Enter.").

% Função de inicialização
iniciar :-
write('Digite a opção do menu com um ponto no final, já para as informações do paciente, pode digitar normalmente sem essas considerações'),nl,
menu.

% Menu
menu :- write('\n--- Sistema médico --- \n'),
        write('0. - Sair\n'),
        write('1. - Cadastrar paciente\n'),
        write('2. - Alterar dados paciente\n'),
        write('3. - Vizualizar dados paciente\n'),
        write('4. - Remover paciente\n'),
        write('5. - Listar pacientes\n'),
        write('6. - Diagnóstico médico\n'),
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
Op =@= 6, obter_sintomas, tab(10), write('\nEste resultado é apenas uma probabilidade baseado nos seus sintomas, consulte um médico para obter um diagnóstico correto e preciso.\n\n'), menu.

% FUNÇÕES AUXILIARES
% Função para ler entradas do usuario sem ponto final
ler_input(Var) :-
    get_char(_),
    read_string(user_input, "\n", "\r\t", _, Var).

% Função para printar uma lista de pacientes
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

% Função para escrever uma lista no arquivo
escrever_arquivo(Lista) :-
    working_directory(CWD, CWD),
    PacienteFile = '/pacientes.txt',
    atom_concat(CWD, PacienteFile, Arquivo),
    open(Arquivo, write, Pfile),
    write_file(Lista, Pfile),
    close(Pfile).

% Função para escrever uma lista no arquivo
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

% Função para verificar se existe um paciente
check_paciente_existe([X | Y], Nome, Paciente) :-
    split_string(X, ",", "", [NomeP, DataP, CpfP]),
    Nome == NomeP ->
    Paciente = X,
    write('\nPaciente encontrado no sistema:\n'),nl,
    write('Nome: '), write(NomeP), nl,
    write('Data de nascimento: '), write(DataP), nl,
    write('Cpf do paciente: '), write(CpfP), nl;
    check_paciente_existe(Y, Nome, Paciente).

check_paciente_existe([], _, '') :- write('\nPaciente não encontrado\n'), !.

% Função para ler o arquivo de pacientes e salvar em uma lista
ler_arquivo_pacientes(Stream,[]) :-
    at_end_of_stream(Stream).

ler_arquivo_pacientes(Stream,[X|L]) :-
    \+ at_end_of_stream(Stream),
    read(Stream,X),
    ler_arquivo_pacientes(Stream,L).


% FUNÇÕES CRUD
% Função para alterar dados do paciente
alterarPaciente :-
    write('Digite o Nome do paciente que deseja alterar (Sem ".")'),
    ler_input(Nome),
    get_paciente(Nome, Paciente),
    Paciente \== '' ->
    get_all_pacientes(Pacientes), nl,
    write('Qual dado deseja alterar?: '),
    quest_alterar_paciente(Pacientes, Paciente); menu.

% Menu para alteração de dados do paciente
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

% Função para inserir um paciente no arquivo pacientes.txt
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

% Função para cadastrar um paciente no arquivo pacientes.txt
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

% Função para consultar um paciente
consultarPaciente :-
    get_nome_paciente(Nome),
    get_paciente(Nome, _).

% Função para remover um paciente
removerPaciente :-
    write('Digite o nome do paciente que deseja remover(Sem "."): '),
    ler_input(NomePaciente),
    get_paciente(NomePaciente, Paciente),
    Paciente \== '' ->
    get_all_pacientes(Pacientes),
    delete(Pacientes, Paciente, Result),
    write('\nPaciente removido com sucesso!\n'),
    escrever_arquivo(Result); menu.

% Função para perguntar o nome do paciente
get_nome_paciente(Nome) :-
    write('Digite o nome do paciente a ser consultado: (Sem ponto no final)'),
    ler_input(Nome).

% Função para encontrar o paciente
get_paciente(Nome, Paciente) :-
    get_all_pacientes(Pacientes),
    check_paciente_existe(Pacientes, Nome, Paciente).

% Função para retornar uma lista de todos os pacientes
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

% FUNÇÕES PARA O DIAGNÓSTICO
% Função para adicionar um elemento a uma lista
adicionar_elemento(Elemento, Lista, NovaLista) :-
    append(Lista, [Elemento], NovaLista).

% Função para obter os sintomas do usuário
obter_sintomas :-
write('Responda as seguintes perguntas com "s" se ter o sintoma, "n" caso contrário, seguido de ".":'), nl,
    Sintomas = [nausea, calafrios, febre, tosse, dor_de_garganta, nariz_entupido, dores_no_corpo, fadiga, diarreia, vomito,
            congestão_nasal, dor_de_cabeça, espirros, coriza, coceira_no_nariz, sensibilidade_a_luz, sensibilidade_ao_som,
            coceira_na_pele, urticária, inchaço, cólicas, falta_de_ar, chiado_no_peito, produção_de_catarro, aperto_no_peito,
            ardor_ao_urinar, aumento_da_frequência_urinária, urgência_urinária, dor_abdominal, sensação_de_ouvido_cheio,
            perda_auditiva, secreção_nasal_espessa, dor_facial, rigidez, diminuição_da_força_muscular, vermelhidão, fraqueza,
            diminuição_da_mobilidade, queimação_no_estômago, falta_de_apetite, sangramento_gástrico, sangue_nas_fezes,
            urgência_defecatória, dor_nas_costas, dor_nas_articulações, dor_no_ouvido, dor_na_região_afetada,
            manchas_vermelhas_na_pele, sudorese, dor_muscular, tontura, visão_embaçada, dor_no_peito, palidez,
            ganho_de_peso, sensibilidade_ao_frio, pele_seca, cabelos_quebradiços, prisão_de_ventre],
    obter_sintomas_aux(Sintomas, [], Paciente),
    diagnosticar_todas_doencas(Paciente).

obter_sintomas_aux([], Paciente, Paciente).
obter_sintomas_aux([Sintoma|Resto], PacienteAtual, Paciente) :-
    obter_sintoma(Sintoma, PacienteAtual, NovaLista),
    obter_sintomas_aux(Resto, NovaLista, Paciente).

% Função para obter a resposta do usuário para um sintoma específico
obter_sintoma(Sintoma, Paciente, NovaLista) :-
    write('Você está sentindo '), write(Sintoma), write('? (s/n)'), nl, nl,
    read(Resposta),nl,
    (Resposta == 's' -> adicionar_elemento(Sintoma, Paciente, NovaLista); NovaLista = Paciente).

% Função para fazer o diagnóstico para todas as doenças conhecidas
diagnosticar_todas_doencas(Paciente) :-
    findall([Doenca, Porcentagem], (doença(Doenca), verificar_doenca_pela_porcentagem(Paciente, Doenca, Porcentagem)), ListaDiagnósticos),
    sort(2, @>=, ListaDiagnósticos, ListaOrdenada), % Ordena a lista de diagnósticos pela porcentagem em ordem decrescente
    tab(20), write('Avaliando seus sintomas e calculando as probabilidades das doenças...'), nl, nl,
    sleep(2),
    imprimir_diagnósticos(Paciente, ListaOrdenada).

% Função para imprimir os diagnósticos ordenados por probabilidade
imprimir_diagnósticos(_, []).
imprimir_diagnósticos(Paciente, [[Doenca, Porcentagem]|Resto]) :-
    sintomas_da_doenca(Doenca, Sintomas),
    tratamento_da_doenca(Doenca, Tratamento),
    tab(60), write('\e[34m'), write(Doenca), write('\e[0m'), nl,
    tab(20), write('Sintomas da doença '), write(Doenca), write(': '), imprimir_sintomas(Sintomas), nl,
    tab(20), sintomas_da_doenca(Doenca, SintomasDaDoenca),
    imprimir_sintomas_comuns(Paciente, SintomasDaDoenca), nl,
    (Porcentagem > 15 ->
        (Porcentagem >= 60 ->
            tab(40), ansi_format([bold,fg(red)],'Você está em risco para ~w. Probabilidade: ~w%',[Doenca, Porcentagem]), nl, nl,
            write('Tratamento: '), write(Tratamento), nl, nl, sleep(2), !;
            tab(40), ansi_format([bold,fg(yellow)],'Pouco risco para ~w. Probabilidade: ~w%',[Doenca, Porcentagem]),
            nl, nl, sleep(1), !
        );
        tab(40), ansi_format([bold,fg(green)],'Sem riscos para ~w. Probabilidade: menor que 15%',[Doenca]), nl, nl, sleep(0.5), !
    ),
    write('----------------------------------------------------------------------------------------------------------------------------------------------------------------------'),
    imprimir_diagnósticos(Paciente, Resto).

% Função para fazer intersecção dos sintomas do paciente e da doença
imprimir_sintomas_comuns(Paciente, SintomasDaDoenca) :-
    intersection(Paciente, SintomasDaDoenca, SintomasComuns),
    write('Sintomas que você apresenta da doença: '),
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

% Função que verifica a % do paciente ter uma doença
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
    verificar_doenca_pela_porcentagem([febre, calafrios,dor_de_garganta, tosse, congestão_nasal, dores_no_corpo, fadiga, dor_de_cabeça],gripe, 100).

test(verificar_doenca_pela_porcentagem_50) :-
    verificar_doenca_pela_porcentagem([febre, dor_de_cabeça, tosse, calafrios], gripe, 50.0).

test(verificar_doenca_pela_porcentagem_25) :-
    verificar_doenca_pela_porcentagem([febre, dor_de_cabeça], gripe, 25.0).

test(verificar_doenca_pela_porcentagem_0) :-
    verificar_doenca_pela_porcentagem([tontura, náusea], gripe, 0).

:- end_tests(verificar_doenca_pela_porcentagem).

meus_tests :-
    run_tests(contar_intersecoes),
    run_tests(verificar_doenca_pela_porcentagem).









