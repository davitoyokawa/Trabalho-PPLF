doença(h1n1).
doença(gripe).
doença(rinite_alergica).
doença(enxaqueca).
doença(alergia_alimentar).
doença(bronquite).
doença(asma).
doença(cistite).
doença(otite).
doença(sinusite).
doença(tendinite).
doença(bursite).
doença(gastrite).
doença(ulcera_peptica).
doença(colite).
doença(gastrite).
doença(dengue).
doença(malária).
doença(hipertensão_arterial).
doença(anemia_ferropriva).
doença(hipotireoidismo).

tratamento_da_doenca(h1n1, 'O tratamento para H1N1 geralmente inclui repouso, ingestão de líquidos, medicamentos para aliviar os sintomas e, em alguns casos, antivirais. Consulte um médico para obter orientação específica sobre o seu caso.').
tratamento_da_doenca(gripe, 'O tratamento para a gripe geralmente inclui repouso, ingestão de líquidos, medicamentos para aliviar os sintomas, como febre e dores no corpo, e, em alguns casos, antivirais. Consulte um médico para obter orientação específica sobre o seu caso.').
tratamento_da_doenca(rinite_alergica, 'O tratamento para rinite alérgica inclui evitar os alérgenos, medicamentos anti-histamínicos e corticosteroides nasais.').
tratamento_da_doenca(enxaqueca, 'O tratamento para enxaqueca inclui analgésicos, medicamentos anti-inflamatórios e triptanos para alívio da dor.').
tratamento_da_doenca(alergia_alimentar, 'O tratamento para alergias alimentares envolve evitar os alimentos desencadeantes e, em alguns casos, medicamentos para controlar os sintomas.').
tratamento_da_doenca(bronquite, 'O tratamento para bronquite aguda geralmente inclui repouso, aumento da ingestão de líquidos, medicamentos para aliviar a tosse e, em alguns casos, broncodilatadores.').
tratamento_da_doenca(asma, 'O tratamento para asma inclui medicamentos broncodilatadores para alívio rápido dos sintomas e corticosteroides inalados para controle a longo prazo da inflamação das vias aéreas.').
tratamento_da_doenca(cistite, 'O tratamento para cistite geralmente inclui antibióticos, aumento da ingestão de líquidos e analgésicos para alívio da dor e ardor ao urinar.').
tratamento_da_doenca(otite, 'O tratamento para otite geralmente inclui analgésicos para alívio da dor e, em alguns casos, antibióticos se a infecção for bacteriana.').
tratamento_da_doenca(sinusite, 'O tratamento para sinusite inclui analgésicos, descongestionantes, lavagem nasal com soro fisiológico e, em alguns casos, antibióticos.').
tratamento_da_doenca(tendinite, 'O tratamento para tendinite geralmente inclui repouso, aplicação de gelo, medicamentos anti-inflamatórios e fisioterapia para fortalecimento muscular.').
tratamento_da_doenca(bursite, 'O tratamento para bursite inclui repouso, aplicação de gelo, medicamentos anti-inflamatórios e, em alguns casos, injeções de corticosteroides na bursa afetada.').
tratamento_da_doenca(gastrite, 'O tratamento para gastrite inclui evitar alimentos irritantes, medicamentos para reduzir a produção de ácido no estômago e, em alguns casos, antibióticos para tratar a infecção por H. pylori.').
tratamento_da_doenca(ulcera_peptica, 'O tratamento para úlcera péptica inclui evitar alimentos irritantes, medicamentos para reduzir a produção de ácido no estômago e, em alguns casos, antibióticos para tratar a infecção por H. pylori.').
tratamento_da_doenca(colite, 'O tratamento para colite inclui mudanças na dieta, medicamentos para controlar a inflamação e os sintomas, e, em alguns casos, terapia imunossupressora.').
tratamento_da_doenca(dengue, 'O tratamento para dengue inclui repouso, hidratação adequada, controle da febre e, em casos graves, hospitalização para tratamento de complicações.').
tratamento_da_doenca(malária, 'O tratamento para malária inclui medicamentos antimaláricos prescritos pelo médico, geralmente administrados por via oral ou intravenosa, dependendo da gravidade da infecção.').
tratamento_da_doenca(hipertensão_arterial, 'Mudanças no estilo de vida, como dieta saudável e redução do consumo de sal. Uso de medicamentos anti-hipertensivos conforme orientação médica.').
tratamento_da_doenca(anemia_ferropriva, 'Suplementação de ferro, aumento da ingestão de alimentos ricos em ferro, como carne vermelha, vegetais de folhas escuras e leguminosas. Tratamento da causa subjacente, se aplicável.').
tratamento_da_doenca(hipotireoidismo, 'Uso de levotiroxina para repor os níveis hormonais adequados da tireoide. Ajustes na dosagem conforme monitoramento dos níveis hormonais. Tratamento de sintomas e complicações associadas.').


% Defina os sintomas conhecidos para cada doença
sintomas_da_doenca(h1n1, [nausea, calafrios, febre, tosse, dor_de_garganta, nariz_entupido, dores_no_corpo, fadiga, diarreia, vomito]).
sintomas_da_doenca(gripe, [febre, calafrios, dor_de_garganta, tosse, congestão_nasal, dores_no_corpo, fadiga, dor_de_cabeça]).
sintomas_da_doenca(rinite_alergica, [espirros, coriza, coceira_no_nariz, congestão_nasal]).
sintomas_da_doenca(enxaqueca, [dor_de_cabeça, sensibilidade_a_luz, sensibilidade_ao_som, nausea, vomito]).
sintomas_da_doenca(alergia_alimentar, [coceira_na_pele, urticária, inchaço, cólicas, diarreia]).
sintomas_da_doenca(bronquite, [tosse, falta_de_ar, chiado_no_peito, produção_de_catarro]).
sintomas_da_doenca(asma, [tosse, falta_de_ar, chiado_no_peito, aperto_no_peito]).
sintomas_da_doenca(cistite, [ardor_ao_urinar, aumento_da_frequência_urinária, urgência_urinária, dor_abdominal]).
sintomas_da_doenca(otite, [dor_no_ouvido, sensação_de_ouvido_cheio, perda_auditiva, febre]).
sintomas_da_doenca(sinusite, [dor_facial, dor_de_cabeça, congestão_nasal, secreção_nasal_espessa]).
sintomas_da_doenca(tendinite, [dor_na_região_afetada, inchaço, rigidez, diminuição_da_força_muscular]).
sintomas_da_doenca(bursite, [dor_na_região_afetada, inchaço, vermelhidão, diminuição_da_mobilidade]).
sintomas_da_doenca(gastrite, [dor_abdominal, queimação_no_estômago, nausea, vomito, falta_de_apetite]).
sintomas_da_doenca(ulcera_peptica, [dor_abdominal, queimação_no_estômago, nausea, vomito, sangramento_gástrico]).
sintomas_da_doenca(colite, [dor_abdominal, diarreia, sangue_nas_fezes, urgência_defecatória]).
sintomas_da_doenca(dengue, [febre, dor_de_cabeça, dor_nas_costas, dor_nas_articulações, nausea, vomito, manchas_vermelhas_na_pele]).
sintomas_da_doenca(malária, [febre, calafrios, sudorese, dor_de_cabeça, nausea, vomito, dor_muscular]).
sintomas_da_doenca(hipertensão_arterial, [dor_de_cabeça, tontura, visão_embaçada, dor_no_peito, falta_de_ar]).
sintomas_da_doenca(anemia_ferropriva, [fadiga, fraqueza, palidez, falta_de_ar, tontura, dor_de_cabeça]).
sintomas_da_doenca(hipotireoidismo, [fadiga, ganho_de_peso, sensibilidade_ao_frio, pele_seca, cabelos_quebradiços, prisão_de_ventre]).


